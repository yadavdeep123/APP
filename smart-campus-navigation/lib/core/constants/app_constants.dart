class AppConstants {
  AppConstants._();

  // Runtime mode flags (set via --dart-define)
  static const bool demoMode =
      bool.fromEnvironment('DEMO_MODE', defaultValue: false);
  static const bool pilotMode =
      bool.fromEnvironment('PILOT_MODE', defaultValue: false);

  // Mapbox API token (set via --dart-define=MAPBOX_TOKEN=pk.xxx or replace below)
  static const String mapboxPublicToken = String.fromEnvironment(
    'MAPBOX_TOKEN',
    defaultValue: 'YOUR_MAPBOX_PUBLIC_TOKEN',
  );

  // Optional Google Places API key for syncing campus POIs from Google Maps.
  static const String googlePlacesApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  // Hive box names
  static const String routeCacheBox = 'route_cache';
  static const String campusCacheBox = 'campus_cache';
  static const String recentSearchesBox = 'recent_searches';
  static const String userPrefsBox = 'user_prefs';
  static const String metricsBox = 'metrics';

  // Cache keys
  static const String campusInfoCacheKey = 'campus_info_v1';
  static const String landmarksCacheKey = 'landmarks_v1';

  // Limits
  static const int maxSearchResults = 20;
  static const int maxRecentSearches = 10;

  // Preference keys
  static const String prefFirstLaunch = 'first_launch';
  static const String prefPilotChecklist = 'pilot_checklist';
  static const String prefPilotIssues = 'pilot_issues';

  // Timeouts
  static const Duration httpTimeout = Duration(seconds: 10);
  static const Duration routeCacheTtl = Duration(hours: 24);
  static const Duration minRouteRequestInterval =
      Duration(milliseconds: 500);

    // Google Places query defaults for campus matching.
    static const int googlePlacesSearchRadiusMetres = 1800;
    static const String googlePlacesNearbyBaseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  // Navigation
  static const double buildingEntranceRadius = 50.0; // metres
}
