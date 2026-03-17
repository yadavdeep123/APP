import '../entities/route.dart' as domain;
import '../../data/repositories/navigation_repository.dart';

class GetRoute {
  const GetRoute(this._repository);
  final NavigationRepository _repository;

  Future<domain.Route?> call({
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
  }) {
    return _repository.getRoute(
      originLat: originLat,
      originLng: originLng,
      destinationLat: destinationLat,
      destinationLng: destinationLng,
      destinationId: destinationId,
      destinationName: destinationName,
      isIndoor: isIndoor,
      buildingId: buildingId,
      floorNumber: floorNumber,
      startFloorNumber: startFloorNumber,
      endFloorNumber: endFloorNumber,
      startNodeId: startNodeId,
      endNodeId: endNodeId,
      preferredConnectorType: preferredConnectorType,
      floorGeojsonAssets: floorGeojsonAssets,
    );
  }
}
