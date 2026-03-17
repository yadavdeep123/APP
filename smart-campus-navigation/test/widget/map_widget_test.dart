import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_campus_navigation/domain/entities/landmark.dart';
import 'package:smart_campus_navigation/domain/entities/building.dart';
import 'package:smart_campus_navigation/presentation/widgets/map/landmark_marker_widget.dart';
import 'package:smart_campus_navigation/presentation/widgets/map/floor_selector_widget.dart';

void main() {
  testWidgets('LandmarkMarkerWidget shows landmark name',
      (WidgetTester tester) async {
    const landmark = Landmark(
      id: 1,
      name: 'Library',
      description: 'Main library',
      latitude: 40.7,
      longitude: -74.0,
      type: 'building',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LandmarkMarkerWidget(landmark: landmark),
        ),
      ),
    );

    expect(find.text('Library'), findsOneWidget);
    expect(find.byIcon(Icons.business), findsOneWidget);
  });

  testWidgets('FloorSelectorWidget renders available floors',
      (WidgetTester tester) async {
    const building = Building(
      id: 'building_a',
      name: 'Building A',
      description: 'Academic building',
      latitude: 40.12,
      longitude: -75.12,
      floors: [
        Floor(floorNumber: 1, label: 'Floor 1', buildingId: 'building_a'),
        Floor(floorNumber: 2, label: 'Floor 2', buildingId: 'building_a'),
      ],
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FloorSelectorWidget(building: building),
          ),
        ),
      ),
    );

    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });
}
