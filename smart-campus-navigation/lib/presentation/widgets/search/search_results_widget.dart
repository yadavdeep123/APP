import 'package:flutter/material.dart';
import '../../../domain/usecases/search_location.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    super.key,
    required this.results,
    required this.onResultTapped,
    this.recentSearches = const [],
    this.isLoading = false,
  });

  final List<SearchResult> results;
  final List<SearchResult> recentSearches;
  final void Function(SearchResult) onResultTapped;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = results.isNotEmpty ? results : recentSearches;
    final showRecent = results.isEmpty && recentSearches.isNotEmpty;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showRecent)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Recent Searches',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final result = items[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer,
                  child: Icon(
                    _iconForType(result.type),
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(result.title,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  result.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => onResultTapped(result),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconForType(SearchResultType type) {
    switch (type) {
      case SearchResultType.building:
        return Icons.business;
      case SearchResultType.room:
        return Icons.meeting_room;
      case SearchResultType.landmark:
        return Icons.place;
    }
  }
}
