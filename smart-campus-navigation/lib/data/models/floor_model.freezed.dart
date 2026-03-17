// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'floor_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FloorModel _$FloorModelFromJson(Map<String, dynamic> json) {
  return _FloorModel.fromJson(json);
}

/// @nodoc
mixin _$FloorModel {
  int get floorNumber => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get buildingId =>
      throw _privateConstructorUsedError; // Path to the GeoJSON asset for this floor's layout
  String? get geojsonAssetPath => throw _privateConstructorUsedError;
  List<RoomModel> get rooms => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FloorModelCopyWith<FloorModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FloorModelCopyWith<$Res> {
  factory $FloorModelCopyWith(
          FloorModel value, $Res Function(FloorModel) then) =
      _$FloorModelCopyWithImpl<$Res, FloorModel>;
  @useResult
  $Res call(
      {int floorNumber,
      String label,
      String buildingId,
      String? geojsonAssetPath,
      List<RoomModel> rooms});
}

/// @nodoc
class _$FloorModelCopyWithImpl<$Res, $Val extends FloorModel>
    implements $FloorModelCopyWith<$Res> {
  _$FloorModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? floorNumber = null,
    Object? label = null,
    Object? buildingId = null,
    Object? geojsonAssetPath = freezed,
    Object? rooms = null,
  }) {
    return _then(_value.copyWith(
      floorNumber: null == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      buildingId: null == buildingId
          ? _value.buildingId
          : buildingId // ignore: cast_nullable_to_non_nullable
              as String,
      geojsonAssetPath: freezed == geojsonAssetPath
          ? _value.geojsonAssetPath
          : geojsonAssetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rooms: null == rooms
          ? _value.rooms
          : rooms // ignore: cast_nullable_to_non_nullable
              as List<RoomModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FloorModelImplCopyWith<$Res>
    implements $FloorModelCopyWith<$Res> {
  factory _$$FloorModelImplCopyWith(
          _$FloorModelImpl value, $Res Function(_$FloorModelImpl) then) =
      __$$FloorModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int floorNumber,
      String label,
      String buildingId,
      String? geojsonAssetPath,
      List<RoomModel> rooms});
}

/// @nodoc
class __$$FloorModelImplCopyWithImpl<$Res>
    extends _$FloorModelCopyWithImpl<$Res, _$FloorModelImpl>
    implements _$$FloorModelImplCopyWith<$Res> {
  __$$FloorModelImplCopyWithImpl(
      _$FloorModelImpl _value, $Res Function(_$FloorModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? floorNumber = null,
    Object? label = null,
    Object? buildingId = null,
    Object? geojsonAssetPath = freezed,
    Object? rooms = null,
  }) {
    return _then(_$FloorModelImpl(
      floorNumber: null == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      buildingId: null == buildingId
          ? _value.buildingId
          : buildingId // ignore: cast_nullable_to_non_nullable
              as String,
      geojsonAssetPath: freezed == geojsonAssetPath
          ? _value.geojsonAssetPath
          : geojsonAssetPath // ignore: cast_nullable_to_non_nullable
              as String?,
      rooms: null == rooms
          ? _value._rooms
          : rooms // ignore: cast_nullable_to_non_nullable
              as List<RoomModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FloorModelImpl implements _FloorModel {
  const _$FloorModelImpl(
      {required this.floorNumber,
      required this.label,
      required this.buildingId,
      this.geojsonAssetPath,
      final List<RoomModel> rooms = const []})
      : _rooms = rooms;

  factory _$FloorModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FloorModelImplFromJson(json);

  @override
  final int floorNumber;
  @override
  final String label;
  @override
  final String buildingId;
// Path to the GeoJSON asset for this floor's layout
  @override
  final String? geojsonAssetPath;
  final List<RoomModel> _rooms;
  @override
  @JsonKey()
  List<RoomModel> get rooms {
    if (_rooms is EqualUnmodifiableListView) return _rooms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rooms);
  }

  @override
  String toString() {
    return 'FloorModel(floorNumber: $floorNumber, label: $label, buildingId: $buildingId, geojsonAssetPath: $geojsonAssetPath, rooms: $rooms)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FloorModelImpl &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.buildingId, buildingId) ||
                other.buildingId == buildingId) &&
            (identical(other.geojsonAssetPath, geojsonAssetPath) ||
                other.geojsonAssetPath == geojsonAssetPath) &&
            const DeepCollectionEquality().equals(other._rooms, _rooms));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, floorNumber, label, buildingId,
      geojsonAssetPath, const DeepCollectionEquality().hash(_rooms));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FloorModelImplCopyWith<_$FloorModelImpl> get copyWith =>
      __$$FloorModelImplCopyWithImpl<_$FloorModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FloorModelImplToJson(
      this,
    );
  }
}

abstract class _FloorModel implements FloorModel {
  const factory _FloorModel(
      {required final int floorNumber,
      required final String label,
      required final String buildingId,
      final String? geojsonAssetPath,
      final List<RoomModel> rooms}) = _$FloorModelImpl;

  factory _FloorModel.fromJson(Map<String, dynamic> json) =
      _$FloorModelImpl.fromJson;

  @override
  int get floorNumber;
  @override
  String get label;
  @override
  String get buildingId;
  @override // Path to the GeoJSON asset for this floor's layout
  String? get geojsonAssetPath;
  @override
  List<RoomModel> get rooms;
  @override
  @JsonKey(ignore: true)
  _$$FloorModelImplCopyWith<_$FloorModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
