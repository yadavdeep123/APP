import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_navigation/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:smart_campus_navigation/presentation/screens/navigation/navigation_screen.dart';

void main() {
  testWidgets('Onboarding renders and allows progression',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Campus Map'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Smart Search'), findsOneWidget);
  });

  testWidgets('Navigation screen renders fallback without active route',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: NavigationScreen(
            destinationId: 'library',
            destinationName: 'Library',
          ),
        ),
      ),
    );

    expect(find.text('No active route. Start navigation from Search or Map.'),
        findsOneWidget);
  });
}