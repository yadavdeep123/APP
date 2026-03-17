import 'package:flutter/services.dart';

import '../../core/utils/navigation_utils.dart';
import '../../core/utils/map_utils.dart';
import '../models/route_model.dart';

/// Handles indoor pathfinding using a graph built from a floor GeoJSON asset.
///
/// Convention: each GeoJSON Feature in a floor plan has a "nav_node" property
/// set to true for walkable nodes. Edges are inferred from "nav_edges" array
/// in properties: ["nodeId1", "nodeId2", ...].
class IndoorNavigationService {
  // Cached graphs keyed by "${buildingId}_floor${floorNumber}"
  final Map<String, _FloorGraph> _graphCache = {};

  static const double _stairsFloorTransitionWeight = 8.0;
  static const double _elevatorFloorTransitionWeight = 6.0;

  /// Loads the floor GeoJSON and builds the navigation graph.
  Future<void> loadFloor(String buildingId, int floorNumber,
      String geojsonAssetPath) async {
    final key = '${buildingId}_floor$floorNumber';
    if (_graphCache.containsKey(key)) return;

    final raw = await rootBundle.loadString(geojsonAssetPath);
    final geoJson = MapUtils.parseGeoJson(raw);
    final graph = _FloorGraph.fromGeoJson(geoJson);
    _graphCache[key] = graph;
  }

  /// Loads all provided floor GeoJSON files for a building.
  Future<void> loadBuildingFloors(
    String buildingId,
    Map<int, String> floorGeojsonAssets,
  ) async {
    for (final entry in floorGeojsonAssets.entries) {
      await loadFloor(buildingId, entry.key, entry.value);
    }
  }

  List<IndoorNodeDescriptor> getNavigableNodes(
    String buildingId, {
    bool includeConnectors = false,
  }) {
    final floorGraphs = _getBuildingGraphs(buildingId);
    final result = <IndoorNodeDescriptor>[];

    for (final entry in floorGraphs.entries) {
      final floor = entry.key;
      final graph = entry.value;

      for (final node in graph.nodes) {
        final meta = graph.nodeMeta[node.id];
        final nodeType = meta?.nodeType ?? 'corridor';
        final isConnector = nodeType == 'connector';

        if (!includeConnectors && isConnector) continue;
        if (nodeType == 'corridor') continue;

        result.add(IndoorNodeDescriptor(
          buildingId: buildingId,
          floorNumber: floor,
          nodeId: node.id,
          name: meta?.name ?? node.id,
          nodeType: nodeType,
          longitude: node.lng,
          latitude: node.lat,
          connectorType: meta?.connectorType,
        ));
      }
    }

    result.sort((a, b) {
      final floorCompare = a.floorNumber.compareTo(b.floorNumber);
      if (floorCompare != 0) return floorCompare;
      return a.name.compareTo(b.name);
    });

    return result;
  }

  /// Computes shortest path from [startNodeId] to [endNodeId] on the given
  /// floor. Returns a [RouteModel] or null if no path was found.
  RouteModel? getIndoorRoute({
    required String buildingId,
    required int floorNumber,
    required String startNodeId,
    required String endNodeId,
    required String destinationName,
  }) {
    final key = '${buildingId}_floor$floorNumber';
    final graph = _graphCache[key];
    if (graph == null) return null;

    final pathIds = NavigationUtils.dijkstra(
      nodes: graph.nodes,
      edges: graph.edges,
      startId: startNodeId,
      endId: endNodeId,
    );
    if (pathIds.isEmpty) return null;

    final coords = NavigationUtils.pathToCoordinates(pathIds, graph.nodes);
    final totalDist = _totalDistance(graph.nodes, pathIds);

    return RouteModel(
      originId: startNodeId,
      destinationId: endNodeId,
      destinationName: destinationName,
      waypoints: coords
          .map((c) => RouteCoordinate(longitude: c[0], latitude: c[1]))
          .toList(),
      waypointFloorNumbers: List<int>.filled(coords.length, floorNumber),
      steps: _buildSteps(graph.nodes, pathIds),
      totalDistanceMetres: totalDist,
      estimatedTimeSeconds: (totalDist / 1.3).round(), // 1.3 m/s walking
      isIndoor: true,
      floorNumber: floorNumber,
      buildingId: buildingId,
    );
  }

  /// Computes a connector-aware indoor route that may span multiple floors.
  ///
  /// GeoJSON node properties supported:
  /// - id: string (required for nav nodes)
  /// - nav_node: true
  /// - nav_edges: [nodeId, ...]
  /// - connector_id: string (same physical staircase/lift across floors)
  /// - connector_type: "stairs" | "elevator" (optional)
  RouteModel? getIndoorRouteAcrossFloors({
    required String buildingId,
    required int startFloorNumber,
    required int endFloorNumber,
    required String startNodeId,
    required String endNodeId,
    required String destinationName,
    String? preferredConnectorType,
  }) {
    if (startFloorNumber == endFloorNumber) {
      return getIndoorRoute(
        buildingId: buildingId,
        floorNumber: startFloorNumber,
        startNodeId: startNodeId,
        endNodeId: endNodeId,
        destinationName: destinationName,
      );
    }

    final floorGraphs = _getBuildingGraphs(buildingId);
    if (floorGraphs.isEmpty ||
        !floorGraphs.containsKey(startFloorNumber) ||
        !floorGraphs.containsKey(endFloorNumber)) {
      return null;
    }

    final stitched = _buildStitchedGraph(
      floorGraphs: floorGraphs,
      preferredConnectorType: preferredConnectorType,
    );

    final startVirtual = _virtualNodeId(startFloorNumber, startNodeId);
    final endVirtual = _virtualNodeId(endFloorNumber, endNodeId);

    final pathIds = NavigationUtils.dijkstra(
      nodes: stitched.nodes,
      edges: stitched.edges,
      startId: startVirtual,
      endId: endVirtual,
    );
    if (pathIds.isEmpty) return null;

    final totalDist = _totalDistance(stitched.nodes, pathIds);
    final waypoints = NavigationUtils.pathToCoordinates(pathIds, stitched.nodes)
        .map((c) => RouteCoordinate(longitude: c[0], latitude: c[1]))
        .toList();
    final waypointFloorNumbers = pathIds
        .map((pathId) => stitched.nodeInfo[pathId]!.floorNumber)
        .toList();

    return RouteModel(
      originId: startNodeId,
      destinationId: endNodeId,
      destinationName: destinationName,
      waypoints: waypoints,
      waypointFloorNumbers: waypointFloorNumbers,
      steps: _buildMultiFloorSteps(pathIds, stitched.nodeInfo),
      totalDistanceMetres: totalDist,
      estimatedTimeSeconds: (totalDist / 1.25).round(),
      isIndoor: true,
      floorNumber: endFloorNumber,
      buildingId: buildingId,
    );
  }

  Map<int, _FloorGraph> _getBuildingGraphs(String buildingId) {
    final prefix = '${buildingId}_floor';
    final result = <int, _FloorGraph>{};

    for (final entry in _graphCache.entries) {
      if (!entry.key.startsWith(prefix)) continue;
      final floorRaw = entry.key.replaceFirst(prefix, '');
      final floor = int.tryParse(floorRaw);
      if (floor != null) {
        result[floor] = entry.value;
      }
    }
    return result;
  }

  _StitchedGraph _buildStitchedGraph({
    required Map<int, _FloorGraph> floorGraphs,
    String? preferredConnectorType,
  }) {
    final nodes = <NavNode>[];
    final edges = <NavEdge>[];
    final nodeInfo = <String, _NodeInfo>{};
    final connectorIndex = <String, List<_ConnectorNodeRef>>{};

    for (final floorEntry in floorGraphs.entries) {
      final floor = floorEntry.key;
      final graph = floorEntry.value;

      for (final node in graph.nodes) {
        final virtualId = _virtualNodeId(floor, node.id);
        nodes.add(NavNode(id: virtualId, lng: node.lng, lat: node.lat));

        final meta = graph.nodeMeta[node.id];
        nodeInfo[virtualId] = _NodeInfo(
          floorNumber: floor,
          originalNodeId: node.id,
          longitude: node.lng,
          latitude: node.lat,
          connectorId: meta?.connectorId,
          connectorType: meta?.connectorType,
        );

        if (meta?.connectorId != null) {
          connectorIndex.putIfAbsent(meta!.connectorId!, () => []).add(
                _ConnectorNodeRef(
                  virtualNodeId: virtualId,
                  floorNumber: floor,
                  connectorType: meta.connectorType,
                ),
              );
        }
      }

      for (final edge in graph.edges) {
        edges.add(NavEdge(
          from: _virtualNodeId(floor, edge.from),
          to: _virtualNodeId(floor, edge.to),
          weight: edge.weight,
        ));
      }
    }

    for (final refs in connectorIndex.values) {
      refs.sort((a, b) => a.floorNumber.compareTo(b.floorNumber));
      for (int i = 0; i < refs.length - 1; i++) {
        final a = refs[i];
        final b = refs[i + 1];

        final type = _chooseConnectorType(
          a.connectorType,
          b.connectorType,
          preferredConnectorType,
        );

        edges.add(NavEdge(
          from: a.virtualNodeId,
          to: b.virtualNodeId,
          weight: _verticalWeight(type),
        ));
      }
    }

    return _StitchedGraph(nodes: nodes, edges: edges, nodeInfo: nodeInfo);
  }

  String _chooseConnectorType(
    String? a,
    String? b,
    String? preferred,
  ) {
    if (preferred != null && (a == preferred || b == preferred)) {
      return preferred;
    }
    return a ?? b ?? 'stairs';
  }

  double _verticalWeight(String connectorType) {
    switch (connectorType) {
      case 'elevator':
        return _elevatorFloorTransitionWeight;
      case 'stairs':
      default:
        return _stairsFloorTransitionWeight;
    }
  }

  String _virtualNodeId(int floorNumber, String nodeId) {
    return 'F$floorNumber::$nodeId';
  }

  double _totalDistance(List<NavNode> nodes, List<String> pathIds) {
    final map = {for (final n in nodes) n.id: n};
    double dist = 0;
    for (int i = 0; i < pathIds.length - 1; i++) {
      final a = map[pathIds[i]]!;
      final b = map[pathIds[i + 1]]!;
      dist += NavigationUtils.distance(a.lat, a.lng, b.lat, b.lng);
    }
    return dist;
  }

  List<RouteStep> _buildSteps(List<NavNode> nodes, List<String> pathIds) {
    final map = {for (final n in nodes) n.id: n};
    final steps = <RouteStep>[];
    for (int i = 0; i < pathIds.length - 1; i++) {
      final a = map[pathIds[i]]!;
      final b = map[pathIds[i + 1]]!;
      steps.add(RouteStep(
        instruction: 'Head towards ${b.id}',
        distanceMetres: NavigationUtils.distance(a.lat, a.lng, b.lat, b.lng),
        maneuverType: 'straight',
        longitude: b.lng,
        latitude: b.lat,
        floorNumber: null,
      ));
    }
    return steps;
  }

  List<RouteStep> _buildMultiFloorSteps(
    List<String> pathIds,
    Map<String, _NodeInfo> nodeInfo,
  ) {
    final steps = <RouteStep>[];

    for (int i = 0; i < pathIds.length - 1; i++) {
      final currentId = pathIds[i];
      final nextId = pathIds[i + 1];
      final current = nodeInfo[currentId]!;
      final next = nodeInfo[nextId]!;

      final floorChanged = current.floorNumber != next.floorNumber;

      if (floorChanged) {
        final connectorType = next.connectorType ?? current.connectorType;
        final isElevator = connectorType == 'elevator';
        final instruction = isElevator
            ? 'Take elevator to Floor ${next.floorNumber}'
            : 'Use stairs to Floor ${next.floorNumber}';

        steps.add(RouteStep(
          instruction: instruction,
          distanceMetres: _verticalWeight(connectorType ?? 'stairs'),
          maneuverType: isElevator ? 'elevator' : 'stairs',
          longitude: next.longitude,
          latitude: next.latitude,
          floorNumber: next.floorNumber,
        ));
      } else {
        steps.add(RouteStep(
          instruction:
              'Proceed on Floor ${next.floorNumber} towards ${next.originalNodeId}',
          distanceMetres: NavigationUtils.distance(
            current.latitude,
            current.longitude,
            next.latitude,
            next.longitude,
          ),
          maneuverType: 'straight',
          longitude: next.longitude,
          latitude: next.latitude,
          floorNumber: next.floorNumber,
        ));
      }
    }

    return steps;
  }
}

class _FloorGraph {
  const _FloorGraph({
    required this.nodes,
    required this.edges,
    required this.nodeMeta,
  });

  final List<NavNode> nodes;
  final List<NavEdge> edges;
  final Map<String, _NodeMeta> nodeMeta;

  factory _FloorGraph.fromGeoJson(Map<String, dynamic> geoJson) {
    final features = geoJson['features'] as List<dynamic>? ?? [];
    final nodes = <NavNode>[];
    final edges = <NavEdge>[];
    final nodeMeta = <String, _NodeMeta>{};

    for (final feature in features) {
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final geo = feature['geometry'] as Map<String, dynamic>? ?? {};

      if (props['nav_node'] == true && geo['type'] == 'Point') {
        final coords = geo['coordinates'] as List<dynamic>;
        final id = props['id'] as String;
        nodes.add(NavNode(
          id: id,
          lng: (coords[0] as num).toDouble(),
          lat: (coords[1] as num).toDouble(),
        ));
        nodeMeta[id] = _NodeMeta(
          name: props['name'] as String?,
          nodeType: props['node_type'] as String?,
          connectorId: props['connector_id'] as String?,
          connectorType: props['connector_type'] as String?,
        );
      }
    }

    final nodeMap = {for (final n in nodes) n.id: n};

    for (final feature in features) {
      final props = feature['properties'] as Map<String, dynamic>? ?? {};
      final navEdges = props['nav_edges'] as List<dynamic>?;
      if (navEdges == null) continue;

      final fromId = props['id'] as String?;
      final from = fromId != null ? nodeMap[fromId] : null;
      if (from == null) continue;

      for (final toId in navEdges) {
        final to = nodeMap[toId as String];
        if (to == null) continue;
        edges.add(NavEdge(
          from: from.id,
          to: to.id,
          weight: NavigationUtils.distance(from.lat, from.lng, to.lat, to.lng),
        ));
      }
    }

    return _FloorGraph(nodes: nodes, edges: edges, nodeMeta: nodeMeta);
  }
}

class _NodeMeta {
  const _NodeMeta({
    this.name,
    this.nodeType,
    this.connectorId,
    this.connectorType,
  });

  final String? name;
  final String? nodeType;
  final String? connectorId;
  final String? connectorType;
}

class _StitchedGraph {
  const _StitchedGraph({
    required this.nodes,
    required this.edges,
    required this.nodeInfo,
  });

  final List<NavNode> nodes;
  final List<NavEdge> edges;
  final Map<String, _NodeInfo> nodeInfo;
}

class _NodeInfo {
  const _NodeInfo({
    required this.floorNumber,
    required this.originalNodeId,
    required this.longitude,
    required this.latitude,
    this.connectorId,
    this.connectorType,
  });

  final int floorNumber;
  final String originalNodeId;
  final double longitude;
  final double latitude;
  final String? connectorId;
  final String? connectorType;
}

class _ConnectorNodeRef {
  const _ConnectorNodeRef({
    required this.virtualNodeId,
    required this.floorNumber,
    required this.connectorType,
  });

  final String virtualNodeId;
  final int floorNumber;
  final String? connectorType;
}

class IndoorNodeDescriptor {
  const IndoorNodeDescriptor({
    required this.buildingId,
    required this.floorNumber,
    required this.nodeId,
    required this.name,
    required this.nodeType,
    required this.longitude,
    required this.latitude,
    this.connectorType,
  });

  final String buildingId;
  final int floorNumber;
  final String nodeId;
  final String name;
  final String nodeType;
  final double longitude;
  final double latitude;
  final String? connectorType;
}
