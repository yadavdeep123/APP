import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/app_constants.dart';
import '../../core/utils/location_utils.dart';
import '../../domain/entities/landmark.dart';

class GooglePlacesService {
  GooglePlacesService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  bool get isConfigured => AppConstants.googlePlacesApiKey.trim().isNotEmpty;

  Future<List<Landmark>> fetchNearbyCampusLandmarks({
    required double latitude,
    required double longitude,
    String keyword = 'Sandip University',
  }) async {
    if (!isConfigured) return const <Landmark>[];

    final uri = Uri.parse(
      '${AppConstants.googlePlacesNearbyBaseUrl}'
      '?location=$latitude,$longitude'
      '&radius=${AppConstants.googlePlacesSearchRadiusMetres}'
      '&keyword=${Uri.encodeQueryComponent(keyword)}'
      '&key=${AppConstants.googlePlacesApiKey}',
    );

    final response = await _client.get(uri).timeout(AppConstants.httpTimeout);
    if (response.statusCode != 200) return const <Landmark>[];

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') return const <Landmark>[];

    final results = decoded['results'] as List<dynamic>? ?? const [];

    return results.map((item) {
      final map = item as Map<String, dynamic>;
      final location =
          (map['geometry'] as Map<String, dynamic>)['location'] as Map<String, dynamic>;
      final types = (map['types'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(growable: false);

      return Landmark(
        id: (map['place_id']?.toString().hashCode ?? map.hashCode).abs(),
        name: map['name'] as String? ?? 'Unnamed Place',
        description: map['vicinity'] as String? ??
            (types.isNotEmpty ? types.join(', ') : 'Google Places result'),
        latitude: (location['lat'] as num).toDouble(),
        longitude: (location['lng'] as num).toDouble(),
        type: _mapGoogleTypeToLandmarkType(types),
        openingHours: _openNowText(map),
      );
    }).toList(growable: false);
  }

  String _mapGoogleTypeToLandmarkType(List<String> types) {
    final t = types.join('|');

    if (t.contains('hospital') || t.contains('doctor')) return 'emergency';
    if (t.contains('bus_station') || t.contains('transit_station')) {
      return 'transport';
    }
    if (t.contains('restaurant') || t.contains('food') || t.contains('cafe')) {
      return 'food';
    }
    if (t.contains('stadium') || t.contains('gym') || t.contains('sports')) {
      return 'sports';
    }
    if (t.contains('parking')) return 'parking';
    if (t.contains('park') || t.contains('natural_feature')) return 'outdoor';
    return 'building';
  }

  String? _openNowText(Map<String, dynamic> map) {
    final hours = map['opening_hours'] as Map<String, dynamic>?;
    if (hours == null || !hours.containsKey('open_now')) return null;
    final openNow = hours['open_now'] == true;
    return openNow ? 'Open now' : 'Closed now';
  }

  List<Landmark> mergeDeduplicated({
    required List<Landmark> base,
    required List<Landmark> google,
  }) {
    final merged = <Landmark>[...base];

    for (final g in google) {
      final duplicate = merged.any((existing) {
        final sameName = existing.name.toLowerCase() == g.name.toLowerCase();
        final nearby = LocationUtils.distanceInMetres(
              existing.latitude,
              existing.longitude,
              g.latitude,
              g.longitude,
            ) <=
            45.0;
        return sameName || nearby;
      });

      if (!duplicate) {
        merged.add(g);
      }
    }

    return merged;
  }
}
