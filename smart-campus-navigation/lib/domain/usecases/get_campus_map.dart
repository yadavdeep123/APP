import '../entities/building.dart';
import '../entities/landmark.dart';
import '../../data/repositories/campus_repository.dart';

class GetCampusMap {
  const GetCampusMap(this._repository);
  final CampusRepository _repository;

  Future<({List<Building> buildings, List<Landmark> landmarks})> call() async {
    final buildings = await _repository.getBuildings();
    final landmarks = await _repository.getLandmarks();
    return (buildings: buildings, landmarks: landmarks);
  }
}
