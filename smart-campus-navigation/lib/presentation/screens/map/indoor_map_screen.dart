import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' as mapbox;

import '../../../core/constants/map_constants.dart';
import '../../../data/services/indoor_navigation_service.dart';
import '../../../domain/entities/route.dart' as domain;
import '../../../domain/entities/building.dart';
import '../../providers/map_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/map/floor_selector_widget.dart';
import '../../widgets/navigation/route_info_widget.dart';

class IndoorMapScreen extends ConsumerStatefulWidget {
  const IndoorMapScreen({
    super.key,
    required this.buildingId,
    required this.floorNumber,
    this.initialDestinationNodeId,
  });

  final String buildingId;
  final int floorNumber;
  final String? initialDestinationNodeId;

  @override
  ConsumerState<IndoorMapScreen> createState() => _IndoorMapScreenState();
}

class _IndoorMapScreenState extends ConsumerState<IndoorMapScreen> {
  @override
  void initState() {
    super.initState();
    // Set the initial floor in the provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedFloorProvider.notifier).state = widget.floorNumber;
      if (widget.initialDestinationNodeId != null) {
        ref.read(indoorSelectedDestinationProvider.notifier).state =
            widget.initialDestinationNodeId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final campusData = ref.watch(campusDataProvider);
    final selectedFloor = ref.watch(selectedFloorProvider);

    return campusData.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('Error loading map: $e'))),
      data: (data) {
        final building = data.buildings.firstWhere(
          (b) => b.id == widget.buildingId,
          orElse: () => data.buildings.first,
        );
        return _IndoorMapView(
          building: building,
          selectedFloor: selectedFloor,
          initialDestinationNodeId: widget.initialDestinationNodeId,
          onMapCreated: (_) {},
        );
      },
    );
  }
}

class _IndoorMapView extends ConsumerStatefulWidget {
  const _IndoorMapView({
    required this.building,
    required this.selectedFloor,
    required this.initialDestinationNodeId,
    required this.onMapCreated,
  });

  final Building building;
  final int selectedFloor;
  final String? initialDestinationNodeId;
  final void Function(mapbox.MapboxMap) onMapCreated;

  @override
  ConsumerState<_IndoorMapView> createState() => _IndoorMapViewState();
}

class _IndoorMapViewState extends ConsumerState<_IndoorMapView> {
  mapbox.MapboxMap? _mapboxMap;
  bool _graphsReady = false;
  String? _renderSignature;

  @override
  Widget build(BuildContext context) {
    final floor = widget.building.floors.firstWhere(
      (f) => f.floorNumber == widget.selectedFloor,
      orElse: () => widget.building.floors.first,
    );
    final activeRoute = ref.watch(activeRouteProvider);
    final connectorPreference = ref.watch(indoorConnectorPreferenceProvider);
    final destinations = _graphsReady
        ? ref
            .read(indoorNavigationServiceProvider)
            .getNavigableNodes(widget.building.id)
            .where((node) => node.nodeType == 'room')
            .toList()
        : const <IndoorNodeDescriptor>[];

    _scheduleRouteOverlaySync(activeRoute);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.building.name} · Floor ${widget.selectedFloor}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showBuildingInfo(context, widget.building),
          ),
        ],
      ),
      body: Stack(
        children: [
          mapbox.MapWidget(
            styleUri: MapConstants.styleLight,
            cameraOptions: mapbox.CameraOptions(
              center: mapbox.Point(
                coordinates: mapbox.Position(
                  widget.building.longitude,
                  widget.building.latitude,
                ),
              ),
              zoom: MapConstants.indoorZoom,
            ),
            onMapCreated: (map) async {
              _mapboxMap = map;
              widget.onMapCreated(map);
              await _preloadIndoorGraphs(widget.building);
              await _loadFloorPlan(map, floor.geojsonAssetPath);
            },
          ),
          Positioned(
            left: 16,
            right: widget.building.floors.length > 1 ? 76 : 16,
            top: 16,
            child: _IndoorControlCard(
              building: widget.building,
              currentFloor: widget.selectedFloor,
              connectorPreference: connectorPreference,
              destinations: destinations,
            ),
          ),
          // Floor selector on the right side
          if (widget.building.floors.length > 1)
            Positioned(
              right: 16,
              top: 80,
              child: FloorSelectorWidget(
                building: widget.building,
                onFloorSelected: (f) async {
                  final newFloor = widget.building.floors.firstWhere(
                    (fl) => fl.floorNumber == f,
                  );
                  if (_mapboxMap != null) {
                    await _loadFloorPlan(
                        _mapboxMap!, newFloor.geojsonAssetPath);
                  }
                },
              ),
            ),
          if (activeRoute != null && activeRoute.isIndoor)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: RouteInfoWidget(
                route: activeRoute,
                onStartNavigation: () {
                  ref.read(isNavigatingProvider.notifier).state = true;
                },
                onClose: () {
                  ref.read(activeRouteProvider.notifier).state = null;
                  ref.read(isNavigatingProvider.notifier).state = false;
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _preloadIndoorGraphs(Building building) async {
    final service = ref.read(indoorNavigationServiceProvider);
    final assets = <int, String>{
      for (final floor in building.floors)
        if (floor.geojsonAssetPath != null)
          floor.floorNumber: floor.geojsonAssetPath!,
    };
    if (assets.isNotEmpty) {
      await service.loadBuildingFloors(building.id, assets);
      if (mounted) {
        final nodes = service.getNavigableNodes(building.id);
        if (nodes.isNotEmpty) {
          ref.read(indoorSelectedDestinationProvider.notifier).state =
              widget.initialDestinationNodeId ?? nodes.first.nodeId;
        }
        setState(() => _graphsReady = true);
        if (widget.initialDestinationNodeId != null) {
          IndoorNodeDescriptor? selected;
          for (final node in nodes) {
            if (node.nodeId == widget.initialDestinationNodeId) {
              selected = node;
              break;
            }
          }
          if (selected != null) {
            await _buildIndoorRouteToNode(selected);
          }
        }
      }
    }
  }

  Future<void> _buildIndoorRouteToNode(IndoorNodeDescriptor destination) async {
    final stopwatch = Stopwatch()..start();
    final route = await _safeBuildIndoorRoute(
      context,
      () => ref.read(getRouteUseCaseProvider).call(
        originLat: widget.building.latitude,
        originLng: widget.building.longitude,
        destinationLat: destination.latitude,
        destinationLng: destination.longitude,
        destinationId: destination.nodeId,
        destinationName: destination.name,
        isIndoor: true,
        buildingId: widget.building.id,
        floorNumber: widget.selectedFloor,
        startFloorNumber: 1,
        endFloorNumber: destination.floorNumber,
        startNodeId: 'entrance',
        endNodeId: destination.nodeId,
        preferredConnectorType: ref.read(indoorConnectorPreferenceProvider),
        floorGeojsonAssets: {
          for (final floor in widget.building.floors)
            if (floor.geojsonAssetPath != null)
              floor.floorNumber: floor.geojsonAssetPath!,
        },
      ),
    );
    stopwatch.stop();

    ref.read(activeRouteProvider.notifier).state = route;
    ref.read(isNavigatingProvider.notifier).state = false;

    await ref.read(metricsServiceProvider).logEvent(
      route == null ? 'indoor_route_failed' : 'indoor_route_created',
      properties: {
        'buildingId': widget.building.id,
        'destinationNodeId': destination.nodeId,
        'floorNumber': destination.floorNumber,
        'latencyMs': stopwatch.elapsedMilliseconds,
      },
    );
  }

  Future<domain.Route?> _safeBuildIndoorRoute(
    BuildContext context,
    Future<domain.Route?> Function() action,
  ) async {
    try {
      return await action();
    } on Exception catch (error) {
      await ref.read(metricsServiceProvider).logEvent(
        'route_build_exception',
        properties: {
          'message': error.toString(),
          'screen': 'indoor_map',
        },
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Indoor route failed unexpectedly. Please retry.',
            ),
          ),
        );
      }
      return null;
    }
  }

  Future<void> _loadFloorPlan(mapbox.MapboxMap map, String? assetPath) async {
    if (assetPath == null) return;
    // Remove existing floor layers if present
    try {
      await map.style.removeStyleLayer(MapConstants.indoorRoomLayer);
      await map.style.removeStyleSource(MapConstants.indoorRoomSource);
      await map.style.removeStyleLayer(MapConstants.indoorFloorFillLayer);
      await map.style.removeStyleLayer(MapConstants.indoorFloorLineLayer);
      await map.style.removeStyleSource(MapConstants.indoorFloorSource);
    } on Exception {
      // Layers may not exist on first load — safe to ignore
    }

    final rawGeoJson = await rootBundle.loadString(assetPath);

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.indoorFloorSource,
      data: rawGeoJson,
    ));

    await map.style.addLayer(mapbox.FillLayer(
      id: MapConstants.indoorFloorFillLayer,
      sourceId: MapConstants.indoorFloorSource,
      fillColor: 0x5534A853,
      fillOutlineColor: 0xFF1B5E20,
    ));

    await map.style.addLayer(mapbox.LineLayer(
      id: MapConstants.indoorFloorLineLayer,
      sourceId: MapConstants.indoorFloorSource,
      lineColor: 0xFF1B5E20,
      lineWidth: 2.0,
    ));

    await _renderRoomMarkers();
    await _renderActiveRouteOnMap();
  }

  void _scheduleRouteOverlaySync(domain.Route? activeRoute) {
    final signature = activeRoute == null
        ? 'none:${widget.selectedFloor}'
        : '${activeRoute.destinationId}:${activeRoute.waypoints.length}:${widget.selectedFloor}';
    if (_renderSignature == signature) return;

    _renderSignature = signature;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _renderActiveRouteOnMap();
    });
  }

  Future<void> _renderActiveRouteOnMap() async {
    final map = _mapboxMap;
    final activeRoute = ref.read(activeRouteProvider);
    if (map == null) return;

    try {
      await map.style.removeStyleLayer(MapConstants.routeLayer);
      await map.style.removeStyleSource(MapConstants.routeSource);
    } on Exception {
      // No prior route layer/source.
    }

    if (activeRoute == null || !activeRoute.isIndoor) return;

    final filteredCoordinates = _coordinatesForSelectedFloor(activeRoute);
    if (filteredCoordinates.length < 2) return;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {
            'buildingId': activeRoute.buildingId,
            'floorNumber': activeRoute.floorNumber,
          },
          'geometry': {
            'type': 'LineString',
            'coordinates': filteredCoordinates,
          },
        },
      ],
    };

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.routeSource,
      data: geoJson.toString(),
    ));

    await map.style.addLayer(mapbox.LineLayer(
      id: MapConstants.routeLayer,
      sourceId: MapConstants.routeSource,
      lineColor: MapConstants.routeLineColorIndoor,
      lineWidth: 5.0,
      lineOpacity: 0.9,
      lineCap: mapbox.LineCap.ROUND,
      lineJoin: mapbox.LineJoin.ROUND,
    ));
  }

  List<List<double>> _coordinatesForSelectedFloor(domain.Route route) {
    final waypointFloors = route.waypointFloorNumbers;
    if (waypointFloors == null ||
        waypointFloors.length != route.waypoints.length) {
      return route.waypoints;
    }

    final filtered = <List<double>>[];
    for (int i = 0; i < route.waypoints.length; i++) {
      if (waypointFloors[i] == widget.selectedFloor) {
        filtered.add(route.waypoints[i]);
      }
    }
    return filtered;
  }

  Future<void> _renderRoomMarkers() async {
    final map = _mapboxMap;
    if (map == null || !_graphsReady) return;

    final service = ref.read(indoorNavigationServiceProvider);
    final rooms = service
        .getNavigableNodes(widget.building.id)
        .where((node) =>
            node.nodeType == 'room' && node.floorNumber == widget.selectedFloor)
        .toList();

    try {
      await map.style.removeStyleLayer(MapConstants.indoorRoomLayer);
      await map.style.removeStyleSource(MapConstants.indoorRoomSource);
    } on Exception {
      // Room source/layer may not exist yet.
    }

    if (rooms.isEmpty) return;

    final geoJson = {
      'type': 'FeatureCollection',
      'features': rooms
          .map(
            (room) => {
              'type': 'Feature',
              'properties': {
                'id': room.nodeId,
                'name': room.name,
              },
              'geometry': {
                'type': 'Point',
                'coordinates': [room.longitude, room.latitude],
              },
            },
          )
          .toList(),
    };

    await map.style.addSource(mapbox.GeoJsonSource(
      id: MapConstants.indoorRoomSource,
      data: geoJson.toString(),
    ));

    await map.style.addLayer(mapbox.CircleLayer(
      id: MapConstants.indoorRoomLayer,
      sourceId: MapConstants.indoorRoomSource,
      circleColor: 0xFF1A73E8,
      circleRadius: 5.0,
      circleStrokeColor: 0xFFFFFFFF,
      circleStrokeWidth: 1.5,
    ));
  }

  void _showBuildingInfo(BuildContext context, Building building) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(building.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text(building.description),
            const SizedBox(height: 12),
            Text('Floors: ${building.floors.length}',
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _IndoorControlCard extends ConsumerWidget {
  const _IndoorControlCard({
    required this.building,
    required this.currentFloor,
    required this.connectorPreference,
    required this.destinations,
  });

  final Building building;
  final int currentFloor;
  final String? connectorPreference;
  final List<IndoorNodeDescriptor> destinations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedDestinationId = ref.watch(indoorSelectedDestinationProvider);
    IndoorNodeDescriptor? selectedDestination;
    for (final node in destinations) {
      if (node.nodeId == selectedDestinationId) {
        selectedDestination = node;
        break;
      }
    }
    selectedDestination ??= destinations.isNotEmpty ? destinations.first : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Indoor Navigation',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ConnectorChip(
                    label: 'Auto',
                    selected: connectorPreference == null,
                    onTap: () => ref
                        .read(indoorConnectorPreferenceProvider.notifier)
                        .state = null,
                  ),
                  const SizedBox(width: 8),
                  _ConnectorChip(
                    label: 'Stairs',
                    selected: connectorPreference == 'stairs',
                    onTap: () => ref
                        .read(indoorConnectorPreferenceProvider.notifier)
                        .state = 'stairs',
                  ),
                  const SizedBox(width: 8),
                  _ConnectorChip(
                    label: 'Elevator',
                    selected: connectorPreference == 'elevator',
                    onTap: () => ref
                        .read(indoorConnectorPreferenceProvider.notifier)
                        .state = 'elevator',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (destinations.isEmpty)
              Text(
                'Loading indoor rooms...',
                style: theme.textTheme.bodySmall,
              ),
            if (destinations.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                initialValue: selectedDestination?.nodeId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Destination Room',
                ),
                items: destinations
                    .map(
                      (node) => DropdownMenuItem<String>(
                        value: node.nodeId,
                        child: Text('${node.name} · F${node.floorNumber}'),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  ref.read(indoorSelectedDestinationProvider.notifier).state =
                      value;
                },
              ),
              const SizedBox(height: 10),
              Text(
                'Route target: ${selectedDestination!.name}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final stopwatch = Stopwatch()..start();
                    domain.Route? route;
                    try {
                      route = await ref.read(getRouteUseCaseProvider).call(
                        originLat: building.latitude,
                        originLng: building.longitude,
                        destinationLat: selectedDestination!.latitude,
                        destinationLng: selectedDestination.longitude,
                        destinationId: selectedDestination.nodeId,
                        destinationName: selectedDestination.name,
                        isIndoor: true,
                        buildingId: building.id,
                        floorNumber: currentFloor,
                        startFloorNumber: 1,
                        endFloorNumber: selectedDestination.floorNumber,
                        startNodeId: 'entrance',
                        endNodeId: selectedDestination.nodeId,
                        preferredConnectorType: connectorPreference,
                        floorGeojsonAssets: {
                          for (final floor in building.floors)
                            if (floor.geojsonAssetPath != null)
                              floor.floorNumber: floor.geojsonAssetPath!,
                        },
                      );
                    } on Exception catch (error) {
                      await ref.read(metricsServiceProvider).logEvent(
                        'route_build_exception',
                        properties: {
                          'message': error.toString(),
                          'screen': 'indoor_control_card',
                        },
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Indoor route failed unexpectedly. Please retry.',
                            ),
                          ),
                        );
                      }
                    }
                    stopwatch.stop();

                    ref.read(activeRouteProvider.notifier).state = route;
                    ref.read(isNavigatingProvider.notifier).state = false;

                    await ref.read(metricsServiceProvider).logEvent(
                      route == null
                          ? 'indoor_route_failed'
                          : 'indoor_route_created',
                      properties: {
                        'buildingId': building.id,
                        'destinationNodeId': selectedDestination!.nodeId,
                        'floorNumber': selectedDestination.floorNumber,
                        'latencyMs': stopwatch.elapsedMilliseconds,
                        'source': 'manual_indoor_screen',
                      },
                    );
                  },
                  icon: const Icon(Icons.alt_route),
                  label: const Text('Navigate To Room'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ConnectorChip extends StatelessWidget {
  const _ConnectorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
