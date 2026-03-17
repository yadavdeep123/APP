import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/usecases/search_location.dart';

class UserRepository {
  Box get _searchBox => Hive.box(AppConstants.recentSearchesBox);
  Box get _prefsBox => Hive.box(AppConstants.userPrefsBox);

  List<SearchResult> getRecentSearches() {
    final raw = _searchBox.get('items', defaultValue: <dynamic>[]) as List;
    return raw.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return SearchResult(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String,
        latitude: (m['latitude'] as num).toDouble(),
        longitude: (m['longitude'] as num).toDouble(),
        type: SearchResultType.values.firstWhere(
          (t) => t.name == m['type'],
          orElse: () => SearchResultType.landmark,
        ),
        buildingId: m['buildingId'] as String?,
        floorNumber: m['floorNumber'] as int?,
        nodeId: m['nodeId'] as String?,
      );
    }).toList();
  }

  Future<void> saveRecentSearch(SearchResult result) async {
    final raw = _searchBox.get('items', defaultValue: <dynamic>[]) as List;
    final current = raw
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();

    // Remove duplicate
    current.removeWhere((e) => e['id'] == result.id);

    // Prepend newest, cap at max
    current.insert(0, {
      'id': result.id,
      'title': result.title,
      'subtitle': result.subtitle,
      'latitude': result.latitude,
      'longitude': result.longitude,
      'type': result.type.name,
      'buildingId': result.buildingId,
      'floorNumber': result.floorNumber,
      'nodeId': result.nodeId,
    });

    if (current.length > AppConstants.maxRecentSearches) {
      current.removeLast();
    }

    await _searchBox.put('items', current);
  }

  Future<void> clearRecentSearches() async {
    await _searchBox.delete('items');
  }

  bool isFirstLaunch() {
    return _prefsBox.get(AppConstants.prefFirstLaunch, defaultValue: true)
        as bool;
  }

  Future<void> setFirstLaunchComplete() async {
    await _prefsBox.put(AppConstants.prefFirstLaunch, false);
  }
}
