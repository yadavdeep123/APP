import 'package:freezed_annotation/freezed_annotation.dart';
import 'floor_model.dart';

part 'building_model.freezed.dart';
part 'building_model.g.dart';

@freezed
class BuildingModel with _$BuildingModel {
  const factory BuildingModel({
    required String id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    @Default([]) List<FloorModel> floors,
    @Default([]) List<EntranceModel> entrances,
    String? imageUrl,
    String? category,
  }) = _BuildingModel;

  factory BuildingModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingModelFromJson(json);
}

@freezed
class EntranceModel with _$EntranceModel {
  const factory EntranceModel({
    required String id,
    required String label,
    required double latitude,
    required double longitude,
  }) = _EntranceModel;

  factory EntranceModel.fromJson(Map<String, dynamic> json) =>
      _$EntranceModelFromJson(json);
}
