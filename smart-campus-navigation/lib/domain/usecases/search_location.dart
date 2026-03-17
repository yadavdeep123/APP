import '../entities/building.dart';
import '../entities/landmark.dart';
import '../../data/services/search_service.dart';

class SearchLocation {
  const SearchLocation(this._searchService);
  final SearchService _searchService;

  List<SearchResult> call({
    required String query,
    required List<Building> buildings,
    required List<Landmark> landmarks,
  }) {
    return _searchService.search(
      query: query,
      buildings: buildings,
      landmarks: landmarks,
    );
  }
}

class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.buildingId,
    this.floorNumber,
    this.nodeId,
  });

  final String id;
  final String title;
  final String subtitle;
  final double latitude;
  final double longitude;
  final SearchResultType type;
  final String? buildingId;
  final int? floorNumber;
  final String? nodeId;
}

enum SearchResultType { building, landmark, room }
