// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MyTask _$MyTaskFromJson(Map<String, dynamic> json) {
  return _MyTask.fromJson(json);
}

/// @nodoc
mixin _$MyTask {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get tasklistId => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  String? get parent => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  PomodoroInfo? get pomodoro => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<MyTask> get subTasks => throw _privateConstructorUsedError;
  DateTime? get due => throw _privateConstructorUsedError;
  DateTime? get started => throw _privateConstructorUsedError;
  DateTime? get completed => throw _privateConstructorUsedError;
  DateTime? get updated => throw _privateConstructorUsedError;
  bool get deleted => throw _privateConstructorUsedError;

  /// Serializes this MyTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MyTaskCopyWith<MyTask> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyTaskCopyWith<$Res> {
  factory $MyTaskCopyWith(MyTask value, $Res Function(MyTask) then) =
      _$MyTaskCopyWithImpl<$Res, MyTask>;
  @useResult
  $Res call({
    String id,
    String title,
    String? tasklistId,
    String? note,
    String? parent,
    String? position,
    PomodoroInfo? pomodoro,
    String status,
    List<MyTask> subTasks,
    DateTime? due,
    DateTime? started,
    DateTime? completed,
    DateTime? updated,
    bool deleted,
  });

  $PomodoroInfoCopyWith<$Res>? get pomodoro;
}

/// @nodoc
class _$MyTaskCopyWithImpl<$Res, $Val extends MyTask>
    implements $MyTaskCopyWith<$Res> {
  _$MyTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tasklistId = freezed,
    Object? note = freezed,
    Object? parent = freezed,
    Object? position = freezed,
    Object? pomodoro = freezed,
    Object? status = null,
    Object? subTasks = null,
    Object? due = freezed,
    Object? started = freezed,
    Object? completed = freezed,
    Object? updated = freezed,
    Object? deleted = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            tasklistId: freezed == tasklistId
                ? _value.tasklistId
                : tasklistId // ignore: cast_nullable_to_non_nullable
                      as String?,
            note: freezed == note
                ? _value.note
                : note // ignore: cast_nullable_to_non_nullable
                      as String?,
            parent: freezed == parent
                ? _value.parent
                : parent // ignore: cast_nullable_to_non_nullable
                      as String?,
            position: freezed == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String?,
            pomodoro: freezed == pomodoro
                ? _value.pomodoro
                : pomodoro // ignore: cast_nullable_to_non_nullable
                      as PomodoroInfo?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            subTasks: null == subTasks
                ? _value.subTasks
                : subTasks // ignore: cast_nullable_to_non_nullable
                      as List<MyTask>,
            due: freezed == due
                ? _value.due
                : due // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            started: freezed == started
                ? _value.started
                : started // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completed: freezed == completed
                ? _value.completed
                : completed // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updated: freezed == updated
                ? _value.updated
                : updated // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            deleted: null == deleted
                ? _value.deleted
                : deleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PomodoroInfoCopyWith<$Res>? get pomodoro {
    if (_value.pomodoro == null) {
      return null;
    }

    return $PomodoroInfoCopyWith<$Res>(_value.pomodoro!, (value) {
      return _then(_value.copyWith(pomodoro: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MyTaskImplCopyWith<$Res> implements $MyTaskCopyWith<$Res> {
  factory _$$MyTaskImplCopyWith(
    _$MyTaskImpl value,
    $Res Function(_$MyTaskImpl) then,
  ) = __$$MyTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? tasklistId,
    String? note,
    String? parent,
    String? position,
    PomodoroInfo? pomodoro,
    String status,
    List<MyTask> subTasks,
    DateTime? due,
    DateTime? started,
    DateTime? completed,
    DateTime? updated,
    bool deleted,
  });

  @override
  $PomodoroInfoCopyWith<$Res>? get pomodoro;
}

/// @nodoc
class __$$MyTaskImplCopyWithImpl<$Res>
    extends _$MyTaskCopyWithImpl<$Res, _$MyTaskImpl>
    implements _$$MyTaskImplCopyWith<$Res> {
  __$$MyTaskImplCopyWithImpl(
    _$MyTaskImpl _value,
    $Res Function(_$MyTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? tasklistId = freezed,
    Object? note = freezed,
    Object? parent = freezed,
    Object? position = freezed,
    Object? pomodoro = freezed,
    Object? status = null,
    Object? subTasks = null,
    Object? due = freezed,
    Object? started = freezed,
    Object? completed = freezed,
    Object? updated = freezed,
    Object? deleted = null,
  }) {
    return _then(
      _$MyTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        tasklistId: freezed == tasklistId
            ? _value.tasklistId
            : tasklistId // ignore: cast_nullable_to_non_nullable
                  as String?,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
        parent: freezed == parent
            ? _value.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as String?,
        position: freezed == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String?,
        pomodoro: freezed == pomodoro
            ? _value.pomodoro
            : pomodoro // ignore: cast_nullable_to_non_nullable
                  as PomodoroInfo?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        subTasks: null == subTasks
            ? _value._subTasks
            : subTasks // ignore: cast_nullable_to_non_nullable
                  as List<MyTask>,
        due: freezed == due
            ? _value.due
            : due // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        started: freezed == started
            ? _value.started
            : started // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completed: freezed == completed
            ? _value.completed
            : completed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updated: freezed == updated
            ? _value.updated
            : updated // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deleted: null == deleted
            ? _value.deleted
            : deleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MyTaskImpl implements _MyTask {
  const _$MyTaskImpl({
    required this.id,
    required this.title,
    this.tasklistId,
    this.note,
    this.parent,
    this.position,
    this.pomodoro,
    this.status = "needsAction",
    final List<MyTask> subTasks = const [],
    this.due,
    this.started,
    this.completed,
    this.updated,
    this.deleted = false,
  }) : _subTasks = subTasks;

  factory _$MyTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$MyTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? tasklistId;
  @override
  final String? note;
  @override
  final String? parent;
  @override
  final String? position;
  @override
  final PomodoroInfo? pomodoro;
  @override
  @JsonKey()
  final String status;
  final List<MyTask> _subTasks;
  @override
  @JsonKey()
  List<MyTask> get subTasks {
    if (_subTasks is EqualUnmodifiableListView) return _subTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subTasks);
  }

  @override
  final DateTime? due;
  @override
  final DateTime? started;
  @override
  final DateTime? completed;
  @override
  final DateTime? updated;
  @override
  @JsonKey()
  final bool deleted;

  @override
  String toString() {
    return 'MyTask(id: $id, title: $title, tasklistId: $tasklistId, note: $note, parent: $parent, position: $position, pomodoro: $pomodoro, status: $status, subTasks: $subTasks, due: $due, started: $started, completed: $completed, updated: $updated, deleted: $deleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.tasklistId, tasklistId) ||
                other.tasklistId == tasklistId) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.pomodoro, pomodoro) ||
                other.pomodoro == pomodoro) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._subTasks, _subTasks) &&
            (identical(other.due, due) || other.due == due) &&
            (identical(other.started, started) || other.started == started) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.deleted, deleted) || other.deleted == deleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    tasklistId,
    note,
    parent,
    position,
    pomodoro,
    status,
    const DeepCollectionEquality().hash(_subTasks),
    due,
    started,
    completed,
    updated,
    deleted,
  );

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MyTaskImplCopyWith<_$MyTaskImpl> get copyWith =>
      __$$MyTaskImplCopyWithImpl<_$MyTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MyTaskImplToJson(this);
  }
}

abstract class _MyTask implements MyTask {
  const factory _MyTask({
    required final String id,
    required final String title,
    final String? tasklistId,
    final String? note,
    final String? parent,
    final String? position,
    final PomodoroInfo? pomodoro,
    final String status,
    final List<MyTask> subTasks,
    final DateTime? due,
    final DateTime? started,
    final DateTime? completed,
    final DateTime? updated,
    final bool deleted,
  }) = _$MyTaskImpl;

  factory _MyTask.fromJson(Map<String, dynamic> json) = _$MyTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String? get tasklistId;
  @override
  String? get note;
  @override
  String? get parent;
  @override
  String? get position;
  @override
  PomodoroInfo? get pomodoro;
  @override
  String get status;
  @override
  List<MyTask> get subTasks;
  @override
  DateTime? get due;
  @override
  DateTime? get started;
  @override
  DateTime? get completed;
  @override
  DateTime? get updated;
  @override
  bool get deleted;

  /// Create a copy of MyTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MyTaskImplCopyWith<_$MyTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
