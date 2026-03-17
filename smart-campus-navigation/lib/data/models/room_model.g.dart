// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomModelImpl _$$RoomModelImplFromJson(Map<String, dynamic> json) =>
    _$RoomModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$RoomTypeEnumMap, json['type']),
      buildingId: json['buildingId'] as String,
      floorNumber: (json['floorNumber'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      description: json['description'] as String?,
      roomNumber: json['roomNumber'] as String?,
    );

Map<String, dynamic> _$$RoomModelImplToJson(_$RoomModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$RoomTypeEnumMap[instance.type]!,
      'buildingId': instance.buildingId,
      'floorNumber': instance.floorNumber,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'description': instance.description,
      'roomNumber': instance.roomNumber,
    };

const _$RoomTypeEnumMap = {
  RoomType.classroom: 'classroom',
  RoomType.office: 'office',
  RoomType.restroom: 'restroom',
  RoomType.cafeteria: 'cafeteria',
  RoomType.laboratory: 'laboratory',
  RoomType.library: 'library',
  RoomType.auditorium: 'auditorium',
  RoomType.staircase: 'staircase',
  RoomType.elevator: 'elevator',
  RoomType.entrance: 'entrance',
  RoomType.other: 'other',
};
