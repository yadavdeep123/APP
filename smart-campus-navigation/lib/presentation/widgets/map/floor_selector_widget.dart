import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/building.dart';
import '../../providers/map_provider.dart';

class FloorSelectorWidget extends ConsumerWidget {
  const FloorSelectorWidget({
    super.key,
    required this.building,
    this.onFloorSelected,
  });

  final Building building;
  final void Function(int floorNumber)? onFloorSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFloor = ref.watch(selectedFloorProvider);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: building.floors.reversed.map((floor) {
          final isSelected = floor.floorNumber == selectedFloor;
          return GestureDetector(
            onTap: () {
              ref.read(selectedFloorProvider.notifier).state =
                  floor.floorNumber;
              onFloorSelected?.call(floor.floorNumber);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${floor.floorNumber}',
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
