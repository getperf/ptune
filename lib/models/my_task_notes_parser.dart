import 'review_flag.dart';
import 'my_task_notes_meta.dart';

class MyTaskNotesParser {
  static MyTaskNotesMeta parse(String? notes) {
    if (notes == null || notes.trim().isEmpty) {
      return const MyTaskNotesMeta();
    }

    int? planned;
    double? actual;
    String? goal;
    List<String> tags = [];
    DateTime? started;
    List<ReviewFlag> reviewFlags = [];

    final lines = notes.split('\n');

    for (final raw in lines) {
      final line = raw.trim();

      if (line.startsWith('🍅planned=')) {
        final v = line.substring('🍅planned='.length);
        planned = int.tryParse(v);
      } else if (line.startsWith('goal=')) {
        goal = line.substring('goal='.length);
      } else if (line.startsWith('tags=')) {
        final rawTags = line.substring('tags='.length);
        tags = rawTags
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (line.startsWith('actual=')) {
        actual = double.tryParse(line.substring('actual='.length));
      } else if (line.startsWith('started=')) {
        started = DateTime.tryParse(line.substring('started='.length));
      } else if (line.startsWith('reviewFlags=')) {
        final rawFlags = line.substring('reviewFlags='.length);

        reviewFlags = rawFlags
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .map((name) {
              try {
                return ReviewFlag.values.firstWhere((f) => f.name == name);
              } catch (_) {
                return null;
              }
            })
            .whereType<ReviewFlag>()
            .toList();
      }
    }

    return MyTaskNotesMeta(
      planned: planned,
      actual: actual,
      goal: goal,
      tags: tags,
      started: started,
      reviewFlags: reviewFlags,
    );
  }
}
