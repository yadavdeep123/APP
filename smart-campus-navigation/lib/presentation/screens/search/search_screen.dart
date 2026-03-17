import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/route_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/location_utils.dart';
import '../../../domain/entities/route.dart' as domain;
import '../../../domain/usecases/search_location.dart';
import '../../../domain/entities/building.dart';
import '../../providers/search_provider.dart';
import '../../providers/map_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../providers/location_provider.dart';
import '../../providers/metrics_provider.dart';
import '../../widgets/search/search_bar_widget.dart';
import '../../widgets/search/search_results_widget.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);
    final recent = ref.watch(recentSearchesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SearchBarWidget(
                autofocus: true,
                readOnly: false,
              ),
            ),
            Expanded(
              child: SearchResultsWidget(
                results: results,
                recentSearches: recent,
                onResultTapped: (result) =>
                    _onSearchResultTapped(context, ref, result),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSearchResultTapped(
    BuildContext context,
    WidgetRef ref,
    SearchResult result,
  ) async {
    await ref.read(metricsServiceProvider).logEvent(
      'search_result_tapped',
      properties: {
        'type': result.type.name,
        'id': result.id,
        'title': result.title,
      },
    );

    await ref.read(userRepositoryProvider).saveRecentSearch(result);

    if (result.type == SearchResultType.room &&
        result.buildingId != null &&
        result.floorNumber != null) {
      final campus = await ref.read(campusDataProvider.future);
      Building? building;
      for (final item in campus.buildings) {
        if (item.id == result.buildingId) {
          building = item;
          break;
        }
      }

      ref.read(indoorSelectedDestinationProvider.notifier).state =
          result.nodeId ?? result.id;
      ref.read(searchQueryProvider.notifier).state = '';

      if (building == null) {
        if (context.mounted) {
          context.go(
            '${RouteConstants.home}/${RouteConstants.indoorMap}',
            extra: {
              'buildingId': result.buildingId,
              'floorNumber': result.floorNumber,
              'destinationNodeId': result.nodeId ?? result.id,
            },
          );
        }
        return;
      }
      final targetBuilding = building;

      final position =
          await ref.read(locationServiceProvider).getCurrentPosition();
      final entrance = _pickEntrance(
          targetBuilding, position?.latitude, position?.longitude);

      if (position == null || entrance == null) {
        ref.read(pendingIndoorNavigationProvider.notifier).state = null;
        ref.read(activeRouteProvider.notifier).state = null;
        ref.read(isNavigatingProvider.notifier).state = false;
        if (context.mounted) {
          context.go(
            '${RouteConstants.home}/${RouteConstants.indoorMap}',
            extra: {
              'buildingId': result.buildingId,
              'floorNumber': result.floorNumber,
              'destinationNodeId': result.nodeId ?? result.id,
            },
          );
        }
        return;
      }

      final isAlreadyAtEntrance = LocationUtils.isWithinRadius(
        position.latitude,
        position.longitude,
        entrance.latitude,
        entrance.longitude,
        AppConstants.buildingEntranceRadius,
      );

      if (isAlreadyAtEntrance) {
        ref.read(pendingIndoorNavigationProvider.notifier).state = null;
        ref.read(activeRouteProvider.notifier).state = null;
        ref.read(isNavigatingProvider.notifier).state = false;
        if (context.mounted) {
          context.go(
            '${RouteConstants.home}/${RouteConstants.indoorMap}',
            extra: {
              'buildingId': result.buildingId,
              'floorNumber': result.floorNumber,
              'destinationNodeId': result.nodeId ?? result.id,
            },
          );
        }
        return;
      }

      final hybridStopwatch = Stopwatch()..start();
      final route = await _safeBuildRoute(
        context,
        ref,
        () => ref.read(getRouteUseCaseProvider).call(
              originLat: position.latitude,
              originLng: position.longitude,
              destinationLat: entrance.latitude,
              destinationLng: entrance.longitude,
              destinationId: entrance.id,
              destinationName: '${targetBuilding.name} entrance',
              isIndoor: false,
            ),
      );
      hybridStopwatch.stop();

      if (route == null) {
        await ref.read(metricsServiceProvider).logEvent(
          'hybrid_outdoor_route_failed',
          properties: {
            'buildingId': targetBuilding.id,
            'destinationNodeId': result.nodeId ?? result.id,
            'latencyMs': hybridStopwatch.elapsedMilliseconds,
          },
        );
      }

      ref.read(activeRouteProvider.notifier).state = route;
      ref.read(pendingIndoorNavigationProvider.notifier).state =
          PendingIndoorNavigation(
        buildingId: targetBuilding.id,
        floorNumber: result.floorNumber!,
        destinationNodeId: result.nodeId ?? result.id,
        destinationName: result.title,
        entranceLatitude: entrance.latitude,
        entranceLongitude: entrance.longitude,
        entranceLabel: entrance.label,
      );
      ref.read(isNavigatingProvider.notifier).state = false;

      await ref.read(metricsServiceProvider).logEvent(
        'hybrid_outdoor_route_created',
        properties: {
          'buildingId': targetBuilding.id,
          'floorNumber': result.floorNumber,
          'destinationNodeId': result.nodeId ?? result.id,
          'latencyMs': hybridStopwatch.elapsedMilliseconds,
          'routeAvailable': route != null,
        },
      );

      if (context.mounted) {
        context.go(RouteConstants.home);
      }
      return;
    }

    final existingRoute = ref.read(activeRouteProvider);
    if (existingRoute != null && existingRoute.destinationId == result.id) {
      ref.read(searchQueryProvider.notifier).state = '';
      if (context.mounted) {
        context.go(RouteConstants.home);
      }
      return;
    }

    final position =
        await ref.read(locationServiceProvider).getCurrentPosition();
    if (position == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Location unavailable. Enable GPS and retry.')),
        );
      }
      return;
    }

    final outdoorStopwatch = Stopwatch()..start();
    final route = await _safeBuildRoute(
      context,
      ref,
      () => ref.read(getRouteUseCaseProvider).call(
            originLat: position.latitude,
            originLng: position.longitude,
            destinationLat: result.latitude,
            destinationLng: result.longitude,
            destinationId: result.id,
            destinationName: result.title,
            isIndoor: false,
          ),
    );
    outdoorStopwatch.stop();

    if (route == null) {
      await ref.read(metricsServiceProvider).logEvent(
        'outdoor_route_failed',
        properties: {
          'destinationId': result.id,
          'destinationName': result.title,
          'latencyMs': outdoorStopwatch.elapsedMilliseconds,
        },
      );
    }

    ref.read(activeRouteProvider.notifier).state = route;
    ref.read(pendingIndoorNavigationProvider.notifier).state = null;
    ref.read(isNavigatingProvider.notifier).state = false;
    ref.read(searchQueryProvider.notifier).state = '';

    await ref.read(metricsServiceProvider).logEvent(
      'outdoor_route_created',
      properties: {
        'destinationId': result.id,
        'destinationName': result.title,
        'latencyMs': outdoorStopwatch.elapsedMilliseconds,
        'routeAvailable': route != null,
      },
    );

    if (context.mounted) {
      context.go(RouteConstants.home);
    }
  }

  Future<domain.Route?> _safeBuildRoute(
    BuildContext context,
    WidgetRef ref,
    Future<domain.Route?> Function() action,
  ) async {
    try {
      return await action();
    } on Exception catch (error) {
      await ref.read(metricsServiceProvider).logEvent(
        'route_build_exception',
        properties: {
          'message': error.toString(),
          'screen': 'search',
        },
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Route build failed unexpectedly. Please retry in a few seconds.',
            ),
          ),
        );
      }
      return null;
    }
  }

  Entrance? _pickEntrance(
    Building building,
    double? userLat,
    double? userLng,
  ) {
    if (building.entrances.isEmpty) return null;
    if (userLat == null || userLng == null) return building.entrances.first;

    Entrance? best;
    double? bestDistance;
    for (final entrance in building.entrances) {
      final distance = LocationUtils.distanceInMetres(
        userLat,
        userLng,
        entrance.latitude,
        entrance.longitude,
      );
      if (bestDistance == null || distance < bestDistance) {
        best = entrance;
        bestDistance = distance;
      }
    }
    return best;
  }
}
