import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_model.freezed.dart';
part 'room_model.g.dart';

enum RoomType {
  classroom,
  office,
  restroom,
  cafeteria,
  laboratory,
  library,
  auditorium,
  staircase,
  elevator,
  entrance,
  other,
}

@freezed
class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    required String name,
    required RoomType type,
    required String buildingId,
    required int floorNumber,
    required double latitude,
    required double longitude,
    String? description,
    String? roomNumber,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}
