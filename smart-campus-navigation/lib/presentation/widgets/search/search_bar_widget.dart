import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../presentation/providers/search_provider.dart';

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({
    super.key,
    this.onTap,
    this.autofocus = false,
    this.onChanged,
    this.readOnly = false,
  });

  final VoidCallback? onTap;
  final bool autofocus;
  final void Function(String)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Material(
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      borderRadius: BorderRadius.circular(28),
      child: TextField(
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: (v) {
          ref.read(searchQueryProvider.notifier).state = v;
          onChanged?.call(v);
        },
        decoration: InputDecoration(
          hintText: 'Search buildings, rooms, landmarks...',
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
          suffixIcon: Consumer(builder: (_, ref, __) {
            final q = ref.watch(searchQueryProvider);
            if (q.isEmpty) return const SizedBox.shrink();
            return IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                ref.read(searchQueryProvider.notifier).state = '';
              },
            );
          }),
          border: InputBorder.none,
          filled: false,
        ),
      ),
    );
  }
}
