import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';

class PilotService {
  PilotService() : _prefsBox = Hive.box(AppConstants.userPrefsBox);

  final Box _prefsBox;

  static const List<String> checklistItems = [
    'GPS permission granted',
    'Outdoor route visible',
    'Entrance marker visible',
    'Auto indoor handoff works',
    'Indoor route to room works',
    'Stairs/elevator preference works',
    'No crash during 10 minute walk',
  ];

  Map<String, bool> getChecklist() {
    final raw = _prefsBox.get(AppConstants.prefPilotChecklist);
    final persisted =
        raw is Map ? Map<String, dynamic>.from(raw) : <String, dynamic>{};

    final result = <String, bool>{};
    for (final item in checklistItems) {
      result[item] = persisted[item] == true;
    }
    return result;
  }

  Future<void> setChecklistValue(String key, bool value) async {
    final current = getChecklist();
    current[key] = value;
    await _prefsBox.put(AppConstants.prefPilotChecklist, current);
  }

  List<Map<String, dynamic>> getIssues() {
    final raw =
        _prefsBox.get(AppConstants.prefPilotIssues, defaultValue: <dynamic>[]);
    if (raw is! List) return <Map<String, dynamic>>[];

    return raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList(growable: false)
        .reversed
        .toList();
  }

  Future<void> addIssue({
    required String title,
    required String details,
    required String severity,
  }) async {
    final current =
        (_prefsBox.get(AppConstants.prefPilotIssues, defaultValue: <dynamic>[])
                as List)
            .cast<dynamic>()
            .toList();

    current.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'details': details,
      'severity': severity,
      'status': 'open',
      'createdAtMs': DateTime.now().millisecondsSinceEpoch,
    });

    await _prefsBox.put(AppConstants.prefPilotIssues, current);
  }

  Future<void> clearIssues() async {
    await _prefsBox.put(AppConstants.prefPilotIssues, <dynamic>[]);
  }

  Future<String> exportSnapshot(Map<String, dynamic> payload) async {
    const encoder = JsonEncoder.withIndent('  ');
    final content = encoder.convert(payload);

    final dir = Directory.systemTemp;
    final file = File(
      '${dir.path}${Platform.pathSeparator}smart_campus_diagnostics_${DateTime.now().millisecondsSinceEpoch}.json',
    );

    await file.writeAsString(content);
    return file.path;
  }

  Future<String> exportMarkdownReport({
    required Map<String, bool> checklist,
    required List<Map<String, dynamic>> issues,
    required Map<String, dynamic> metricsSummary,
    required Map<String, dynamic> diagnostics,
  }) async {
    String yesNo(bool value) => value ? 'Yes' : 'No';

    final openIssues = issues.where((i) => i['status'] == 'open').length;
    final checklistDone = checklist.values.where((v) => v).length;

    final buffer = StringBuffer()
      ..writeln('# Smart Campus Pilot Report')
      ..writeln()
      ..writeln('Generated: ${DateTime.now().toIso8601String()}')
      ..writeln()
      ..writeln('## Runtime')
      ..writeln(
          '- Demo mode: ${yesNo((metricsSummary['demoMode'] as bool?) ?? false)}')
      ..writeln(
          '- Pilot mode: ${yesNo((metricsSummary['pilotMode'] as bool?) ?? false)}')
      ..writeln()
      ..writeln('## Diagnostics Snapshot')
      ..writeln('- Location enabled: ${diagnostics['locationEnabled']}')
      ..writeln('- Permission: ${diagnostics['permissionStatus']}')
      ..writeln('- Route cache entries: ${diagnostics['routeCacheSize']}')
      ..writeln('- Campus cache entries: ${diagnostics['campusCacheSize']}')
      ..writeln()
      ..writeln('## KPI Summary')
      ..writeln('- Total events: ${metricsSummary['totalEvents']}')
      ..writeln('- Outdoor routes: ${metricsSummary['outdoorRoutesCreated']}')
      ..writeln('- Indoor handoffs: ${metricsSummary['indoorHandoffs']}')
      ..writeln('- Search selections: ${metricsSummary['searchSelections']}')
      ..writeln()
      ..writeln('## Checklist Progress')
      ..writeln('- Completed: $checklistDone / ${checklist.length}')
      ..writeln();

    for (final entry in checklist.entries) {
      buffer.writeln('- [${entry.value ? 'x' : ' '}] ${entry.key}');
    }

    buffer
      ..writeln()
      ..writeln('## Issues')
      ..writeln('- Open issues: $openIssues')
      ..writeln();

    if (issues.isEmpty) {
      buffer.writeln('- No issues logged.');
    } else {
      for (final issue in issues) {
        buffer.writeln(
          '- ${issue['severity']} | ${issue['status']} | ${issue['title']} | ${issue['details']}',
        );
      }
    }

    final dir = Directory.systemTemp;
    final file = File(
      '${dir.path}${Platform.pathSeparator}smart_campus_pilot_report_${DateTime.now().millisecondsSinceEpoch}.md',
    );
    await file.writeAsString(buffer.toString());
    return file.path;
  }
}
