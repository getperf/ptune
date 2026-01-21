// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_task_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyTaskList {

 String get id; String get title; String? get description;
/// Create a copy of MyTaskList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTaskListCopyWith<MyTaskList> get copyWith => _$MyTaskListCopyWithImpl<MyTaskList>(this as MyTaskList, _$identity);

  /// Serializes this MyTaskList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTaskList&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description);

@override
String toString() {
  return 'MyTaskList(id: $id, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class $MyTaskListCopyWith<$Res>  {
  factory $MyTaskListCopyWith(MyTaskList value, $Res Function(MyTaskList) _then) = _$MyTaskListCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description
});




}
/// @nodoc
class _$MyTaskListCopyWithImpl<$Res>
    implements $MyTaskListCopyWith<$Res> {
  _$MyTaskListCopyWithImpl(this._self, this._then);

  final MyTaskList _self;
  final $Res Function(MyTaskList) _then;

/// Create a copy of MyTaskList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyTaskList].
extension MyTaskListPatterns on MyTaskList {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyTaskList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyTaskList() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyTaskList value)  $default,){
final _that = this;
switch (_that) {
case _MyTaskList():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyTaskList value)?  $default,){
final _that = this;
switch (_that) {
case _MyTaskList() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyTaskList() when $default != null:
return $default(_that.id,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description)  $default,) {final _that = this;
switch (_that) {
case _MyTaskList():
return $default(_that.id,_that.title,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _MyTaskList() when $default != null:
return $default(_that.id,_that.title,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyTaskList implements MyTaskList {
  const _MyTaskList({required this.id, required this.title, this.description});
  factory _MyTaskList.fromJson(Map<String, dynamic> json) => _$MyTaskListFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;

/// Create a copy of MyTaskList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyTaskListCopyWith<_MyTaskList> get copyWith => __$MyTaskListCopyWithImpl<_MyTaskList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyTaskListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyTaskList&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description);

@override
String toString() {
  return 'MyTaskList(id: $id, title: $title, description: $description)';
}


}

/// @nodoc
abstract mixin class _$MyTaskListCopyWith<$Res> implements $MyTaskListCopyWith<$Res> {
  factory _$MyTaskListCopyWith(_MyTaskList value, $Res Function(_MyTaskList) _then) = __$MyTaskListCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description
});




}
/// @nodoc
class __$MyTaskListCopyWithImpl<$Res>
    implements _$MyTaskListCopyWith<$Res> {
  __$MyTaskListCopyWithImpl(this._self, this._then);

  final _MyTaskList _self;
  final $Res Function(_MyTaskList) _then;

/// Create a copy of MyTaskList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,}) {
  return _then(_MyTaskList(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
