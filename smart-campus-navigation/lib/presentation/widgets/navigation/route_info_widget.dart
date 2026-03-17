import 'package:flutter/material.dart';
import '../../../core/utils/location_utils.dart';
import '../../../domain/entities/route.dart' as domain;

class RouteInfoWidget extends StatelessWidget {
  const RouteInfoWidget({
    super.key,
    required this.route,
    this.onStartNavigation,
    this.onClose,
    this.routeTypeLabel,
    this.helperText,
    this.onSecondaryAction,
    this.secondaryActionLabel,
  });

  final domain.Route route;
  final VoidCallback? onStartNavigation;
  final VoidCallback? onClose;
  final String? routeTypeLabel;
  final String? helperText;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.destinationName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      routeTypeLabel ??
                          (route.isIndoor ? 'Indoor route' : 'Walking route'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCard(
                icon: Icons.access_time,
                value:
                    LocationUtils.formatWalkingTime(route.totalDistanceMetres),
                label: 'ETA',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.straighten,
                value: LocationUtils.formatDistance(route.totalDistanceMetres),
                label: 'Distance',
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.route,
                value: '${route.steps.length}',
                label: 'Steps',
              ),
            ],
          ),
          if (helperText != null) ...[
            const SizedBox(height: 12),
            Text(
              helperText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStartNavigation,
              icon: const Icon(Icons.navigation),
              label: const Text('Start Navigation'),
            ),
          ),
          if (onSecondaryAction != null && secondaryActionLabel != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onSecondaryAction,
                icon: const Icon(Icons.meeting_room),
                label: Text(secondaryActionLabel!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
