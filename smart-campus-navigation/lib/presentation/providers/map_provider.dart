import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/campus_repository.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/landmark.dart';
import '../../domain/usecases/get_campus_map.dart';
import '../../domain/usecases/get_nearby_landmarks.dart';

final campusRepositoryProvider = Provider<CampusRepository>((ref) {
  return CampusRepository();
});

final getCampusMapUseCaseProvider = Provider<GetCampusMap>((ref) {
  return GetCampusMap(ref.read(campusRepositoryProvider));
});

final getNearbyLandmarksUseCaseProvider = Provider<GetNearbyLandmarks>((ref) {
  return GetNearbyLandmarks(ref.read(campusRepositoryProvider));
});

// Loads all buildings + landmarks on first access (cached by Riverpod)
final campusDataProvider = FutureProvider<
    ({List<Building> buildings, List<Landmark> landmarks})>((ref) async {
  final useCase = ref.read(getCampusMapUseCaseProvider);
  return useCase();
});

// Nearby landmarks based on current GPS position
final nearbyLandmarksProvider = FutureProvider.family<List<Landmark>,
    ({double lat, double lng})>((ref, position) async {
  final useCase = ref.read(getNearbyLandmarksUseCaseProvider);
  return useCase(
    userLat: position.lat,
    userLng: position.lng,
  );
});

// Currently selected floor for indoor map view
final selectedFloorProvider = StateProvider<int>((ref) => 1);

// Active building for indoor navigation
final activeBuildingProvider = StateProvider<Building?>((ref) => null);
