import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/providers/task_provider.dart';

class PomodoroSummaryApplier {
  PomodoroSummaryApplier();

  Future<void> apply(Ref ref, Map<String, double> summary) async {
    final notifier = ref.read(tasksProvider.notifier);
    for (final entry in summary.entries) {
      final task = notifier.findById(entry.key);
      if (task == null) continue;
      final updated = task.copyWith(
        pomodoro: task.pomodoro?.copyWith(
              actual: (task.pomodoro?.actual ?? 0.0) + entry.value,
            ) ??
            PomodoroInfo(planned: 0, actual: entry.value.toDouble()),
      );

      await notifier.updateTask(updated);
      ref.read(selectedTimerTaskProvider.notifier).state = updated;
    }
  }
}
