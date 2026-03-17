import '../../domain/entities/route.dart' as domain;
import '../models/route_model.dart';
import '../services/mapbox_service.dart';
import '../services/indoor_navigation_service.dart';

class NavigationRepository {
  NavigationRepository({
    required MapboxService mapboxService,
    required IndoorNavigationService indoorService,
  })  : _mapboxService = mapboxService,
        _indoorService = indoorService;

  final MapboxService _mapboxService;
  final IndoorNavigationService _indoorService;

  Future<domain.Route?> getRoute({
    required double originLat,
    required double originLng,
    required double destinationLat,
    required double destinationLng,
    required String destinationId,
    required String destinationName,
    bool isIndoor = false,
    String? buildingId,
    int? floorNumber,
    int? startFloorNumber,
    int? endFloorNumber,
    String? startNodeId,
    String? endNodeId,
    String? preferredConnectorType,
    Map<int, String>? floorGeojsonAssets,
  }) async {
    if (isIndoor && buildingId != null && floorNumber != null) {
      if (floorGeojsonAssets != null && floorGeojsonAssets.isNotEmpty) {
        await _indoorService.loadBuildingFloors(buildingId, floorGeojsonAssets);
      }

      final startFloor = startFloorNumber ?? floorNumber;
      final endFloor = endFloorNumber ?? floorNumber;
      final indoorStartNodeId = startNodeId ?? 'entrance';
      final indoorEndNodeId = endNodeId ?? destinationId;

      final result = startFloor != endFloor
          ? _indoorService.getIndoorRouteAcrossFloors(
              buildingId: buildingId,
              startFloorNumber: startFloor,
              endFloorNumber: endFloor,
              startNodeId: indoorStartNodeId,
              endNodeId: indoorEndNodeId,
              destinationName: destinationName,
              preferredConnectorType: preferredConnectorType,
            )
          : _indoorService.getIndoorRoute(
              buildingId: buildingId,
              floorNumber: floorNumber,
              startNodeId: indoorStartNodeId,
              endNodeId: indoorEndNodeId,
              destinationName: destinationName,
            );
      if (result == null) return null;

      return _toDomainRoute(result);
    }

    // Outdoor via Mapbox Directions API
    final result = await _mapboxService.getWalkingRoute(
      originLng: originLng,
      originLat: originLat,
      destinationLng: destinationLng,
      destinationLat: destinationLat,
      destinationId: destinationId,
      destinationName: destinationName,
    );
    if (result == null) return null;

    return _toDomainRoute(result);
  }

  domain.Route _toDomainRoute(RouteModel result) {
    return domain.Route(
      originId: result.originId,
      destinationId: result.destinationId,
      destinationName: result.destinationName,
      waypoints:
          result.waypoints.map((c) => [c.longitude, c.latitude]).toList(),
        waypointFloorNumbers: result.waypointFloorNumbers,
      steps: result.steps
          .map((s) => domain.RouteStep(
                instruction: s.instruction,
                distanceMetres: s.distanceMetres,
                maneuverType: s.maneuverType,
                longitude: s.longitude,
                latitude: s.latitude,
            floorNumber: s.floorNumber,
              ))
          .toList(),
      totalDistanceMetres: result.totalDistanceMetres,
      estimatedTimeSeconds: result.estimatedTimeSeconds,
      isIndoor: result.isIndoor,
      floorNumber: result.floorNumber,
      buildingId: result.buildingId,
    );
  }
}
