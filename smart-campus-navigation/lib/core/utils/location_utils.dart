import 'dart:math';

class LocationUtils {
  LocationUtils._();

  static const double _earthRadiusMetres = 6371000.0;

  /// Haversine formula — returns distance in metres between two lat/lng pairs.
  static double distanceInMetres(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusMetres * c;
  }

  /// Human-readable distance string (e.g. "120 m" or "1.2 km").
  static String formatDistance(double metres) {
    if (metres < 1000) {
      return '${metres.round()} m';
    }
    return '${(metres / 1000).toStringAsFixed(1)} km';
  }

  /// Human-readable ETA in minutes at average walking speed (1.3 m/s).
  static String formatWalkingTime(double metres) {
    const double walkingSpeedMs = 1.3;
    final seconds = metres / walkingSpeedMs;
    final minutes = (seconds / 60).ceil();
    return '$minutes min';
  }

  static double _toRad(double degrees) => degrees * pi / 180.0;

  /// Returns true if [point] is within [radiusMetres] of [centre].
  static bool isWithinRadius(
    double pointLat,
    double pointLng,
    double centreLat,
    double centreLng,
    double radiusMetres,
  ) {
    return distanceInMetres(pointLat, pointLng, centreLat, centreLng) <=
        radiusMetres;
  }

  /// Converts a list of [lon, lat] GeoJSON coordinate pairs to a flat
  /// "lng1,lat1;lng2,lat2" string used by the Mapbox Directions API.
  static String toDirectionsCoordinates(List<List<double>> coords) {
    return coords.map((c) => '${c[0]},${c[1]}').join(';');
  }
}
