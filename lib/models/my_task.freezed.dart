// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyTask {

 String get id; String get title; String? get tasklistId; String? get note; String? get parent; String? get position; PomodoroInfo? get pomodoro; String get status; List<MyTask> get subTasks; DateTime? get due; DateTime? get started; DateTime? get completed; DateTime? get updated; bool get deleted; List<ReviewFlag> get reviewFlags;// ★ 追加
 String? get goal; List<String> get tags;
/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyTaskCopyWith<MyTask> get copyWith => _$MyTaskCopyWithImpl<MyTask>(this as MyTask, _$identity);

  /// Serializes this MyTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.tasklistId, tasklistId) || other.tasklistId == tasklistId)&&(identical(other.note, note) || other.note == note)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.position, position) || other.position == position)&&(identical(other.pomodoro, pomodoro) || other.pomodoro == pomodoro)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.subTasks, subTasks)&&(identical(other.due, due) || other.due == due)&&(identical(other.started, started) || other.started == started)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&const DeepCollectionEquality().equals(other.reviewFlags, reviewFlags)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,tasklistId,note,parent,position,pomodoro,status,const DeepCollectionEquality().hash(subTasks),due,started,completed,updated,deleted,const DeepCollectionEquality().hash(reviewFlags),goal,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'MyTask(id: $id, title: $title, tasklistId: $tasklistId, note: $note, parent: $parent, position: $position, pomodoro: $pomodoro, status: $status, subTasks: $subTasks, due: $due, started: $started, completed: $completed, updated: $updated, deleted: $deleted, reviewFlags: $reviewFlags, goal: $goal, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $MyTaskCopyWith<$Res>  {
  factory $MyTaskCopyWith(MyTask value, $Res Function(MyTask) _then) = _$MyTaskCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? tasklistId, String? note, String? parent, String? position, PomodoroInfo? pomodoro, String status, List<MyTask> subTasks, DateTime? due, DateTime? started, DateTime? completed, DateTime? updated, bool deleted, List<ReviewFlag> reviewFlags, String? goal, List<String> tags
});


$PomodoroInfoCopyWith<$Res>? get pomodoro;

}
/// @nodoc
class _$MyTaskCopyWithImpl<$Res>
    implements $MyTaskCopyWith<$Res> {
  _$MyTaskCopyWithImpl(this._self, this._then);

  final MyTask _self;
  final $Res Function(MyTask) _then;

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? tasklistId = freezed,Object? note = freezed,Object? parent = freezed,Object? position = freezed,Object? pomodoro = freezed,Object? status = null,Object? subTasks = null,Object? due = freezed,Object? started = freezed,Object? completed = freezed,Object? updated = freezed,Object? deleted = null,Object? reviewFlags = null,Object? goal = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tasklistId: freezed == tasklistId ? _self.tasklistId : tasklistId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,pomodoro: freezed == pomodoro ? _self.pomodoro : pomodoro // ignore: cast_nullable_to_non_nullable
as PomodoroInfo?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subTasks: null == subTasks ? _self.subTasks : subTasks // ignore: cast_nullable_to_non_nullable
as List<MyTask>,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime?,started: freezed == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as DateTime?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,reviewFlags: null == reviewFlags ? _self.reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<ReviewFlag>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PomodoroInfoCopyWith<$Res>? get pomodoro {
    if (_self.pomodoro == null) {
    return null;
  }

  return $PomodoroInfoCopyWith<$Res>(_self.pomodoro!, (value) {
    return _then(_self.copyWith(pomodoro: value));
  });
}
}


/// Adds pattern-matching-related methods to [MyTask].
extension MyTaskPatterns on MyTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyTask value)  $default,){
final _that = this;
switch (_that) {
case _MyTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyTask value)?  $default,){
final _that = this;
switch (_that) {
case _MyTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? tasklistId,  String? note,  String? parent,  String? position,  PomodoroInfo? pomodoro,  String status,  List<MyTask> subTasks,  DateTime? due,  DateTime? started,  DateTime? completed,  DateTime? updated,  bool deleted,  List<ReviewFlag> reviewFlags,  String? goal,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyTask() when $default != null:
return $default(_that.id,_that.title,_that.tasklistId,_that.note,_that.parent,_that.position,_that.pomodoro,_that.status,_that.subTasks,_that.due,_that.started,_that.completed,_that.updated,_that.deleted,_that.reviewFlags,_that.goal,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? tasklistId,  String? note,  String? parent,  String? position,  PomodoroInfo? pomodoro,  String status,  List<MyTask> subTasks,  DateTime? due,  DateTime? started,  DateTime? completed,  DateTime? updated,  bool deleted,  List<ReviewFlag> reviewFlags,  String? goal,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _MyTask():
return $default(_that.id,_that.title,_that.tasklistId,_that.note,_that.parent,_that.position,_that.pomodoro,_that.status,_that.subTasks,_that.due,_that.started,_that.completed,_that.updated,_that.deleted,_that.reviewFlags,_that.goal,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? tasklistId,  String? note,  String? parent,  String? position,  PomodoroInfo? pomodoro,  String status,  List<MyTask> subTasks,  DateTime? due,  DateTime? started,  DateTime? completed,  DateTime? updated,  bool deleted,  List<ReviewFlag> reviewFlags,  String? goal,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _MyTask() when $default != null:
return $default(_that.id,_that.title,_that.tasklistId,_that.note,_that.parent,_that.position,_that.pomodoro,_that.status,_that.subTasks,_that.due,_that.started,_that.completed,_that.updated,_that.deleted,_that.reviewFlags,_that.goal,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyTask implements MyTask {
  const _MyTask({required this.id, required this.title, this.tasklistId, this.note, this.parent, this.position, this.pomodoro, this.status = "needsAction", final  List<MyTask> subTasks = const <MyTask>[], this.due, this.started, this.completed, this.updated, this.deleted = false, final  List<ReviewFlag> reviewFlags = const <ReviewFlag>[], this.goal, final  List<String> tags = const <String>[]}): _subTasks = subTasks,_reviewFlags = reviewFlags,_tags = tags;
  factory _MyTask.fromJson(Map<String, dynamic> json) => _$MyTaskFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? tasklistId;
@override final  String? note;
@override final  String? parent;
@override final  String? position;
@override final  PomodoroInfo? pomodoro;
@override@JsonKey() final  String status;
 final  List<MyTask> _subTasks;
@override@JsonKey() List<MyTask> get subTasks {
  if (_subTasks is EqualUnmodifiableListView) return _subTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subTasks);
}

@override final  DateTime? due;
@override final  DateTime? started;
@override final  DateTime? completed;
@override final  DateTime? updated;
@override@JsonKey() final  bool deleted;
 final  List<ReviewFlag> _reviewFlags;
@override@JsonKey() List<ReviewFlag> get reviewFlags {
  if (_reviewFlags is EqualUnmodifiableListView) return _reviewFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviewFlags);
}

// ★ 追加
@override final  String? goal;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyTaskCopyWith<_MyTask> get copyWith => __$MyTaskCopyWithImpl<_MyTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.tasklistId, tasklistId) || other.tasklistId == tasklistId)&&(identical(other.note, note) || other.note == note)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.position, position) || other.position == position)&&(identical(other.pomodoro, pomodoro) || other.pomodoro == pomodoro)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._subTasks, _subTasks)&&(identical(other.due, due) || other.due == due)&&(identical(other.started, started) || other.started == started)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&const DeepCollectionEquality().equals(other._reviewFlags, _reviewFlags)&&(identical(other.goal, goal) || other.goal == goal)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,tasklistId,note,parent,position,pomodoro,status,const DeepCollectionEquality().hash(_subTasks),due,started,completed,updated,deleted,const DeepCollectionEquality().hash(_reviewFlags),goal,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'MyTask(id: $id, title: $title, tasklistId: $tasklistId, note: $note, parent: $parent, position: $position, pomodoro: $pomodoro, status: $status, subTasks: $subTasks, due: $due, started: $started, completed: $completed, updated: $updated, deleted: $deleted, reviewFlags: $reviewFlags, goal: $goal, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$MyTaskCopyWith<$Res> implements $MyTaskCopyWith<$Res> {
  factory _$MyTaskCopyWith(_MyTask value, $Res Function(_MyTask) _then) = __$MyTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? tasklistId, String? note, String? parent, String? position, PomodoroInfo? pomodoro, String status, List<MyTask> subTasks, DateTime? due, DateTime? started, DateTime? completed, DateTime? updated, bool deleted, List<ReviewFlag> reviewFlags, String? goal, List<String> tags
});


@override $PomodoroInfoCopyWith<$Res>? get pomodoro;

}
/// @nodoc
class __$MyTaskCopyWithImpl<$Res>
    implements _$MyTaskCopyWith<$Res> {
  __$MyTaskCopyWithImpl(this._self, this._then);

  final _MyTask _self;
  final $Res Function(_MyTask) _then;

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? tasklistId = freezed,Object? note = freezed,Object? parent = freezed,Object? position = freezed,Object? pomodoro = freezed,Object? status = null,Object? subTasks = null,Object? due = freezed,Object? started = freezed,Object? completed = freezed,Object? updated = freezed,Object? deleted = null,Object? reviewFlags = null,Object? goal = freezed,Object? tags = null,}) {
  return _then(_MyTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,tasklistId: freezed == tasklistId ? _self.tasklistId : tasklistId // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as String?,pomodoro: freezed == pomodoro ? _self.pomodoro : pomodoro // ignore: cast_nullable_to_non_nullable
as PomodoroInfo?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,subTasks: null == subTasks ? _self._subTasks : subTasks // ignore: cast_nullable_to_non_nullable
as List<MyTask>,due: freezed == due ? _self.due : due // ignore: cast_nullable_to_non_nullable
as DateTime?,started: freezed == started ? _self.started : started // ignore: cast_nullable_to_non_nullable
as DateTime?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as DateTime?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as DateTime?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,reviewFlags: null == reviewFlags ? _self._reviewFlags : reviewFlags // ignore: cast_nullable_to_non_nullable
as List<ReviewFlag>,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of MyTask
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PomodoroInfoCopyWith<$Res>? get pomodoro {
    if (_self.pomodoro == null) {
    return null;
  }

  return $PomodoroInfoCopyWith<$Res>(_self.pomodoro!, (value) {
    return _then(_self.copyWith(pomodoro: value));
  });
}
}

// dart format on
