// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoro_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PomodoroInfo _$PomodoroInfoFromJson(Map<String, dynamic> json) {
  return _PomodoroInfo.fromJson(json);
}

/// @nodoc
mixin _$PomodoroInfo {
  int get planned => throw _privateConstructorUsedError;
  double? get actual => throw _privateConstructorUsedError;

  /// Serializes this PomodoroInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PomodoroInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PomodoroInfoCopyWith<PomodoroInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PomodoroInfoCopyWith<$Res> {
  factory $PomodoroInfoCopyWith(
    PomodoroInfo value,
    $Res Function(PomodoroInfo) then,
  ) = _$PomodoroInfoCopyWithImpl<$Res, PomodoroInfo>;
  @useResult
  $Res call({int planned, double? actual});
}

/// @nodoc
class _$PomodoroInfoCopyWithImpl<$Res, $Val extends PomodoroInfo>
    implements $PomodoroInfoCopyWith<$Res> {
  _$PomodoroInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PomodoroInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? planned = null, Object? actual = freezed}) {
    return _then(
      _value.copyWith(
            planned: null == planned
                ? _value.planned
                : planned // ignore: cast_nullable_to_non_nullable
                      as int,
            actual: freezed == actual
                ? _value.actual
                : actual // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PomodoroInfoImplCopyWith<$Res>
    implements $PomodoroInfoCopyWith<$Res> {
  factory _$$PomodoroInfoImplCopyWith(
    _$PomodoroInfoImpl value,
    $Res Function(_$PomodoroInfoImpl) then,
  ) = __$$PomodoroInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int planned, double? actual});
}

/// @nodoc
class __$$PomodoroInfoImplCopyWithImpl<$Res>
    extends _$PomodoroInfoCopyWithImpl<$Res, _$PomodoroInfoImpl>
    implements _$$PomodoroInfoImplCopyWith<$Res> {
  __$$PomodoroInfoImplCopyWithImpl(
    _$PomodoroInfoImpl _value,
    $Res Function(_$PomodoroInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PomodoroInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? planned = null, Object? actual = freezed}) {
    return _then(
      _$PomodoroInfoImpl(
        planned: null == planned
            ? _value.planned
            : planned // ignore: cast_nullable_to_non_nullable
                  as int,
        actual: freezed == actual
            ? _value.actual
            : actual // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PomodoroInfoImpl implements _PomodoroInfo {
  const _$PomodoroInfoImpl({required this.planned, this.actual});

  factory _$PomodoroInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PomodoroInfoImplFromJson(json);

  @override
  final int planned;
  @override
  final double? actual;

  @override
  String toString() {
    return 'PomodoroInfo(planned: $planned, actual: $actual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PomodoroInfoImpl &&
            (identical(other.planned, planned) || other.planned == planned) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, planned, actual);

  /// Create a copy of PomodoroInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PomodoroInfoImplCopyWith<_$PomodoroInfoImpl> get copyWith =>
      __$$PomodoroInfoImplCopyWithImpl<_$PomodoroInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PomodoroInfoImplToJson(this);
  }
}

abstract class _PomodoroInfo implements PomodoroInfo {
  const factory _PomodoroInfo({
    required final int planned,
    final double? actual,
  }) = _$PomodoroInfoImpl;

  factory _PomodoroInfo.fromJson(Map<String, dynamic> json) =
      _$PomodoroInfoImpl.fromJson;

  @override
  int get planned;
  @override
  double? get actual;

  /// Create a copy of PomodoroInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PomodoroInfoImplCopyWith<_$PomodoroInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
