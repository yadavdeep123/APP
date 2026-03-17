import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/route_constants.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/screens/onboarding/onboarding_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/map/indoor_map_screen.dart';
import 'presentation/screens/diagnostics/diagnostics_screen.dart';

class SmartCampusApp extends StatelessWidget {
  const SmartCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Campus Navigation',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteConstants.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: RouteConstants.indoorMap,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>? ?? {};
            return IndoorMapScreen(
              buildingId: extra['buildingId'] as String? ?? '',
              floorNumber: extra['floorNumber'] as int? ?? 1,
              initialDestinationNodeId:
                  extra['destinationNodeId'] as String?,
            );
          },
        ),
        GoRoute(
          path: RouteConstants.diagnostics,
          builder: (context, state) => const DiagnosticsScreen(),
        ),
      ],
    ),
  ],
);
