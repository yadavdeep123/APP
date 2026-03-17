import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/navigation_provider.dart';
import '../../widgets/navigation/turn_by_turn_widget.dart';

class NavigationScreen extends ConsumerWidget {
  const NavigationScreen({
    super.key,
    required this.destinationId,
    required this.destinationName,
  });

  final String destinationId;
  final String destinationName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRoute = ref.watch(activeRouteProvider);
    final currentStep = ref.watch(currentStepIndexProvider);

    if (activeRoute == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Navigation')),
        body: const Center(
          child: Text('No active route. Start navigation from Search or Map.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('To $destinationName'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(isNavigatingProvider.notifier).state = false;
              ref.read(activeRouteProvider.notifier).state = null;
              ref.read(currentStepIndexProvider.notifier).state = 0;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
      body: Column(
        children: [
          TurnByTurnWidget(
            route: activeRoute,
            currentStepIndex: currentStep,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: activeRoute.steps.length,
              itemBuilder: (context, index) {
                final step = activeRoute.steps[index];
                final isCurrent = index == currentStep;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isCurrent
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(step.instruction),
                  subtitle: Text('${step.distanceMetres.round()} m'),
                  onTap: () {
                    ref.read(currentStepIndexProvider.notifier).state = index;
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
