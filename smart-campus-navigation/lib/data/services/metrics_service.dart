import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';

class MetricsService {
  MetricsService()
      : _box = Hive.isBoxOpen(AppConstants.metricsBox)
            ? Hive.box(AppConstants.metricsBox)
            : null;

  final Box? _box;

  Future<void> logEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) async {
    final events = (_box?.get('events', defaultValue: <dynamic>[]) as List)
        .cast<dynamic>()
        .toList();

    events.add({
      'name': name,
      'timestampMs': DateTime.now().millisecondsSinceEpoch,
      'properties': properties ?? <String, dynamic>{},
    });

    if (events.length > 1000) {
      events.removeRange(0, events.length - 1000);
    }

    await _box?.put('events', events);
  }

  List<Map<String, dynamic>> getRecentEvents({int limit = 100}) {
    final events = (_box?.get('events', defaultValue: <dynamic>[]) as List)
        .cast<dynamic>()
        .toList();

    final mapped = events
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false);

    if (mapped.length <= limit) return mapped.reversed.toList();
    return mapped.sublist(mapped.length - limit).reversed.toList();
  }

  Future<void> clear() async {
    await _box?.put('events', <dynamic>[]);
  }
}
