import 'package:freezed_annotation/freezed_annotation.dart';
import 'room_model.dart';

part 'floor_model.freezed.dart';
part 'floor_model.g.dart';

@freezed
class FloorModel with _$FloorModel {
  const factory FloorModel({
    required int floorNumber,
    required String label,
    required String buildingId,
    // Path to the GeoJSON asset for this floor's layout
    String? geojsonAssetPath,
    @Default([]) List<RoomModel> rooms,
  }) = _FloorModel;

  factory FloorModel.fromJson(Map<String, dynamic> json) =>
      _$FloorModelFromJson(json);
}
