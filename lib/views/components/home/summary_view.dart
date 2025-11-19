import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/task_stats.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/states/remaining_time_state.dart';

class SummaryView extends ConsumerWidget {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(remainingTimeProvider);
    final scheduler = ref.read(pomodoroSchedulerProvider);
    final asyncTasks = ref.watch(tasksProvider);
    final tasks = asyncTasks.value ?? [];

    final stats = TaskStats(tasks, scheduler.getDuration(SessionType.work));
    final remainingStr = timerState.formattedTime;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "🍅 x ${stats.totalPlanned}",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                stats.totalPlannedDuration,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "✅ x ${stats.formattedTotalActual}",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                stats.totalActualDuration,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text("状態: タスクなし 開始待ち / 残り: $remainingStr"),
        ],
      ),
    );
  }
}
