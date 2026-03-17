import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_navigation/presentation/widgets/search/search_bar_widget.dart';
import 'package:smart_campus_navigation/presentation/widgets/search/search_results_widget.dart';
import 'package:smart_campus_navigation/domain/usecases/search_location.dart';

void main() {
  testWidgets('SearchBarWidget displays a text field',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SearchBarWidget(),
        ),
      ),
    ));

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('SearchResultsWidget renders supplied results',
      (WidgetTester tester) async {
    const results = [
      SearchResult(
        id: 'library',
        title: 'Library',
        subtitle: 'Central library',
        latitude: 40.12,
        longitude: -75.12,
        type: SearchResultType.landmark,
      ),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SearchResultsWidget(
          results: results,
          onResultTapped: (_) {},
        ),
      ),
    ));

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Central library'), findsOneWidget);
  });
}
