import 'package:freezed_annotation/freezed_annotation.dart';

part 'landmark_model.freezed.dart';
part 'landmark_model.g.dart';

enum LandmarkType {
  building,
  outdoor,
  parking,
  emergency,
  transport,
  food,
  sports,
}

@freezed
class LandmarkModel with _$LandmarkModel {
  const factory LandmarkModel({
    required int id,
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    required LandmarkType type,
    String? imageUrl,
    String? openingHours,
  }) = _LandmarkModel;

  factory LandmarkModel.fromJson(Map<String, dynamic> json) =>
      _$LandmarkModelFromJson(json);
}
