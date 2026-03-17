import '../entities/landmark.dart';
import '../../core/utils/location_utils.dart';
import '../../data/repositories/campus_repository.dart';

class GetNearbyLandmarks {
  const GetNearbyLandmarks(this._repository);
  final CampusRepository _repository;

  Future<List<Landmark>> call({
    required double userLat,
    required double userLng,
    double radiusMetres = 200.0,
    int maxResults = 5,
  }) async {
    final all = await _repository.getLandmarks();

    final nearby = all
        .map((l) => (
              landmark: l,
              distance: LocationUtils.distanceInMetres(
                userLat,
                userLng,
                l.latitude,
                l.longitude,
              )
            ))
        .where((e) => e.distance <= radiusMetres)
        .toList()
      ..sort((a, b) => a.distance.compareTo(b.distance));

    return nearby.take(maxResults).map((e) => e.landmark).toList();
  }
}
