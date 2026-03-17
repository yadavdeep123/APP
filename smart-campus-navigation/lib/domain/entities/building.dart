class Building {
  const Building({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.floors = const [],
    this.entrances = const [],
    this.imageUrl,
    this.category,
  });

  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final List<Floor> floors;
  final List<Entrance> entrances;
  final String? imageUrl;
  final String? category;
}

class Floor {
  const Floor({
    required this.floorNumber,
    required this.label,
    required this.buildingId,
    this.geojsonAssetPath,
    this.rooms = const [],
  });

  final int floorNumber;
  final String label;
  final String buildingId;
  final String? geojsonAssetPath;
  final List<Room> rooms;
}

class Room {
  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.buildingId,
    required this.floorNumber,
    required this.latitude,
    required this.longitude,
    this.description,
    this.roomNumber,
  });

  final String id;
  final String name;
  final String type;
  final String buildingId;
  final int floorNumber;
  final double latitude;
  final double longitude;
  final String? description;
  final String? roomNumber;
}

class Entrance {
  const Entrance({
    required this.id,
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String label;
  final double latitude;
  final double longitude;
}
