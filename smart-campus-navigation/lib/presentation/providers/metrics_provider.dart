import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/metrics_service.dart';

final metricsServiceProvider = Provider<MetricsService>((ref) {
  return MetricsService();
});

final recentMetricsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  return ref.read(metricsServiceProvider).getRecentEvents(limit: 200);
});

final metricsSummaryProvider = Provider<MetricsSummary>((ref) {
  final events = ref.watch(recentMetricsProvider);
  final counts = <String, int>{};

  for (final event in events) {
    final name = event['name'] as String? ?? 'unknown';
    counts[name] = (counts[name] ?? 0) + 1;
  }

  final outdoorRoutes = (counts['outdoor_route_created'] ?? 0) +
      (counts['hybrid_outdoor_route_created'] ?? 0);
  final indoorHandoffs = (counts['indoor_handoff_auto_triggered'] ?? 0) +
      (counts['indoor_handoff_manual_opened'] ?? 0);
  final searchTaps = counts['search_result_tapped'] ?? 0;

  return MetricsSummary(
    totalEvents: events.length,
    eventCounts: counts,
    outdoorRoutesCreated: outdoorRoutes,
    indoorHandoffs: indoorHandoffs,
    searchSelections: searchTaps,
  );
});

final recentRouteReplayProvider = Provider<List<RouteReplayItem>>((ref) {
  final events = ref.watch(recentMetricsProvider);
  final attempts = <RouteReplayItem>[];

  for (final event in events) {
    final name = event['name'] as String? ?? '';
    final props = Map<String, dynamic>.from(
      (event['properties'] as Map?) ?? <String, dynamic>{},
    );
    final timestampMs = event['timestampMs'] as int? ?? 0;

    final isRouteEvent = name == 'outdoor_route_created' ||
        name == 'outdoor_route_failed' ||
        name == 'hybrid_outdoor_route_created' ||
        name == 'hybrid_outdoor_route_failed' ||
        name == 'indoor_route_created' ||
        name == 'indoor_route_failed';

    if (!isRouteEvent) continue;

    final status = name.contains('failed') ? 'failed' : 'success';
    final type = name.contains('indoor')
        ? 'indoor'
        : name.contains('hybrid')
            ? 'hybrid-outdoor'
            : 'outdoor';

    final destination = (props['destinationName'] as String?) ??
        (props['destinationNodeId'] as String?) ??
        (props['destinationId'] as String?) ??
        'unknown';

    final handoffEvent = events.firstWhere(
      (e) {
        final n = e['name'] as String? ?? '';
        if (n != 'indoor_handoff_auto_triggered' &&
            n != 'indoor_handoff_manual_opened') {
          return false;
        }
        final t = e['timestampMs'] as int? ?? 0;
        return t >= timestampMs && t <= timestampMs + 10 * 60 * 1000;
      },
      orElse: () => <String, dynamic>{},
    );

    String handoff = 'n/a';
    if (handoffEvent.isNotEmpty) {
      final handoffName = handoffEvent['name'] as String? ?? '';
      handoff = handoffName == 'indoor_handoff_auto_triggered'
          ? 'auto'
          : 'manual';
    }

    attempts.add(RouteReplayItem(
      timestampMs: timestampMs,
      routeType: type,
      destination: destination,
      status: status,
      latencyMs: props['latencyMs'] as int?,
      handoff: handoff,
    ));
  }

  return attempts.take(5).toList(growable: false);
});

class MetricsSummary {
  const MetricsSummary({
    required this.totalEvents,
    required this.eventCounts,
    required this.outdoorRoutesCreated,
    required this.indoorHandoffs,
    required this.searchSelections,
  });

  final int totalEvents;
  final Map<String, int> eventCounts;
  final int outdoorRoutesCreated;
  final int indoorHandoffs;
  final int searchSelections;
}

class RouteReplayItem {
  const RouteReplayItem({
    required this.timestampMs,
    required this.routeType,
    required this.destination,
    required this.status,
    required this.latencyMs,
    required this.handoff,
  });

  final int timestampMs;
  final String routeType;
  final String destination;
  final String status;
  final int? latencyMs;
  final String handoff;
}
