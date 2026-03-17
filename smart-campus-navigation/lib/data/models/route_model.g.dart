// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RouteModelImpl _$$RouteModelImplFromJson(Map<String, dynamic> json) =>
    _$RouteModelImpl(
      originId: json['originId'] as String,
      destinationId: json['destinationId'] as String,
      destinationName: json['destinationName'] as String,
      waypoints: (json['waypoints'] as List<dynamic>)
          .map((e) => RouteCoordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
      waypointFloorNumbers: (json['waypointFloorNumbers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => RouteStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistanceMetres: (json['totalDistanceMetres'] as num).toDouble(),
      estimatedTimeSeconds: (json['estimatedTimeSeconds'] as num).toInt(),
      isIndoor: json['isIndoor'] as bool? ?? false,
      floorNumber: (json['floorNumber'] as num?)?.toInt(),
      buildingId: json['buildingId'] as String?,
    );

Map<String, dynamic> _$$RouteModelImplToJson(_$RouteModelImpl instance) =>
    <String, dynamic>{
      'originId': instance.originId,
      'destinationId': instance.destinationId,
      'destinationName': instance.destinationName,
      'waypoints': instance.waypoints,
      'waypointFloorNumbers': instance.waypointFloorNumbers,
      'steps': instance.steps,
      'totalDistanceMetres': instance.totalDistanceMetres,
      'estimatedTimeSeconds': instance.estimatedTimeSeconds,
      'isIndoor': instance.isIndoor,
      'floorNumber': instance.floorNumber,
      'buildingId': instance.buildingId,
    };

_$RouteCoordinateImpl _$$RouteCoordinateImplFromJson(
        Map<String, dynamic> json) =>
    _$RouteCoordinateImpl(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$RouteCoordinateImplToJson(
        _$RouteCoordinateImpl instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };

_$RouteStepImpl _$$RouteStepImplFromJson(Map<String, dynamic> json) =>
    _$RouteStepImpl(
      instruction: json['instruction'] as String,
      distanceMetres: (json['distanceMetres'] as num).toDouble(),
      maneuverType: json['maneuverType'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      floorNumber: (json['floorNumber'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$RouteStepImplToJson(_$RouteStepImpl instance) =>
    <String, dynamic>{
      'instruction': instance.instruction,
      'distanceMetres': instance.distanceMetres,
      'maneuverType': instance.maneuverType,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'floorNumber': instance.floorNumber,
    };
