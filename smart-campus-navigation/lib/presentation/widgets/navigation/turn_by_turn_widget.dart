import 'package:flutter/material.dart';
import '../../../core/utils/location_utils.dart';
import '../../../domain/entities/route.dart' as domain;

class TurnByTurnWidget extends StatelessWidget {
  const TurnByTurnWidget({
    super.key,
    required this.route,
    required this.currentStepIndex,
    this.onDismiss,
  });

  final domain.Route route;
  final int currentStepIndex;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastStep = currentStepIndex >= route.steps.length - 1;
    final step = isLastStep
        ? null
        : route.steps[currentStepIndex];

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Current instruction bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _maneuverIcon(step?.maneuverType ?? 'arrive'),
                  color: theme.colorScheme.onPrimary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLastStep
                            ? 'You have arrived at ${route.destinationName}'
                            : step!.instruction,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!isLastStep)
                        Text(
                          LocationUtils.formatDistance(step!.distanceMetres),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                                theme.colorScheme.onPrimary.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    onPressed: onDismiss,
                    icon: Icon(Icons.close,
                        color: theme.colorScheme.onPrimary),
                  ),
              ],
            ),
          ),
          // Summary bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(
                  icon: Icons.straighten,
                  label: LocationUtils.formatDistance(
                      route.totalDistanceMetres),
                ),
                _InfoChip(
                  icon: Icons.access_time,
                  label: LocationUtils.formatWalkingTime(
                      route.totalDistanceMetres),
                ),
                _InfoChip(
                  icon: route.isIndoor ? Icons.home : Icons.park,
                  label: route.isIndoor ? 'Indoor' : 'Outdoor',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _maneuverIcon(String type) {
    switch (type) {
      case 'turn':
        return Icons.turn_right;
      case 'depart':
        return Icons.my_location;
      case 'arrive':
        return Icons.flag;
      case 'roundabout':
        return Icons.roundabout_right;
      case 'merge':
        return Icons.merge;
      default:
        return Icons.straight;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
