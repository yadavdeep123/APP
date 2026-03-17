import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/map_constants.dart';
import '../../core/utils/location_utils.dart';
import '../models/route_model.dart';

/// Wraps all Mapbox REST API calls (Directions, Geocoding).
/// The actual Mapbox Maps SDK rendering is handled in presentation layer
/// widgets via mapbox_maps_flutter directly.
class MapboxService {
  MapboxService({http.Client? client})
      : _client = client ?? http.Client(),
        _routeCacheBox = Hive.isBoxOpen(AppConstants.routeCacheBox)
            ? Hive.box(AppConstants.routeCacheBox)
            : null;

  final http.Client _client;
  final Box? _routeCacheBox;
  DateTime? _lastRouteRequestAt;

  /// Calls the Mapbox Directions API and returns a [RouteModel] for walking.
  Future<RouteModel?> getWalkingRoute({
    required double originLng,
    required double originLat,
    required double destinationLng,
    required double destinationLat,
    required String destinationId,
    required String destinationName,
  }) async {
    final cacheKey = _buildRouteCacheKey(
      originLng: originLng,
      originLat: originLat,
      destinationLng: destinationLng,
      destinationLat: destinationLat,
      destinationId: destinationId,
    );

    final cached = _readCachedRoute(cacheKey);
    if (cached != null) return cached;

    if (!_isMapboxTokenConfigured()) {
      final demoRoute = _buildDemoRoute(
        originLng: originLng,
        originLat: originLat,
        destinationLng: destinationLng,
        destinationLat: destinationLat,
        destinationId: destinationId,
        destinationName: destinationName,
      );
      _writeCachedRoute(cacheKey, demoRoute);
      return demoRoute;
    }

    // Throttle calls to reduce API usage spikes on Mapbox free tier.
    if (_isRequestThrottled()) {
      return _readCachedRoute(cacheKey, allowExpired: true);
    }

    final coordinates = '$originLng,$originLat;$destinationLng,$destinationLat';

    final uri = Uri.parse(
      '${MapConstants.directionsBaseUrl}/$coordinates'
      '?steps=true'
      '&geometries=geojson'
      '&overview=full'
      '&access_token=${AppConstants.mapboxPublicToken}',
    );

    try {
      _lastRouteRequestAt = DateTime.now();
      final response = await _client.get(uri).timeout(AppConstants.httpTimeout);

      if (response.statusCode != 200) {
        if (AppConstants.demoMode) {
          final demoRoute = _buildDemoRoute(
            originLng: originLng,
            originLat: originLat,
            destinationLng: destinationLng,
            destinationLat: destinationLat,
            destinationId: destinationId,
            destinationName: destinationName,
          );
          _writeCachedRoute(cacheKey, demoRoute);
          return demoRoute;
        }
        return _readCachedRoute(cacheKey, allowExpired: true);
      }

      final body = json.decode(response.body) as Map<String, dynamic>;
      final routes = body['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) return null;

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coords = (geometry['coordinates'] as List<dynamic>).map((c) {
        final pair = c as List<dynamic>;
        return RouteCoordinate(
          longitude: (pair[0] as num).toDouble(),
          latitude: (pair[1] as num).toDouble(),
        );
      }).toList();

      final legs = route['legs'] as List<dynamic>;
      final steps = <RouteStep>[];
      for (final leg in legs) {
        for (final step in (leg['steps'] as List<dynamic>)) {
          final s = step as Map<String, dynamic>;
          final maneuver = s['maneuver'] as Map<String, dynamic>;
          final loc = maneuver['location'] as List<dynamic>;
          steps.add(RouteStep(
            instruction: maneuver['instruction'] as String? ?? '',
            distanceMetres: (s['distance'] as num).toDouble(),
            maneuverType: maneuver['type'] as String? ?? '',
            longitude: (loc[0] as num).toDouble(),
            latitude: (loc[1] as num).toDouble(),
          ));
        }
      }

      final result = RouteModel(
        originId: 'current_location',
        destinationId: destinationId,
        destinationName: destinationName,
        waypoints: coords,
        steps: steps,
        totalDistanceMetres: (route['distance'] as num).toDouble(),
        estimatedTimeSeconds: (route['duration'] as num).toInt(),
      );
      _writeCachedRoute(cacheKey, result);
      return result;
    } on Exception {
      if (AppConstants.demoMode) {
        final demoRoute = _buildDemoRoute(
          originLng: originLng,
          originLat: originLat,
          destinationLng: destinationLng,
          destinationLat: destinationLat,
          destinationId: destinationId,
          destinationName: destinationName,
        );
        _writeCachedRoute(cacheKey, demoRoute);
        return demoRoute;
      }
      return _readCachedRoute(cacheKey, allowExpired: true);
    }
  }

  bool _isMapboxTokenConfigured() {
    final token = AppConstants.mapboxPublicToken.trim();
    if (token.isEmpty) return false;
    if (token.contains('YOUR_MAPBOX_PUBLIC_TOKEN_HERE')) return false;
    return token.startsWith('pk.');
  }

  RouteModel _buildDemoRoute({
    required double originLng,
    required double originLat,
    required double destinationLng,
    required double destinationLat,
    required String destinationId,
    required String destinationName,
  }) {
    final straightDistance = LocationUtils.distanceInMetres(
      originLat,
      originLng,
      destinationLat,
      destinationLng,
    );

    final waypoints = [
      RouteCoordinate(longitude: originLng, latitude: originLat),
      RouteCoordinate(longitude: destinationLng, latitude: destinationLat),
    ];

    final steps = [
      RouteStep(
        instruction: 'Head towards $destinationName',
        distanceMetres: straightDistance,
        maneuverType: 'straight',
        longitude: destinationLng,
        latitude: destinationLat,
      ),
    ];

    return RouteModel(
      originId: 'current_location',
      destinationId: destinationId,
      destinationName: destinationName,
      waypoints: waypoints,
      steps: steps,
      totalDistanceMetres: straightDistance,
      estimatedTimeSeconds: (straightDistance / 1.3).round(),
    );
  }

  bool _isRequestThrottled() {
    if (_lastRouteRequestAt == null) return false;
    return DateTime.now().difference(_lastRouteRequestAt!) <
        AppConstants.minRouteRequestInterval;
  }

  String _buildRouteCacheKey({
    required double originLng,
    required double originLat,
    required double destinationLng,
    required double destinationLat,
    required String destinationId,
  }) {
    String r(double value) => value.toStringAsFixed(5);
    return '${r(originLng)}:${r(originLat)}:${r(destinationLng)}:${r(destinationLat)}:$destinationId';
  }

  RouteModel? _readCachedRoute(String key, {bool allowExpired = false}) {
    final raw = _routeCacheBox?.get(key);
    if (raw is! Map) return null;

    final payload = Map<String, dynamic>.from(raw);
    final storedAtMs = payload['storedAtMs'] as int?;
    final routeJson = payload['route'] as Map<dynamic, dynamic>?;
    if (storedAtMs == null || routeJson == null) return null;

    final age = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(storedAtMs),
    );
    if (!allowExpired && age > AppConstants.routeCacheTtl) return null;

    return RouteModel.fromJson(
      Map<String, dynamic>.from(routeJson),
    );
  }

  void _writeCachedRoute(String key, RouteModel route) {
    // Ensure nested Freezed objects are converted to plain JSON maps/lists
    // before writing to Hive (which cannot store unknown custom objects).
    final safeRouteJson =
        jsonDecode(jsonEncode(route.toJson())) as Map<String, dynamic>;

    _routeCacheBox?.put(key, {
      'storedAtMs': DateTime.now().millisecondsSinceEpoch,
      'route': safeRouteJson,
    });
  }
}
