import 'my_task.dart';

class MyTaskNotesEncoder {
  static String? encode(MyTask task) {
    final lines = <String>[];

    final planned = task.pomodoro?.planned;
    if (planned != null) {
      lines.add('🍅planned=$planned'); // ★ 1行目固定
    }

    if (task.goal != null && task.goal!.isNotEmpty) {
      lines.add('goal=${task.goal}');
    }

    if (task.tags.isNotEmpty) {
      lines.add('tags=${task.tags.join(',')}');
    }

    final actual = task.pomodoro?.actual;
    if (actual != null) {
      lines.add('actual=$actual');
    }

    if (task.started != null) {
      lines.add('started=${task.started!.toIso8601String()}');
    }

    if (task.reviewFlags.isNotEmpty) {
      lines.add('reviewFlags=${task.reviewFlags.map((f) => f.name).join(',')}');
    }

    if (lines.isEmpty) return null;
    return lines.join('\n');
  }
}
