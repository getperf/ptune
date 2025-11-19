// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MyTaskImpl _$$MyTaskImplFromJson(Map<String, dynamic> json) => _$MyTaskImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  tasklistId: json['tasklistId'] as String?,
  note: json['note'] as String?,
  parent: json['parent'] as String?,
  position: json['position'] as String?,
  pomodoro: json['pomodoro'] == null
      ? null
      : PomodoroInfo.fromJson(json['pomodoro'] as Map<String, dynamic>),
  status: json['status'] as String? ?? "needsAction",
  subTasks:
      (json['subTasks'] as List<dynamic>?)
          ?.map((e) => MyTask.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  due: json['due'] == null ? null : DateTime.parse(json['due'] as String),
  started: json['started'] == null
      ? null
      : DateTime.parse(json['started'] as String),
  completed: json['completed'] == null
      ? null
      : DateTime.parse(json['completed'] as String),
  updated: json['updated'] == null
      ? null
      : DateTime.parse(json['updated'] as String),
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$$MyTaskImplToJson(_$MyTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'tasklistId': instance.tasklistId,
      'note': instance.note,
      'parent': instance.parent,
      'position': instance.position,
      'pomodoro': instance.pomodoro,
      'status': instance.status,
      'subTasks': instance.subTasks,
      'due': instance.due?.toIso8601String(),
      'started': instance.started?.toIso8601String(),
      'completed': instance.completed?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
      'deleted': instance.deleted,
    };
