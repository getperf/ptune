import 'package:ptune/factories/review_flag_notes_encoder.dart';
import 'package:ptune/factories/task_factory.dart';
import 'package:ptune/models/my_task.dart';

extension TaskFactoryExt on TaskFactory {
  Map<String, dynamic> toApiData(MyTask task, {bool forUpdate = false}) {
    final notesParts = <String>[];

    if (task.note != null && task.note!.isNotEmpty) {
      notesParts.add(task.note!);
    }

    if (task.pomodoro != null) {
      final p = task.pomodoro!;
      if (p.planned > 0) notesParts.add('🍅x${p.planned}');
      if (p.actual != null) notesParts.add('✅x${p.actual!.toStringAsFixed(1)}');
    }

    final reviewNote = ReviewFlagNotesEncoder.encode(task.reviewFlags);
    if (reviewNote != null && reviewNote.isNotEmpty) {
      notesParts.add(reviewNote);
    }

    if (task.started != null) {
      notesParts.add('started=${task.started!.toIso8601String()}');
    }

    if (task.completed != null) {
      notesParts.add('completed=${task.completed!.toIso8601String()}');
    }

    final notes = notesParts.join(' ').trim();

    final Map<String, dynamic> body = {
      'title': task.title,
      'notes': notes,
      'status': task.status,
      'kind': 'tasks#task',
    };
    // ✅ IDを必ず含める（更新時に必要）
    if (!forUpdate && task.id.isNotEmpty) {
      body['id'] = task.id;
    }

    if (task.parent != null) {
      body['parent'] = task.parent;
    }

    if (task.due != null) {
      body['due'] = task.due!.toIso8601String();
    }

    return body;
  }
}
