import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_navigation/data/repositories/campus_repository.dart';
import 'package:smart_campus_navigation/domain/entities/building.dart';
import 'package:smart_campus_navigation/domain/entities/landmark.dart';
import 'package:smart_campus_navigation/domain/usecases/get_nearby_landmarks.dart';

void main() {
  group('GetNearbyLandmarks use case', () {
    test('returns nearest landmarks sorted by distance', () async {
      final repo = _FakeCampusRepository(
        landmarks: const [
          Landmark(
            id: 1,
            name: 'Library',
            description: 'Central library',
            latitude: 40.0000,
            longitude: -75.0000,
            type: 'building',
          ),
          Landmark(
            id: 2,
            name: 'Gym',
            description: 'Sports complex',
            latitude: 40.0030,
            longitude: -75.0030,
            type: 'sports',
          ),
        ],
      );

      final useCase = GetNearbyLandmarks(repo);
      final nearby = await useCase(
        userLat: 40.0001,
        userLng: -75.0001,
        radiusMetres: 1000,
      );

      expect(nearby, isNotEmpty);
      expect(nearby.first.name, 'Library');
    });

    test('returns empty list when nothing is within radius', () async {
      final repo = _FakeCampusRepository(
        landmarks: const [
          Landmark(
            id: 1,
            name: 'Far Landmark',
            description: 'Far away',
            latitude: 41.0,
            longitude: -76.0,
            type: 'outdoor',
          ),
        ],
      );

      final useCase = GetNearbyLandmarks(repo);
      final nearby = await useCase(
        userLat: 40.0001,
        userLng: -75.0001,
        radiusMetres: 100,
      );

      expect(nearby, isEmpty);
    });
  });
}

class _FakeCampusRepository extends CampusRepository {
  _FakeCampusRepository({
    this.landmarks = const [],
  });

  final List<Landmark> landmarks;

  @override
  Future<List<Building>> getBuildings() async => const [];

  @override
  Future<List<Landmark>> getLandmarks() async => landmarks;
}
