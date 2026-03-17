import '../../domain/entities/building.dart';
import '../../domain/entities/landmark.dart';
import '../../domain/usecases/search_location.dart';
import '../../core/constants/app_constants.dart';

/// Simple fuzzy-match search across all buildings, rooms, and landmarks.
/// Ranks results by match score: exact prefix > contains > fuzzy char overlap.
class SearchService {
  List<SearchResult> search({
    required String query,
    required List<Building> buildings,
    required List<Landmark> landmarks,
  }) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty || q.length < 2) return [];

    final results = <_Scored<SearchResult>>[];

    // --- Buildings ---
    for (final b in buildings) {
      final score = _score(q, b.name.toLowerCase());
      if (score > 0) {
        results.add(_Scored(
          score: score,
          value: SearchResult(
            id: b.id,
            title: b.name,
            subtitle: b.description,
            latitude: b.latitude,
            longitude: b.longitude,
            type: SearchResultType.building,
          ),
        ));
      }
      // --- Rooms inside buildings ---
      for (final floor in b.floors) {
        for (final room in floor.rooms) {
          final rs = _score(q, room.name.toLowerCase());
          if (rs > 0) {
            results.add(_Scored(
              score: rs,
              value: SearchResult(
                id: room.id,
                title: room.name,
                subtitle: '${b.name} · Floor ${floor.floorNumber}',
                latitude: room.latitude,
                longitude: room.longitude,
                type: SearchResultType.room,
                buildingId: b.id,
                floorNumber: floor.floorNumber,
                nodeId: room.id,
              ),
            ));
          }
        }
      }
    }

    // --- Landmarks ---
    for (final l in landmarks) {
      final score = _score(q, l.name.toLowerCase());
      if (score > 0) {
        results.add(_Scored(
          score: score,
          value: SearchResult(
            id: l.id.toString(),
            title: l.name,
            subtitle: l.description,
            latitude: l.latitude,
            longitude: l.longitude,
            type: SearchResultType.landmark,
          ),
        ));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    return results
      .map((s) => s.value)
      .take(AppConstants.maxSearchResults)
      .toList();
  }

  /// Scores a candidate string against the query.
  /// Returns 0 if no match, higher is better.
  int _score(String query, String candidate) {
    if (candidate == query) return 100;
    if (candidate.startsWith(query)) return 80;
    if (candidate.contains(query)) return 60;

    // Fuzzy: count matching characters in order
    int qi = 0;
    for (int ci = 0; ci < candidate.length && qi < query.length; ci++) {
      if (candidate[ci] == query[qi]) qi++;
    }
    if (qi == query.length) return 30 + (qi * 10 ~/ query.length);

    return 0;
  }
}

class _Scored<T> {
  const _Scored({required this.score, required this.value});
  final int score;
  final T value;
}
