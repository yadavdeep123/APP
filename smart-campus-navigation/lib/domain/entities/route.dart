class Route {
  const Route({
    required this.originId,
    required this.destinationId,
    required this.destinationName,
    required this.waypoints,
    this.waypointFloorNumbers,
    required this.steps,
    required this.totalDistanceMetres,
    required this.estimatedTimeSeconds,
    this.isIndoor = false,
    this.floorNumber,
    this.buildingId,
  });

  final String originId;
  final String destinationId;
  final String destinationName;
  final List<List<double>> waypoints; // [[lng, lat], ...]
  final List<int>? waypointFloorNumbers;
  final List<RouteStep> steps;
  final double totalDistanceMetres;
  final int estimatedTimeSeconds;
  final bool isIndoor;
  final int? floorNumber;
  final String? buildingId;
}

class RouteStep {
  const RouteStep({
    required this.instruction,
    required this.distanceMetres,
    required this.maneuverType,
    required this.longitude,
    required this.latitude,
    this.floorNumber,
  });

  final String instruction;
  final double distanceMetres;
  final String maneuverType;
  final double longitude;
  final double latitude;
  final int? floorNumber;
}
