// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuildingModelImpl _$$BuildingModelImplFromJson(Map<String, dynamic> json) =>
    _$BuildingModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      floors: (json['floors'] as List<dynamic>?)
              ?.map((e) => FloorModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      entrances: (json['entrances'] as List<dynamic>?)
              ?.map((e) => EntranceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$BuildingModelImplToJson(_$BuildingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'floors': instance.floors,
      'entrances': instance.entrances,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
    };

_$EntranceModelImpl _$$EntranceModelImplFromJson(Map<String, dynamic> json) =>
    _$EntranceModelImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$EntranceModelImplToJson(_$EntranceModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
