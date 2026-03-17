import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_constants.dart';
import '../../providers/location_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../providers/pilot_provider.dart';

class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> {
  late Future<_DiagnosticsSnapshot> _snapshotFuture;
  final TextEditingController _issueTitleController = TextEditingController();
  final TextEditingController _issueDetailsController = TextEditingController();
  String _issueSeverity = 'medium';

  @override
  void initState() {
    super.initState();
    _snapshotFuture = _collectSnapshot();
  }

  Future<_DiagnosticsSnapshot> _collectSnapshot() async {
    final locationEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Permission.location.status;

    Position? position;
    if (locationEnabled && permission.isGranted) {
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 4),
        );
      } on Exception {
        position = null;
      }
    }

    final routeCacheSize = Hive.isBoxOpen(AppConstants.routeCacheBox)
        ? Hive.box(AppConstants.routeCacheBox).length
        : 0;
    final campusCacheSize = Hive.isBoxOpen(AppConstants.campusCacheBox)
        ? Hive.box(AppConstants.campusCacheBox).length
        : 0;
    final metricsSize = Hive.isBoxOpen(AppConstants.metricsBox)
        ? Hive.box(AppConstants.metricsBox).length
        : 0;

    return _DiagnosticsSnapshot(
      locationEnabled: locationEnabled,
      permissionStatus: permission,
      currentPosition: position,
      routeCacheSize: routeCacheSize,
      campusCacheSize: campusCacheSize,
      metricsBoxSize: metricsSize,
      mapboxTokenConfigured: _isMapboxTokenConfigured(),
    );
  }

  @override
  void dispose() {
    _issueTitleController.dispose();
    _issueDetailsController.dispose();
    super.dispose();
  }

  bool _isMapboxTokenConfigured() {
    final token = AppConstants.mapboxPublicToken.trim();
    if (token.isEmpty) return false;
    if (token.contains('YOUR_MAPBOX_PUBLIC_TOKEN_HERE')) return false;
    return token.startsWith('pk.');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = ref.watch(metricsSummaryProvider);
    final routeReplay = ref.watch(recentRouteReplayProvider);
    final pilotService = ref.watch(pilotServiceProvider);
    final checklist = pilotService.getChecklist();
    final issues = pilotService.getIssues();

    final outdoorCreated = (summary.eventCounts['outdoor_route_created'] ?? 0) +
        (summary.eventCounts['hybrid_outdoor_route_created'] ?? 0);
    final outdoorFailed = (summary.eventCounts['outdoor_route_failed'] ?? 0) +
        (summary.eventCounts['hybrid_outdoor_route_failed'] ?? 0);
    final indoorCreated = summary.eventCounts['indoor_route_created'] ?? 0;
    final indoorFailed = summary.eventCounts['indoor_route_failed'] ?? 0;

    String percent(int success, int fail) {
      final total = success + fail;
      if (total == 0) return 'N/A';
      return '${((success * 100) / total).toStringAsFixed(0)}%';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostics'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                _snapshotFuture = _collectSnapshot();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<_DiagnosticsSnapshot>(
        future: _snapshotFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Runtime Mode', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  const _ModeChip(
                    label: 'Demo: ${AppConstants.demoMode ? 'ON' : 'OFF'}',
                    enabled: AppConstants.demoMode,
                  ),
                  const _ModeChip(
                    label: 'Pilot: ${AppConstants.pilotMode ? 'ON' : 'OFF'}',
                    enabled: AppConstants.pilotMode,
                  ),
                  _ModeChip(
                    label:
                        'Mapbox token: ${data.mapboxTokenConfigured ? 'SET' : 'MISSING'}',
                    enabled: data.mapboxTokenConfigured,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('GPS and Permissions', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Location service: ${data.locationEnabled ? 'Enabled' : 'Disabled'}'),
                      Text('Permission: ${data.permissionStatus.name}'),
                      Text(
                        data.currentPosition == null
                            ? 'Current position: unavailable'
                            : 'Current position: ${data.currentPosition!.latitude.toStringAsFixed(6)}, ${data.currentPosition!.longitude.toStringAsFixed(6)}',
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () async {
                              await ref
                                  .read(locationServiceProvider)
                                  .openLocationAppSettings();
                            },
                            icon: const Icon(Icons.settings),
                            label: const Text('Open App Settings'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () async {
                              await Permission.location.request();
                              if (mounted) {
                                setState(() {
                                  _snapshotFuture = _collectSnapshot();
                                });
                              }
                            },
                            icon: const Icon(Icons.gps_fixed),
                            label: const Text('Request Permission'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Storage and Cache', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.alt_route),
                      title: const Text('Route cache entries'),
                      trailing: Text('${data.routeCacheSize}'),
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.map),
                      title: const Text('Campus cache entries'),
                      trailing: Text('${data.campusCacheSize}'),
                    ),
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.analytics),
                      title: const Text('Metrics box keys'),
                      trailing: Text('${data.metricsBoxSize}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Metrics Summary', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total events: ${summary.totalEvents}'),
                      Text('Search selections: ${summary.searchSelections}'),
                      Text('Outdoor routes: ${summary.outdoorRoutesCreated}'),
                      Text('Indoor handoffs: ${summary.indoorHandoffs}'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _KpiChip(
                            label: 'Outdoor route success',
                            value: percent(outdoorCreated, outdoorFailed),
                          ),
                          _KpiChip(
                            label: 'Indoor route success',
                            value: percent(indoorCreated, indoorFailed),
                          ),
                          _KpiChip(
                            label: 'Open issues',
                            value:
                                '${issues.where((i) => i['status'] == 'open').length}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: summary.eventCounts.entries
                            .map((e) =>
                                Chip(label: Text('${e.key}: ${e.value}')))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await ref.read(metricsServiceProvider).clear();
                          if (mounted) {
                            setState(() {
                              _snapshotFuture = _collectSnapshot();
                            });
                          }
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear Metrics'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Route Replay (Last 5)', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: routeReplay.isEmpty
                      ? const [
                          ListTile(
                            title: Text('No route attempts logged yet.'),
                          )
                        ]
                      : routeReplay
                          .map(
                            (item) => ListTile(
                              dense: true,
                              leading: Icon(
                                item.status == 'success'
                                    ? Icons.check_circle_outline
                                    : Icons.error_outline,
                                color: item.status == 'success'
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.error,
                              ),
                              title: Text(
                                  '${item.routeType} -> ${item.destination}'),
                              subtitle: Text(
                                '${DateTime.fromMillisecondsSinceEpoch(item.timestampMs)} | latency: ${item.latencyMs ?? '-'} ms | handoff: ${item.handoff}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(item.status),
                            ),
                          )
                          .toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Pilot Checklist', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: checklist.entries
                      .map(
                        (entry) => CheckboxListTile(
                          dense: true,
                          value: entry.value,
                          title: Text(entry.key),
                          onChanged: (value) async {
                            await pilotService.setChecklistValue(
                              entry.key,
                              value ?? false,
                            );
                            if (mounted) {
                              setState(() {
                                _snapshotFuture = _collectSnapshot();
                              });
                            }
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              Text('Issue Tracker', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      TextField(
                        controller: _issueTitleController,
                        decoration: const InputDecoration(
                          labelText: 'Issue title',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _issueDetailsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Issue details',
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _issueSeverity,
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('Low')),
                          DropdownMenuItem(
                              value: 'medium', child: Text('Medium')),
                          DropdownMenuItem(value: 'high', child: Text('High')),
                          DropdownMenuItem(
                              value: 'critical', child: Text('Critical')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _issueSeverity = value);
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Severity',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final title = _issueTitleController.text.trim();
                                final details =
                                    _issueDetailsController.text.trim();
                                if (title.isEmpty) return;

                                await pilotService.addIssue(
                                  title: title,
                                  details: details,
                                  severity: _issueSeverity,
                                );

                                _issueTitleController.clear();
                                _issueDetailsController.clear();

                                if (mounted) {
                                  setState(() {
                                    _snapshotFuture = _collectSnapshot();
                                  });
                                }
                              },
                              icon: const Icon(Icons.bug_report_outlined),
                              label: const Text('Add Issue'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () async {
                              await pilotService.clearIssues();
                              if (mounted) {
                                setState(() {
                                  _snapshotFuture = _collectSnapshot();
                                });
                              }
                            },
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...issues.map(
                (issue) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.report_problem_outlined,
                      color: _severityColor(
                          issue['severity'] as String? ?? 'low', theme),
                    ),
                    title: Text(issue['title'] as String? ?? 'Issue'),
                    subtitle: Text(
                      '${issue['severity']} · ${issue['details'] ?? ''}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Export', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final payload = {
                              'generatedAtMs':
                                  DateTime.now().millisecondsSinceEpoch,
                              'runtime': {
                                'demoMode': AppConstants.demoMode,
                                'pilotMode': AppConstants.pilotMode,
                                'mapboxTokenConfigured':
                                    data.mapboxTokenConfigured,
                              },
                              'diagnostics': {
                                'locationEnabled': data.locationEnabled,
                                'permissionStatus': data.permissionStatus.name,
                                'currentPosition': data.currentPosition == null
                                    ? null
                                    : {
                                        'latitude':
                                            data.currentPosition!.latitude,
                                        'longitude':
                                            data.currentPosition!.longitude,
                                      },
                                'routeCacheSize': data.routeCacheSize,
                                'campusCacheSize': data.campusCacheSize,
                                'metricsBoxSize': data.metricsBoxSize,
                              },
                              'metricsSummary': {
                                'totalEvents': summary.totalEvents,
                                'outdoorRoutesCreated':
                                    summary.outdoorRoutesCreated,
                                'indoorHandoffs': summary.indoorHandoffs,
                                'searchSelections': summary.searchSelections,
                                'eventCounts': summary.eventCounts,
                              },
                              'events': ref
                                  .read(metricsServiceProvider)
                                  .getRecentEvents(limit: 1000),
                              'checklist': checklist,
                              'issues': issues,
                            };

                            final filePath =
                                await pilotService.exportSnapshot(payload);
                            await Clipboard.setData(
                                ClipboardData(text: filePath));

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Exported JSON. Path copied: $filePath'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.file_download_outlined),
                          label: const Text('Export Diagnostics JSON'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final diagnostics = {
                              'locationEnabled': data.locationEnabled,
                              'permissionStatus': data.permissionStatus.name,
                              'routeCacheSize': data.routeCacheSize,
                              'campusCacheSize': data.campusCacheSize,
                            };
                            final summaryPayload = {
                              'demoMode': AppConstants.demoMode,
                              'pilotMode': AppConstants.pilotMode,
                              'totalEvents': summary.totalEvents,
                              'outdoorRoutesCreated':
                                  summary.outdoorRoutesCreated,
                              'indoorHandoffs': summary.indoorHandoffs,
                              'searchSelections': summary.searchSelections,
                            };

                            final filePath =
                                await pilotService.exportMarkdownReport(
                              checklist: checklist,
                              issues: issues,
                              metricsSummary: summaryPayload,
                              diagnostics: diagnostics,
                            );
                            await Clipboard.setData(
                                ClipboardData(text: filePath));

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Exported Markdown report. Path copied: $filePath'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.description_outlined),
                          label: const Text('Export Pilot Report (.md)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _severityColor(String severity, ThemeData theme) {
    switch (severity) {
      case 'critical':
        return theme.colorScheme.error;
      case 'high':
        return Colors.deepOrange;
      case 'medium':
        return Colors.amber.shade800;
      case 'low':
      default:
        return theme.colorScheme.primary;
    }
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.enabled,
  });

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: enabled
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: enabled
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _DiagnosticsSnapshot {
  const _DiagnosticsSnapshot({
    required this.locationEnabled,
    required this.permissionStatus,
    required this.currentPosition,
    required this.routeCacheSize,
    required this.campusCacheSize,
    required this.metricsBoxSize,
    required this.mapboxTokenConfigured,
  });

  final bool locationEnabled;
  final PermissionStatus permissionStatus;
  final Position? currentPosition;
  final int routeCacheSize;
  final int campusCacheSize;
  final int metricsBoxSize;
  final bool mapboxTokenConfigured;
}
