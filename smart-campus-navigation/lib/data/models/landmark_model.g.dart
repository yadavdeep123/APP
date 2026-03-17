// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LandmarkModelImpl _$$LandmarkModelImplFromJson(Map<String, dynamic> json) =>
    _$LandmarkModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: $enumDecode(_$LandmarkTypeEnumMap, json['type']),
      imageUrl: json['imageUrl'] as String?,
      openingHours: json['openingHours'] as String?,
    );

Map<String, dynamic> _$$LandmarkModelImplToJson(_$LandmarkModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$LandmarkTypeEnumMap[instance.type]!,
      'imageUrl': instance.imageUrl,
      'openingHours': instance.openingHours,
    };

const _$LandmarkTypeEnumMap = {
  LandmarkType.building: 'building',
  LandmarkType.outdoor: 'outdoor',
  LandmarkType.parking: 'parking',
  LandmarkType.emergency: 'emergency',
  LandmarkType.transport: 'transport',
  LandmarkType.food: 'food',
  LandmarkType.sports: 'sports',
};
