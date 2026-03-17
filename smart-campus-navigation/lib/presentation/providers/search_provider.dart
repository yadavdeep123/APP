import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/services/search_service.dart';
import '../../domain/usecases/search_location.dart';
import 'map_provider.dart';

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final searchLocationUseCaseProvider = Provider<SearchLocation>((ref) {
  return SearchLocation(ref.read(searchServiceProvider));
});

// Live search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Search results computed from query + campus data
final searchResultsProvider =
    Provider<List<SearchResult>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final campusData = ref.watch(campusDataProvider);
  final useCase = ref.read(searchLocationUseCaseProvider);

  return campusData.when(
    data: (data) => useCase(
      query: query,
      buildings: data.buildings,
      landmarks: data.landmarks,
    ),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Recent searches from Hive
final recentSearchesProvider = Provider<List<SearchResult>>((ref) {
  final repo = ref.read(userRepositoryProvider);
  return repo.getRecentSearches();
});
