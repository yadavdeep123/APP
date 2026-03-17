import 'dart:convert';

class MapUtils {
  MapUtils._();

  /// Parses a raw GeoJSON string and returns the decoded map.
  static Map<String, dynamic> parseGeoJson(String raw) {
    return json.decode(raw) as Map<String, dynamic>;
  }

  /// Extracts all [Point] feature coordinates [[lng, lat]] from a FeatureCollection.
  static List<List<double>> extractPointCoordinates(
      Map<String, dynamic> geoJson) {
    final features = geoJson['features'] as List<dynamic>? ?? [];
    final result = <List<double>>[];

    for (final feature in features) {
      final geometry = feature['geometry'] as Map<String, dynamic>?;
      if (geometry == null) continue;

      if (geometry['type'] == 'Point') {
        final coords = geometry['coordinates'] as List<dynamic>;
        result.add([
          (coords[0] as num).toDouble(),
          (coords[1] as num).toDouble(),
        ]);
      }
    }
    return result;
  }

  /// Extracts all feature properties from a FeatureCollection.
  static List<Map<String, dynamic>> extractFeatureProperties(
      Map<String, dynamic> geoJson) {
    final features = geoJson['features'] as List<dynamic>? ?? [];
    return features
        .map((f) => (f['properties'] as Map<String, dynamic>?) ?? {})
        .toList();
  }

  /// Builds a minimal GeoJSON LineString from an ordered list of [lng, lat] pairs.
  static Map<String, dynamic> buildLineStringGeoJson(
      List<List<double>> coordinates) {
    return {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': {},
          'geometry': {
            'type': 'LineString',
            'coordinates': coordinates,
          },
        }
      ],
    };
  }

  /// Builds a GeoJSON FeatureCollection with a single Point feature.
  static Map<String, dynamic> buildPointGeoJson(
    double lng,
    double lat, {
    Map<String, dynamic>? properties,
  }) {
    return {
      'type': 'FeatureCollection',
      'features': [
        {
          'type': 'Feature',
          'properties': properties ?? {},
          'geometry': {
            'type': 'Point',
            'coordinates': [lng, lat],
          },
        }
      ],
    };
  }
}
