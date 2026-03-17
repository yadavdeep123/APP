import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'core/constants/app_constants.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Mapbox token before any map widget loads
  MapboxOptions.setAccessToken(AppConstants.mapboxPublicToken);

  // Initialise Hive for local storage
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(AppConstants.routeCacheBox),
    Hive.openBox(AppConstants.campusCacheBox),
    Hive.openBox(AppConstants.recentSearchesBox),
    Hive.openBox(AppConstants.userPrefsBox),
    Hive.openBox(AppConstants.metricsBox),
  ]);

  runApp(const ProviderScope(child: SmartCampusApp()));
}
