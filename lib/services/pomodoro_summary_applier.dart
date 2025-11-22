import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/providers/task_provider.dart';

/// PomodoroSummaryApplier
/// - partial summary から必要なタスクのみ更新し返す
/// - updateTask の commit 有無は呼び出し元が制御
class PomodoroSummaryApplier {
  PomodoroSummaryApplier();

  /// summary: { taskId: actual増分 }
  /// 戻り値: 更新後の MyTask のリスト（部分更新対象のみ）
  Future<List<MyTask>> apply(
    Ref ref,
    Map<String, double> summary,
  ) async {
    final notifier = ref.read(tasksProvider.notifier);
    final updatedTasks = <MyTask>[];

    for (final entry in summary.entries) {
      final taskId = entry.key;
      final delta = entry.value;

      final task = notifier.findById(taskId);
      if (task == null) continue;

      final newPomodoro = task.pomodoro?.copyWith(
            actual: (task.pomodoro?.actual ?? 0.0) + delta,
          ) ??
          PomodoroInfo(planned: 0, actual: delta);

      final updated = task.copyWith(pomodoro: newPomodoro);

      // updateTask は commit=false で呼ぶ（保存は呼び出し元で制御）
      await notifier.updateTask(updated, commit: false);

      updatedTasks.add(updated);
    }

    return updatedTasks;
  }
}
