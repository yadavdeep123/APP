import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/navigation_repository.dart';
import '../../data/services/mapbox_service.dart';
import '../../data/services/indoor_navigation_service.dart';
import '../../domain/entities/route.dart' as domain;
import '../../domain/usecases/get_route.dart';

final mapboxServiceProvider = Provider<MapboxService>((ref) {
  return MapboxService();
});

final indoorNavigationServiceProvider =
    Provider<IndoorNavigationService>((ref) {
  return IndoorNavigationService();
});

final navigationRepositoryProvider = Provider<NavigationRepository>((ref) {
  return NavigationRepository(
    mapboxService: ref.read(mapboxServiceProvider),
    indoorService: ref.read(indoorNavigationServiceProvider),
  );
});

final getRouteUseCaseProvider = Provider<GetRoute>((ref) {
  return GetRoute(ref.read(navigationRepositoryProvider));
});

// Holds the active route being navigated
final activeRouteProvider = StateProvider<domain.Route?>((ref) => null);

// Whether real-time navigation is active
final isNavigatingProvider = StateProvider<bool>((ref) => false);

// Current step index in turn-by-turn guide
final currentStepIndexProvider = StateProvider<int>((ref) => 0);

// User indoor connector preference: null (auto), stairs, elevator
final indoorConnectorPreferenceProvider =
  StateProvider<String?>((ref) => null);

// Selected indoor destination node id for room picker UI.
final indoorSelectedDestinationProvider =
  StateProvider<String?>((ref) => null);

final pendingIndoorNavigationProvider =
    StateProvider<PendingIndoorNavigation?>((ref) => null);

class PendingIndoorNavigation {
  const PendingIndoorNavigation({
    required this.buildingId,
    required this.floorNumber,
    required this.destinationNodeId,
    required this.destinationName,
    required this.entranceLatitude,
    required this.entranceLongitude,
    required this.entranceLabel,
  });

  final String buildingId;
  final int floorNumber;
  final String destinationNodeId;
  final String destinationName;
  final double entranceLatitude;
  final double entranceLongitude;
  final String entranceLabel;
}

// Async provider to fetch a route given origin + destination
final routeProvider = FutureProvider.family<domain.Route?,
    ({
      double originLat,
      double originLng,
      double destLat,
      double destLng,
      String destId,
      String destName,
      bool isIndoor,
      String? buildingId,
      int? floorNumber,
      int? startFloorNumber,
      int? endFloorNumber,
      String? startNodeId,
      String? endNodeId,
      String? preferredConnectorType,
      Map<int, String>? floorGeojsonAssets,
    })>((ref, params) async {
  final useCase = ref.read(getRouteUseCaseProvider);
  return useCase(
    originLat: params.originLat,
    originLng: params.originLng,
    destinationLat: params.destLat,
    destinationLng: params.destLng,
    destinationId: params.destId,
    destinationName: params.destName,
    isIndoor: params.isIndoor,
    buildingId: params.buildingId,
    floorNumber: params.floorNumber,
    startFloorNumber: params.startFloorNumber,
    endFloorNumber: params.endFloorNumber,
    startNodeId: params.startNodeId,
    endNodeId: params.endNodeId,
    preferredConnectorType: params.preferredConnectorType,
    floorGeojsonAssets: params.floorGeojsonAssets,
  );
});
