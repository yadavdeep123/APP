import 'package:flutter_test/flutter_test.dart';
import 'package:smart_campus_navigation/domain/entities/building.dart';
import 'package:smart_campus_navigation/core/utils/location_utils.dart';

void main() {
  group('Building Entity', () {
    test('creates building with floors and entrances', () {
      const building = Building(
        id: 'building_a',
        name: 'Building A',
        description: 'Main academic block',
        latitude: 40.123,
        longitude: -75.123,
        floors: [
          Floor(
            floorNumber: 1,
            label: 'Floor 1',
            buildingId: 'building_a',
          ),
          Floor(
            floorNumber: 2,
            label: 'Floor 2',
            buildingId: 'building_a',
          ),
        ],
      );

      expect(building.id, 'building_a');
      expect(building.name, 'Building A');
      expect(building.floors.length, 2);
      expect(building.floors.first.floorNumber, 1);
    });

    test('distance utility returns positive distance between two buildings',
        () {
      final metres = LocationUtils.distanceInMetres(
        40.123456,
        -75.123456,
        40.124456,
        -75.124456,
      );

      expect(metres, greaterThan(0));
      expect(LocationUtils.formatDistance(metres), isNotEmpty);
    });
  });
}
