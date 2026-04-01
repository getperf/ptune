import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/my_task_notes_parser.dart';

class TaskFactory {
  // =========================
  // API → Domain
  // =========================
  MyTask fromApiData(Map<String, dynamic> data, {String? taskListId}) {
    final notes = data['notes'] as String?;

    final meta = MyTaskNotesParser.parse(notes);

    return MyTask(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      note: notes,
      tasklistId: taskListId,
      parent: data['parent'],
      position: data['position'],
      pomodoro: PomodoroInfo(planned: meta.planned ?? 0, actual: meta.actual),
      status: data['status'] ?? 'needsAction',
      due: _parseDateTime(data['due']),
      started: meta.started,
      completed: _parseDateTime(data['completed']),
      updated: _parseDateTime(data['updated']),
      deleted: data['deleted'] ?? false,
      reviewFlags: meta.reviewFlags,
      goal: meta.goal,
      tags: meta.tags,
    );
  }

  // =========================
  // Domain → API DTO
  // （notesは含めない）
  // =========================
  Map<String, dynamic> toApiData(MyTask task, {bool forUpdate = false}) {
    final body = <String, dynamic>{
      'title': task.title,
      'status': task.status,
      'kind': 'tasks#task',
    };

    if (!forUpdate && task.id.isNotEmpty) {
      body['id'] = task.id;
    }

    if (task.parent != null) {
      body['parent'] = task.parent;
    }

    if (task.due != null) {
      body['due'] = task.due!.toIso8601String();
    }

    if (task.completed != null) {
      body['completed'] = task.completed!.toIso8601String();
    }

    return body;
  }

  // =========================
  // 新規作成
  // =========================
  MyTask createNewTask({required String title, required String tasklistId}) {
    return MyTask(
      id: '',
      title: title,
      tasklistId: tasklistId,
      status: 'needsAction',
      pomodoro: const PomodoroInfo(planned: 0),
    );
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
