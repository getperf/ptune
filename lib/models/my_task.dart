// lib/models/my_task.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'pomodoro_info.dart';

part 'my_task.freezed.dart';
part 'my_task.g.dart';

@freezed
class MyTask with _$MyTask {
  const factory MyTask({
    required String id,
    required String title,
    String? tasklistId,
    String? note,
    String? parent,
    String? position,
    PomodoroInfo? pomodoro,
    @Default("needsAction") String status,
    @Default([]) List<MyTask> subTasks,
    DateTime? due,
    DateTime? started,
    DateTime? completed,
    DateTime? updated,
    @Default(false) bool deleted,
  }) = _MyTask;

  factory MyTask.fromJson(Map<String, dynamic> json) => _$MyTaskFromJson(json);
}
