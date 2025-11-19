import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';

class TaskFactory {
  MyTask fromApiData(Map<String, dynamic> data, {String? taskListId}) {
    final notes = data['notes'] as String? ?? '';
    final pomodoro = _parsePomodoroInfo(notes);
    final started = _parseStarted(notes);

    return MyTask(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      note: _extractNoteBody(notes),
      tasklistId: taskListId,
      parent: data['parent'],
      position: data['position'],
      pomodoro: pomodoro,
      status: data['status'] ?? 'needsAction',
      due: _parseDateTime(data['due']),
      started: started,
      completed: _parseDateTime(data['completed']),
      updated: _parseDateTime(data['updated']),
      deleted: data['deleted'] ?? false,
    );
  }

  MyTask createNewTask({
    required String title,
    String? rawNote,
    required String tasklistId,
  }) {
    final note =
        (rawNote == '-' || rawNote?.trim().isEmpty == true) ? null : rawNote;

    final data = {
      'id': '',
      'title': title,
      'notes': note,
      'tasklistId': tasklistId,
      'status': 'needsAction',
    };
    return fromApiData(data, taskListId: tasklistId);
  }

  PomodoroInfo _parsePomodoroInfo(String? note) {
    final tomatoMatch = RegExp(r'🍅x(\d+)').firstMatch(note ?? '');
    final checkMatch = RegExp(r'✅x([\d\.]+)').firstMatch(note ?? '');

    final planned = tomatoMatch != null ? int.parse(tomatoMatch.group(1)!) : 0;
    final actual =
        checkMatch != null ? double.tryParse(checkMatch.group(1)!) : null;

    return PomodoroInfo(planned: planned, actual: actual);
  }

  String? _extractNoteBody(String? note) {
    if (note == null) return null;
    var result = note;
    result = result.replaceAll(RegExp(r'🍅x\d+'), '');
    result = result.replaceAll(RegExp(r'✅x\d+'), '');
    result = result.replaceAll(RegExp(r'started=[^\s]+'), '');
    return result.trim().isEmpty ? null : result.trim();
  }

  DateTime? _parseStarted(String? note) {
    final match = RegExp(r'started=([0-9T:\-\.\+Z]+)').firstMatch(note ?? '');
    if (match != null) {
      return _parseDateTime(match.group(1));
    }
    return null;
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
