// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landmark_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LandmarkModel _$LandmarkModelFromJson(Map<String, dynamic> json) {
  return _LandmarkModel.fromJson(json);
}

/// @nodoc
mixin _$LandmarkModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  LandmarkType get type => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get openingHours => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LandmarkModelCopyWith<LandmarkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandmarkModelCopyWith<$Res> {
  factory $LandmarkModelCopyWith(
          LandmarkModel value, $Res Function(LandmarkModel) then) =
      _$LandmarkModelCopyWithImpl<$Res, LandmarkModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      double latitude,
      double longitude,
      LandmarkType type,
      String? imageUrl,
      String? openingHours});
}

/// @nodoc
class _$LandmarkModelCopyWithImpl<$Res, $Val extends LandmarkModel>
    implements $LandmarkModelCopyWith<$Res> {
  _$LandmarkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? openingHours = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LandmarkType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LandmarkModelImplCopyWith<$Res>
    implements $LandmarkModelCopyWith<$Res> {
  factory _$$LandmarkModelImplCopyWith(
          _$LandmarkModelImpl value, $Res Function(_$LandmarkModelImpl) then) =
      __$$LandmarkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String description,
      double latitude,
      double longitude,
      LandmarkType type,
      String? imageUrl,
      String? openingHours});
}

/// @nodoc
class __$$LandmarkModelImplCopyWithImpl<$Res>
    extends _$LandmarkModelCopyWithImpl<$Res, _$LandmarkModelImpl>
    implements _$$LandmarkModelImplCopyWith<$Res> {
  __$$LandmarkModelImplCopyWithImpl(
      _$LandmarkModelImpl _value, $Res Function(_$LandmarkModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? type = null,
    Object? imageUrl = freezed,
    Object? openingHours = freezed,
  }) {
    return _then(_$LandmarkModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as LandmarkType,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LandmarkModelImpl implements _LandmarkModel {
  const _$LandmarkModelImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      required this.type,
      this.imageUrl,
      this.openingHours});

  factory _$LandmarkModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandmarkModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final LandmarkType type;
  @override
  final String? imageUrl;
  @override
  final String? openingHours;

  @override
  String toString() {
    return 'LandmarkModel(id: $id, name: $name, description: $description, latitude: $latitude, longitude: $longitude, type: $type, imageUrl: $imageUrl, openingHours: $openingHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandmarkModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, latitude,
      longitude, type, imageUrl, openingHours);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LandmarkModelImplCopyWith<_$LandmarkModelImpl> get copyWith =>
      __$$LandmarkModelImplCopyWithImpl<_$LandmarkModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandmarkModelImplToJson(
      this,
    );
  }
}

abstract class _LandmarkModel implements LandmarkModel {
  const factory _LandmarkModel(
      {required final int id,
      required final String name,
      required final String description,
      required final double latitude,
      required final double longitude,
      required final LandmarkType type}) = _$LandmarkModelImpl;

  factory _LandmarkModel.fromJson(Map<String, dynamic> json) =
      _$LandmarkModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  LandmarkType get type;
  @override
  String? get imageUrl;
  @override
  String? get openingHours;
  @override
  @JsonKey(ignore: true)
  _$$LandmarkModelImplCopyWith<_$LandmarkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
