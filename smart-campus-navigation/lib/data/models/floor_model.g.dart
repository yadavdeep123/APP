// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FloorModelImpl _$$FloorModelImplFromJson(Map<String, dynamic> json) =>
    _$FloorModelImpl(
      floorNumber: (json['floorNumber'] as num).toInt(),
      label: json['label'] as String,
      buildingId: json['buildingId'] as String,
      geojsonAssetPath: json['geojsonAssetPath'] as String?,
      rooms: (json['rooms'] as List<dynamic>?)
              ?.map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FloorModelImplToJson(_$FloorModelImpl instance) =>
    <String, dynamic>{
      'floorNumber': instance.floorNumber,
      'label': instance.label,
      'buildingId': instance.buildingId,
      'geojsonAssetPath': instance.geojsonAssetPath,
      'rooms': instance.rooms,
    };
