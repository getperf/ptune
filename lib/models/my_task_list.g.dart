// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_task_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MyTaskList _$MyTaskListFromJson(Map<String, dynamic> json) => _MyTaskList(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$MyTaskListToJson(_MyTaskList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };
