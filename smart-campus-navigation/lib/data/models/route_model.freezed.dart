// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'route_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RouteModel _$RouteModelFromJson(Map<String, dynamic> json) {
  return _RouteModel.fromJson(json);
}

/// @nodoc
mixin _$RouteModel {
  String get originId => throw _privateConstructorUsedError;
  String get destinationId => throw _privateConstructorUsedError;
  String get destinationName => throw _privateConstructorUsedError;
  List<RouteCoordinate> get waypoints => throw _privateConstructorUsedError;
  List<int>? get waypointFloorNumbers => throw _privateConstructorUsedError;
  List<RouteStep> get steps => throw _privateConstructorUsedError;
  double get totalDistanceMetres => throw _privateConstructorUsedError;
  int get estimatedTimeSeconds => throw _privateConstructorUsedError;
  bool get isIndoor => throw _privateConstructorUsedError;
  int? get floorNumber => throw _privateConstructorUsedError;
  String? get buildingId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RouteModelCopyWith<RouteModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteModelCopyWith<$Res> {
  factory $RouteModelCopyWith(
          RouteModel value, $Res Function(RouteModel) then) =
      _$RouteModelCopyWithImpl<$Res, RouteModel>;
  @useResult
  $Res call(
      {String originId,
      String destinationId,
      String destinationName,
      List<RouteCoordinate> waypoints,
      List<int>? waypointFloorNumbers,
      List<RouteStep> steps,
      double totalDistanceMetres,
      int estimatedTimeSeconds,
      bool isIndoor,
      int? floorNumber,
      String? buildingId});
}

/// @nodoc
class _$RouteModelCopyWithImpl<$Res, $Val extends RouteModel>
    implements $RouteModelCopyWith<$Res> {
  _$RouteModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originId = null,
    Object? destinationId = null,
    Object? destinationName = null,
    Object? waypoints = null,
    Object? waypointFloorNumbers = freezed,
    Object? steps = null,
    Object? totalDistanceMetres = null,
    Object? estimatedTimeSeconds = null,
    Object? isIndoor = null,
    Object? floorNumber = freezed,
    Object? buildingId = freezed,
  }) {
    return _then(_value.copyWith(
      originId: null == originId
          ? _value.originId
          : originId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationName: null == destinationName
          ? _value.destinationName
          : destinationName // ignore: cast_nullable_to_non_nullable
              as String,
      waypoints: null == waypoints
          ? _value.waypoints
          : waypoints // ignore: cast_nullable_to_non_nullable
              as List<RouteCoordinate>,
      waypointFloorNumbers: freezed == waypointFloorNumbers
          ? _value.waypointFloorNumbers
          : waypointFloorNumbers // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      steps: null == steps
          ? _value.steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RouteStep>,
      totalDistanceMetres: null == totalDistanceMetres
          ? _value.totalDistanceMetres
          : totalDistanceMetres // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTimeSeconds: null == estimatedTimeSeconds
          ? _value.estimatedTimeSeconds
          : estimatedTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isIndoor: null == isIndoor
          ? _value.isIndoor
          : isIndoor // ignore: cast_nullable_to_non_nullable
              as bool,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      buildingId: freezed == buildingId
          ? _value.buildingId
          : buildingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteModelImplCopyWith<$Res>
    implements $RouteModelCopyWith<$Res> {
  factory _$$RouteModelImplCopyWith(
          _$RouteModelImpl value, $Res Function(_$RouteModelImpl) then) =
      __$$RouteModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String originId,
      String destinationId,
      String destinationName,
      List<RouteCoordinate> waypoints,
      List<int>? waypointFloorNumbers,
      List<RouteStep> steps,
      double totalDistanceMetres,
      int estimatedTimeSeconds,
      bool isIndoor,
      int? floorNumber,
      String? buildingId});
}

/// @nodoc
class __$$RouteModelImplCopyWithImpl<$Res>
    extends _$RouteModelCopyWithImpl<$Res, _$RouteModelImpl>
    implements _$$RouteModelImplCopyWith<$Res> {
  __$$RouteModelImplCopyWithImpl(
      _$RouteModelImpl _value, $Res Function(_$RouteModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? originId = null,
    Object? destinationId = null,
    Object? destinationName = null,
    Object? waypoints = null,
    Object? waypointFloorNumbers = freezed,
    Object? steps = null,
    Object? totalDistanceMetres = null,
    Object? estimatedTimeSeconds = null,
    Object? isIndoor = null,
    Object? floorNumber = freezed,
    Object? buildingId = freezed,
  }) {
    return _then(_$RouteModelImpl(
      originId: null == originId
          ? _value.originId
          : originId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationId: null == destinationId
          ? _value.destinationId
          : destinationId // ignore: cast_nullable_to_non_nullable
              as String,
      destinationName: null == destinationName
          ? _value.destinationName
          : destinationName // ignore: cast_nullable_to_non_nullable
              as String,
      waypoints: null == waypoints
          ? _value._waypoints
          : waypoints // ignore: cast_nullable_to_non_nullable
              as List<RouteCoordinate>,
      waypointFloorNumbers: freezed == waypointFloorNumbers
          ? _value._waypointFloorNumbers
          : waypointFloorNumbers // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      steps: null == steps
          ? _value._steps
          : steps // ignore: cast_nullable_to_non_nullable
              as List<RouteStep>,
      totalDistanceMetres: null == totalDistanceMetres
          ? _value.totalDistanceMetres
          : totalDistanceMetres // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedTimeSeconds: null == estimatedTimeSeconds
          ? _value.estimatedTimeSeconds
          : estimatedTimeSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isIndoor: null == isIndoor
          ? _value.isIndoor
          : isIndoor // ignore: cast_nullable_to_non_nullable
              as bool,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      buildingId: freezed == buildingId
          ? _value.buildingId
          : buildingId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteModelImpl implements _RouteModel {
  const _$RouteModelImpl(
      {required this.originId,
      required this.destinationId,
      required this.destinationName,
      required final List<RouteCoordinate> waypoints,
      final List<int>? waypointFloorNumbers,
      required final List<RouteStep> steps,
      required this.totalDistanceMetres,
      required this.estimatedTimeSeconds,
      this.isIndoor = false,
      this.floorNumber,
      this.buildingId})
      : _waypoints = waypoints,
        _waypointFloorNumbers = waypointFloorNumbers,
        _steps = steps;

  factory _$RouteModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteModelImplFromJson(json);

  @override
  final String originId;
  @override
  final String destinationId;
  @override
  final String destinationName;
  final List<RouteCoordinate> _waypoints;
  @override
  List<RouteCoordinate> get waypoints {
    if (_waypoints is EqualUnmodifiableListView) return _waypoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_waypoints);
  }

  final List<int>? _waypointFloorNumbers;
  @override
  List<int>? get waypointFloorNumbers {
    final value = _waypointFloorNumbers;
    if (value == null) return null;
    if (_waypointFloorNumbers is EqualUnmodifiableListView)
      return _waypointFloorNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<RouteStep> _steps;
  @override
  List<RouteStep> get steps {
    if (_steps is EqualUnmodifiableListView) return _steps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_steps);
  }

  @override
  final double totalDistanceMetres;
  @override
  final int estimatedTimeSeconds;
  @override
  @JsonKey()
  final bool isIndoor;
  @override
  final int? floorNumber;
  @override
  final String? buildingId;

  @override
  String toString() {
    return 'RouteModel(originId: $originId, destinationId: $destinationId, destinationName: $destinationName, waypoints: $waypoints, waypointFloorNumbers: $waypointFloorNumbers, steps: $steps, totalDistanceMetres: $totalDistanceMetres, estimatedTimeSeconds: $estimatedTimeSeconds, isIndoor: $isIndoor, floorNumber: $floorNumber, buildingId: $buildingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteModelImpl &&
            (identical(other.originId, originId) ||
                other.originId == originId) &&
            (identical(other.destinationId, destinationId) ||
                other.destinationId == destinationId) &&
            (identical(other.destinationName, destinationName) ||
                other.destinationName == destinationName) &&
            const DeepCollectionEquality()
                .equals(other._waypoints, _waypoints) &&
            const DeepCollectionEquality()
                .equals(other._waypointFloorNumbers, _waypointFloorNumbers) &&
            const DeepCollectionEquality().equals(other._steps, _steps) &&
            (identical(other.totalDistanceMetres, totalDistanceMetres) ||
                other.totalDistanceMetres == totalDistanceMetres) &&
            (identical(other.estimatedTimeSeconds, estimatedTimeSeconds) ||
                other.estimatedTimeSeconds == estimatedTimeSeconds) &&
            (identical(other.isIndoor, isIndoor) ||
                other.isIndoor == isIndoor) &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber) &&
            (identical(other.buildingId, buildingId) ||
                other.buildingId == buildingId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      originId,
      destinationId,
      destinationName,
      const DeepCollectionEquality().hash(_waypoints),
      const DeepCollectionEquality().hash(_waypointFloorNumbers),
      const DeepCollectionEquality().hash(_steps),
      totalDistanceMetres,
      estimatedTimeSeconds,
      isIndoor,
      floorNumber,
      buildingId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteModelImplCopyWith<_$RouteModelImpl> get copyWith =>
      __$$RouteModelImplCopyWithImpl<_$RouteModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteModelImplToJson(
      this,
    );
  }
}

abstract class _RouteModel implements RouteModel {
  const factory _RouteModel(
      {required final String originId,
      required final String destinationId,
      required final String destinationName,
      required final List<RouteCoordinate> waypoints,
      final List<int>? waypointFloorNumbers,
      required final List<RouteStep> steps,
      required final double totalDistanceMetres,
      required final int estimatedTimeSeconds,
      final bool isIndoor,
      final int? floorNumber,
      final String? buildingId}) = _$RouteModelImpl;

  factory _RouteModel.fromJson(Map<String, dynamic> json) =
      _$RouteModelImpl.fromJson;

  @override
  String get originId;
  @override
  String get destinationId;
  @override
  String get destinationName;
  @override
  List<RouteCoordinate> get waypoints;
  @override
  List<int>? get waypointFloorNumbers;
  @override
  List<RouteStep> get steps;
  @override
  double get totalDistanceMetres;
  @override
  int get estimatedTimeSeconds;
  @override
  bool get isIndoor;
  @override
  int? get floorNumber;
  @override
  String? get buildingId;
  @override
  @JsonKey(ignore: true)
  _$$RouteModelImplCopyWith<_$RouteModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteCoordinate _$RouteCoordinateFromJson(Map<String, dynamic> json) {
  return _RouteCoordinate.fromJson(json);
}

/// @nodoc
mixin _$RouteCoordinate {
  double get longitude => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RouteCoordinateCopyWith<RouteCoordinate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteCoordinateCopyWith<$Res> {
  factory $RouteCoordinateCopyWith(
          RouteCoordinate value, $Res Function(RouteCoordinate) then) =
      _$RouteCoordinateCopyWithImpl<$Res, RouteCoordinate>;
  @useResult
  $Res call({double longitude, double latitude});
}

/// @nodoc
class _$RouteCoordinateCopyWithImpl<$Res, $Val extends RouteCoordinate>
    implements $RouteCoordinateCopyWith<$Res> {
  _$RouteCoordinateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longitude = null,
    Object? latitude = null,
  }) {
    return _then(_value.copyWith(
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteCoordinateImplCopyWith<$Res>
    implements $RouteCoordinateCopyWith<$Res> {
  factory _$$RouteCoordinateImplCopyWith(_$RouteCoordinateImpl value,
          $Res Function(_$RouteCoordinateImpl) then) =
      __$$RouteCoordinateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double longitude, double latitude});
}

/// @nodoc
class __$$RouteCoordinateImplCopyWithImpl<$Res>
    extends _$RouteCoordinateCopyWithImpl<$Res, _$RouteCoordinateImpl>
    implements _$$RouteCoordinateImplCopyWith<$Res> {
  __$$RouteCoordinateImplCopyWithImpl(
      _$RouteCoordinateImpl _value, $Res Function(_$RouteCoordinateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? longitude = null,
    Object? latitude = null,
  }) {
    return _then(_$RouteCoordinateImpl(
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteCoordinateImpl implements _RouteCoordinate {
  const _$RouteCoordinateImpl(
      {required this.longitude, required this.latitude});

  factory _$RouteCoordinateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteCoordinateImplFromJson(json);

  @override
  final double longitude;
  @override
  final double latitude;

  @override
  String toString() {
    return 'RouteCoordinate(longitude: $longitude, latitude: $latitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteCoordinateImpl &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, longitude, latitude);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteCoordinateImplCopyWith<_$RouteCoordinateImpl> get copyWith =>
      __$$RouteCoordinateImplCopyWithImpl<_$RouteCoordinateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteCoordinateImplToJson(
      this,
    );
  }
}

abstract class _RouteCoordinate implements RouteCoordinate {
  const factory _RouteCoordinate(
      {required final double longitude,
      required final double latitude}) = _$RouteCoordinateImpl;

  factory _RouteCoordinate.fromJson(Map<String, dynamic> json) =
      _$RouteCoordinateImpl.fromJson;

  @override
  double get longitude;
  @override
  double get latitude;
  @override
  @JsonKey(ignore: true)
  _$$RouteCoordinateImplCopyWith<_$RouteCoordinateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RouteStep _$RouteStepFromJson(Map<String, dynamic> json) {
  return _RouteStep.fromJson(json);
}

/// @nodoc
mixin _$RouteStep {
  String get instruction => throw _privateConstructorUsedError;
  double get distanceMetres => throw _privateConstructorUsedError;
  String get maneuverType => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  int? get floorNumber => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RouteStepCopyWith<RouteStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RouteStepCopyWith<$Res> {
  factory $RouteStepCopyWith(RouteStep value, $Res Function(RouteStep) then) =
      _$RouteStepCopyWithImpl<$Res, RouteStep>;
  @useResult
  $Res call(
      {String instruction,
      double distanceMetres,
      String maneuverType,
      double longitude,
      double latitude,
      int? floorNumber});
}

/// @nodoc
class _$RouteStepCopyWithImpl<$Res, $Val extends RouteStep>
    implements $RouteStepCopyWith<$Res> {
  _$RouteStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instruction = null,
    Object? distanceMetres = null,
    Object? maneuverType = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? floorNumber = freezed,
  }) {
    return _then(_value.copyWith(
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      distanceMetres: null == distanceMetres
          ? _value.distanceMetres
          : distanceMetres // ignore: cast_nullable_to_non_nullable
              as double,
      maneuverType: null == maneuverType
          ? _value.maneuverType
          : maneuverType // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RouteStepImplCopyWith<$Res>
    implements $RouteStepCopyWith<$Res> {
  factory _$$RouteStepImplCopyWith(
          _$RouteStepImpl value, $Res Function(_$RouteStepImpl) then) =
      __$$RouteStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String instruction,
      double distanceMetres,
      String maneuverType,
      double longitude,
      double latitude,
      int? floorNumber});
}

/// @nodoc
class __$$RouteStepImplCopyWithImpl<$Res>
    extends _$RouteStepCopyWithImpl<$Res, _$RouteStepImpl>
    implements _$$RouteStepImplCopyWith<$Res> {
  __$$RouteStepImplCopyWithImpl(
      _$RouteStepImpl _value, $Res Function(_$RouteStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instruction = null,
    Object? distanceMetres = null,
    Object? maneuverType = null,
    Object? longitude = null,
    Object? latitude = null,
    Object? floorNumber = freezed,
  }) {
    return _then(_$RouteStepImpl(
      instruction: null == instruction
          ? _value.instruction
          : instruction // ignore: cast_nullable_to_non_nullable
              as String,
      distanceMetres: null == distanceMetres
          ? _value.distanceMetres
          : distanceMetres // ignore: cast_nullable_to_non_nullable
              as double,
      maneuverType: null == maneuverType
          ? _value.maneuverType
          : maneuverType // ignore: cast_nullable_to_non_nullable
              as String,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RouteStepImpl implements _RouteStep {
  const _$RouteStepImpl(
      {required this.instruction,
      required this.distanceMetres,
      required this.maneuverType,
      required this.longitude,
      required this.latitude,
      this.floorNumber});

  factory _$RouteStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$RouteStepImplFromJson(json);

  @override
  final String instruction;
  @override
  final double distanceMetres;
  @override
  final String maneuverType;
  @override
  final double longitude;
  @override
  final double latitude;
  @override
  final int? floorNumber;

  @override
  String toString() {
    return 'RouteStep(instruction: $instruction, distanceMetres: $distanceMetres, maneuverType: $maneuverType, longitude: $longitude, latitude: $latitude, floorNumber: $floorNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RouteStepImpl &&
            (identical(other.instruction, instruction) ||
                other.instruction == instruction) &&
            (identical(other.distanceMetres, distanceMetres) ||
                other.distanceMetres == distanceMetres) &&
            (identical(other.maneuverType, maneuverType) ||
                other.maneuverType == maneuverType) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, instruction, distanceMetres,
      maneuverType, longitude, latitude, floorNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RouteStepImplCopyWith<_$RouteStepImpl> get copyWith =>
      __$$RouteStepImplCopyWithImpl<_$RouteStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RouteStepImplToJson(
      this,
    );
  }
}

abstract class _RouteStep implements RouteStep {
  const factory _RouteStep(
      {required final String instruction,
      required final double distanceMetres,
      required final String maneuverType,
      required final double longitude,
      required final double latitude,
      final int? floorNumber}) = _$RouteStepImpl;

  factory _RouteStep.fromJson(Map<String, dynamic> json) =
      _$RouteStepImpl.fromJson;

  @override
  String get instruction;
  @override
  double get distanceMetres;
  @override
  String get maneuverType;
  @override
  double get longitude;
  @override
  double get latitude;
  @override
  int? get floorNumber;
  @override
  @JsonKey(ignore: true)
  _$$RouteStepImplCopyWith<_$RouteStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
