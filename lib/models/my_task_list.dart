import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_task_list.freezed.dart';
part 'my_task_list.g.dart';

@freezed
class MyTaskList with _$MyTaskList {
  const factory MyTaskList({
    required String id,
    required String title,
    String? description,
  }) = _MyTaskList;

  factory MyTaskList.fromJson(Map<String, dynamic> json) =>
      _$MyTaskListFromJson(json);
}
