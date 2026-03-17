// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'building_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BuildingModel _$BuildingModelFromJson(Map<String, dynamic> json) {
  return _BuildingModel.fromJson(json);
}

/// @nodoc
mixin _$BuildingModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  List<FloorModel> get floors => throw _privateConstructorUsedError;
  List<EntranceModel> get entrances => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuildingModelCopyWith<BuildingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuildingModelCopyWith<$Res> {
  factory $BuildingModelCopyWith(
          BuildingModel value, $Res Function(BuildingModel) then) =
      _$BuildingModelCopyWithImpl<$Res, BuildingModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double latitude,
      double longitude,
      List<FloorModel> floors,
      List<EntranceModel> entrances,
      String? imageUrl,
      String? category});
}

/// @nodoc
class _$BuildingModelCopyWithImpl<$Res, $Val extends BuildingModel>
    implements $BuildingModelCopyWith<$Res> {
  _$BuildingModelCopyWithImpl(this._value, this._then);

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
    Object? floors = null,
    Object? entrances = null,
    Object? imageUrl = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      floors: null == floors
          ? _value.floors
          : floors // ignore: cast_nullable_to_non_nullable
              as List<FloorModel>,
      entrances: null == entrances
          ? _value.entrances
          : entrances // ignore: cast_nullable_to_non_nullable
              as List<EntranceModel>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuildingModelImplCopyWith<$Res>
    implements $BuildingModelCopyWith<$Res> {
  factory _$$BuildingModelImplCopyWith(
          _$BuildingModelImpl value, $Res Function(_$BuildingModelImpl) then) =
      __$$BuildingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double latitude,
      double longitude,
      List<FloorModel> floors,
      List<EntranceModel> entrances,
      String? imageUrl,
      String? category});
}

/// @nodoc
class __$$BuildingModelImplCopyWithImpl<$Res>
    extends _$BuildingModelCopyWithImpl<$Res, _$BuildingModelImpl>
    implements _$$BuildingModelImplCopyWith<$Res> {
  __$$BuildingModelImplCopyWithImpl(
      _$BuildingModelImpl _value, $Res Function(_$BuildingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? floors = null,
    Object? entrances = null,
    Object? imageUrl = freezed,
    Object? category = freezed,
  }) {
    return _then(_$BuildingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
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
      floors: null == floors
          ? _value._floors
          : floors // ignore: cast_nullable_to_non_nullable
              as List<FloorModel>,
      entrances: null == entrances
          ? _value._entrances
          : entrances // ignore: cast_nullable_to_non_nullable
              as List<EntranceModel>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuildingModelImpl implements _BuildingModel {
  const _$BuildingModelImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.latitude,
      required this.longitude,
      final List<FloorModel> floors = const [],
      final List<EntranceModel> entrances = const [],
      this.imageUrl,
      this.category})
      : _floors = floors,
        _entrances = entrances;

  factory _$BuildingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuildingModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double latitude;
  @override
  final double longitude;
  final List<FloorModel> _floors;
  @override
  @JsonKey()
  List<FloorModel> get floors {
    if (_floors is EqualUnmodifiableListView) return _floors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_floors);
  }

  final List<EntranceModel> _entrances;
  @override
  @JsonKey()
  List<EntranceModel> get entrances {
    if (_entrances is EqualUnmodifiableListView) return _entrances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entrances);
  }

  @override
  final String? imageUrl;
  @override
  final String? category;

  @override
  String toString() {
    return 'BuildingModel(id: $id, name: $name, description: $description, latitude: $latitude, longitude: $longitude, floors: $floors, entrances: $entrances, imageUrl: $imageUrl, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuildingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._floors, _floors) &&
            const DeepCollectionEquality()
                .equals(other._entrances, _entrances) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      latitude,
      longitude,
      const DeepCollectionEquality().hash(_floors),
      const DeepCollectionEquality().hash(_entrances),
      imageUrl,
      category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuildingModelImplCopyWith<_$BuildingModelImpl> get copyWith =>
      __$$BuildingModelImplCopyWithImpl<_$BuildingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuildingModelImplToJson(
      this,
    );
  }
}

abstract class _BuildingModel implements BuildingModel {
  const factory _BuildingModel(
      {required final String id,
      required final String name,
      required final String description,
      required final double latitude,
      required final double longitude,
      final List<FloorModel> floors,
      final List<EntranceModel> entrances,
      final String? imageUrl,
      final String? category}) = _$BuildingModelImpl;

  factory _BuildingModel.fromJson(Map<String, dynamic> json) =
      _$BuildingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  List<FloorModel> get floors;
  @override
  List<EntranceModel> get entrances;
  @override
  String? get imageUrl;
  @override
  String? get category;
  @override
  @JsonKey(ignore: true)
  _$$BuildingModelImplCopyWith<_$BuildingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EntranceModel _$EntranceModelFromJson(Map<String, dynamic> json) {
  return _EntranceModel.fromJson(json);
}

/// @nodoc
mixin _$EntranceModel {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EntranceModelCopyWith<EntranceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntranceModelCopyWith<$Res> {
  factory $EntranceModelCopyWith(
          EntranceModel value, $Res Function(EntranceModel) then) =
      _$EntranceModelCopyWithImpl<$Res, EntranceModel>;
  @useResult
  $Res call({String id, String label, double latitude, double longitude});
}

/// @nodoc
class _$EntranceModelCopyWithImpl<$Res, $Val extends EntranceModel>
    implements $EntranceModelCopyWith<$Res> {
  _$EntranceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntranceModelImplCopyWith<$Res>
    implements $EntranceModelCopyWith<$Res> {
  factory _$$EntranceModelImplCopyWith(
          _$EntranceModelImpl value, $Res Function(_$EntranceModelImpl) then) =
      __$$EntranceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String label, double latitude, double longitude});
}

/// @nodoc
class __$$EntranceModelImplCopyWithImpl<$Res>
    extends _$EntranceModelCopyWithImpl<$Res, _$EntranceModelImpl>
    implements _$$EntranceModelImplCopyWith<$Res> {
  __$$EntranceModelImplCopyWithImpl(
      _$EntranceModelImpl _value, $Res Function(_$EntranceModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$EntranceModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EntranceModelImpl implements _EntranceModel {
  const _$EntranceModelImpl(
      {required this.id,
      required this.label,
      required this.latitude,
      required this.longitude});

  factory _$EntranceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EntranceModelImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final double latitude;
  @override
  final double longitude;

  @override
  String toString() {
    return 'EntranceModel(id: $id, label: $label, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntranceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, label, latitude, longitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntranceModelImplCopyWith<_$EntranceModelImpl> get copyWith =>
      __$$EntranceModelImplCopyWithImpl<_$EntranceModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EntranceModelImplToJson(
      this,
    );
  }
}

abstract class _EntranceModel implements EntranceModel {
  const factory _EntranceModel(
      {required final String id,
      required final String label,
      required final double latitude,
      required final double longitude}) = _$EntranceModelImpl;

  factory _EntranceModel.fromJson(Map<String, dynamic> json) =
      _$EntranceModelImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  @JsonKey(ignore: true)
  _$$EntranceModelImplCopyWith<_$EntranceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
