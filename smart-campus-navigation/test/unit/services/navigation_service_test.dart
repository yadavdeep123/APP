import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_navigation/core/utils/navigation_utils.dart';
import 'package:smart_campus_navigation/data/services/indoor_navigation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NavigationUtils.dijkstra', () {
    test('finds shortest path across graph', () {
      const nodes = [
        NavNode(id: 'A', lng: 0, lat: 0),
        NavNode(id: 'B', lng: 1, lat: 0),
        NavNode(id: 'C', lng: 2, lat: 0),
      ];

      const edges = [
        NavEdge(from: 'A', to: 'B', weight: 1),
        NavEdge(from: 'B', to: 'C', weight: 1),
        NavEdge(from: 'A', to: 'C', weight: 5),
      ];

      final path = NavigationUtils.dijkstra(
        nodes: nodes,
        edges: edges,
        startId: 'A',
        endId: 'C',
      );

      expect(path, ['A', 'B', 'C']);
    });

    test('returns empty list if destination is unreachable', () {
      const nodes = [
        NavNode(id: 'A', lng: 0, lat: 0),
        NavNode(id: 'B', lng: 1, lat: 0),
      ];

      const edges = <NavEdge>[];

      final path = NavigationUtils.dijkstra(
        nodes: nodes,
        edges: edges,
        startId: 'A',
        endId: 'B',
      );

      expect(path, isEmpty);
    });

    test('converts path ids to coordinates in order', () {
      const nodes = [
        NavNode(id: 'A', lng: -75.0, lat: 40.0),
        NavNode(id: 'B', lng: -75.1, lat: 40.1),
      ];

      final coords = NavigationUtils.pathToCoordinates(['A', 'B'], nodes);

      expect(coords.length, 2);
      expect(coords.first, [-75.0, 40.0]);
      expect(coords.last, [-75.1, 40.1]);
    });
  });

  group('IndoorNavigationService multi-floor routing', () {
    test('finds route across floors using connector links', () async {
      final service = IndoorNavigationService();

      await service.loadBuildingFloors('building_a', {
        1: 'assets/maps/buildings/building_a_floor1.geojson',
        2: 'assets/maps/buildings/building_a_floor2.geojson',
      });

      final route = service.getIndoorRouteAcrossFloors(
        buildingId: 'building_a',
        startFloorNumber: 1,
        endFloorNumber: 2,
        startNodeId: 'entrance',
        endNodeId: 'room_201',
        destinationName: 'Room 201',
      );

      expect(route, isNotNull);
      expect(route!.isIndoor, isTrue);
      expect(route.floorNumber, 2);
      expect(route.steps.any((s) =>
          s.maneuverType == 'stairs' || s.maneuverType == 'elevator'), isTrue);
    });

    test('respects preferred connector type when available', () async {
      final service = IndoorNavigationService();

      await service.loadBuildingFloors('building_a', {
        1: 'assets/maps/buildings/building_a_floor1.geojson',
        2: 'assets/maps/buildings/building_a_floor2.geojson',
      });

      final route = service.getIndoorRouteAcrossFloors(
        buildingId: 'building_a',
        startFloorNumber: 1,
        endFloorNumber: 2,
        startNodeId: 'entrance',
        endNodeId: 'room_201',
        destinationName: 'Room 201',
        preferredConnectorType: 'elevator',
      );

      expect(route, isNotNull);
      expect(route!.steps.any((s) => s.maneuverType == 'elevator'), isTrue);
    });
  });
}