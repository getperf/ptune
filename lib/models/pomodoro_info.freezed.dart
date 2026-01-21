// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pomodoro_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PomodoroInfo {

 int get planned; double? get actual;
/// Create a copy of PomodoroInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PomodoroInfoCopyWith<PomodoroInfo> get copyWith => _$PomodoroInfoCopyWithImpl<PomodoroInfo>(this as PomodoroInfo, _$identity);

  /// Serializes this PomodoroInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PomodoroInfo&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.actual, actual) || other.actual == actual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planned,actual);

@override
String toString() {
  return 'PomodoroInfo(planned: $planned, actual: $actual)';
}


}

/// @nodoc
abstract mixin class $PomodoroInfoCopyWith<$Res>  {
  factory $PomodoroInfoCopyWith(PomodoroInfo value, $Res Function(PomodoroInfo) _then) = _$PomodoroInfoCopyWithImpl;
@useResult
$Res call({
 int planned, double? actual
});




}
/// @nodoc
class _$PomodoroInfoCopyWithImpl<$Res>
    implements $PomodoroInfoCopyWith<$Res> {
  _$PomodoroInfoCopyWithImpl(this._self, this._then);

  final PomodoroInfo _self;
  final $Res Function(PomodoroInfo) _then;

/// Create a copy of PomodoroInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planned = null,Object? actual = freezed,}) {
  return _then(_self.copyWith(
planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PomodoroInfo].
extension PomodoroInfoPatterns on PomodoroInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PomodoroInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PomodoroInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PomodoroInfo value)  $default,){
final _that = this;
switch (_that) {
case _PomodoroInfo():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PomodoroInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PomodoroInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int planned,  double? actual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PomodoroInfo() when $default != null:
return $default(_that.planned,_that.actual);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int planned,  double? actual)  $default,) {final _that = this;
switch (_that) {
case _PomodoroInfo():
return $default(_that.planned,_that.actual);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int planned,  double? actual)?  $default,) {final _that = this;
switch (_that) {
case _PomodoroInfo() when $default != null:
return $default(_that.planned,_that.actual);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PomodoroInfo implements PomodoroInfo {
  const _PomodoroInfo({required this.planned, this.actual});
  factory _PomodoroInfo.fromJson(Map<String, dynamic> json) => _$PomodoroInfoFromJson(json);

@override final  int planned;
@override final  double? actual;

/// Create a copy of PomodoroInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PomodoroInfoCopyWith<_PomodoroInfo> get copyWith => __$PomodoroInfoCopyWithImpl<_PomodoroInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PomodoroInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PomodoroInfo&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.actual, actual) || other.actual == actual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planned,actual);

@override
String toString() {
  return 'PomodoroInfo(planned: $planned, actual: $actual)';
}


}

/// @nodoc
abstract mixin class _$PomodoroInfoCopyWith<$Res> implements $PomodoroInfoCopyWith<$Res> {
  factory _$PomodoroInfoCopyWith(_PomodoroInfo value, $Res Function(_PomodoroInfo) _then) = __$PomodoroInfoCopyWithImpl;
@override @useResult
$Res call({
 int planned, double? actual
});




}
/// @nodoc
class __$PomodoroInfoCopyWithImpl<$Res>
    implements _$PomodoroInfoCopyWith<$Res> {
  __$PomodoroInfoCopyWithImpl(this._self, this._then);

  final _PomodoroInfo _self;
  final $Res Function(_PomodoroInfo) _then;

/// Create a copy of PomodoroInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planned = null,Object? actual = freezed,}) {
  return _then(_PomodoroInfo(
planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,actual: freezed == actual ? _self.actual : actual // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
