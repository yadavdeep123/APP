class MapConstants {
  MapConstants._();

  // Default map centre (Sandip University, Madhubani campus)
  static const double defaultLatitude = 26.3659;
  static const double defaultLongitude = 86.0749;
  static const double defaultZoom = 15.0;

  // Mapbox styles
  static const String styleStreets = 'mapbox://styles/mapbox/streets-v12';
  static const String styleLight = 'mapbox://styles/mapbox/light-v11';
  static const String styleSatellite =
      'mapbox://styles/mapbox/satellite-streets-v12';

  // Outdoor route layer identifiers
  static const String routeSource = 'route-source';
  static const String routeLayer = 'route-layer';
  static const int routeLineColor = 0xFF3A80F0;
  static const double routeLineWidth = 5.0;

  // Campus outdoor overlay
  static const String campusOutdoorSource = 'campus-outdoor-source';
  static const String campusOutdoorFillLayer = 'campus-outdoor-fill';
  static const String campusOutdoorLineLayer = 'campus-outdoor-line';
  static const String campusOutdoorPointLayer = 'campus-outdoor-point';
  static const String campusPoiSource = 'campus-poi-source';
  static const String campusPoiLayer = 'campus-poi-layer';
  static const String campusPoiLabelLayer = 'campus-poi-label-layer';

  // Indoor map zoom / layers
  static const double indoorZoom = 18.0;
  static const String indoorFloorSource = 'indoor-floor-source';
  static const String indoorFloorFillLayer = 'indoor-floor-fill';
  static const String indoorFloorLineLayer = 'indoor-floor-line';
  static const String indoorRoomSource = 'indoor-room-source';
  static const String indoorRoomLayer = 'indoor-room-layer';
  static const int routeLineColorIndoor = 0xFFE53935;

  // Entrance / handoff overlay
  static const String entranceHandoffSource = 'entrance-handoff-source';
  static const String entranceHandoffLayer = 'entrance-handoff-layer';

  // Mapbox Directions API
  static const String directionsBaseUrl =
      'https://api.mapbox.com/directions/v5/mapbox/walking';
}
