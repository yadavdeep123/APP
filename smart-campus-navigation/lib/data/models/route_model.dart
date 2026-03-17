import 'package:freezed_annotation/freezed_annotation.dart';

part 'route_model.freezed.dart';
part 'route_model.g.dart';

@freezed
class RouteModel with _$RouteModel {
  const factory RouteModel({
    required String originId,
    required String destinationId,
    required String destinationName,
    required List<RouteCoordinate> waypoints,
    List<int>? waypointFloorNumbers,
    required List<RouteStep> steps,
    required double totalDistanceMetres,
    required int estimatedTimeSeconds,
    @Default(false) bool isIndoor,
    int? floorNumber,
    String? buildingId,
  }) = _RouteModel;

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
}

@freezed
class RouteCoordinate with _$RouteCoordinate {
  const factory RouteCoordinate({
    required double longitude,
    required double latitude,
  }) = _RouteCoordinate;

  factory RouteCoordinate.fromJson(Map<String, dynamic> json) =>
      _$RouteCoordinateFromJson(json);
}

@freezed
class RouteStep with _$RouteStep {
  const factory RouteStep({
    required String instruction,
    required double distanceMetres,
    required String maneuverType,
    required double longitude,
    required double latitude,
    int? floorNumber,
  }) = _RouteStep;

  factory RouteStep.fromJson(Map<String, dynamic> json) =>
      _$RouteStepFromJson(json);
}
