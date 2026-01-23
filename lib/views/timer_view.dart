import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/controllers/task_review_commit_controller.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/timer_completed_task_provider.dart';
import 'package:ptune/providers/timer_controller_provider.dart';
import 'package:ptune/providers/timer_event_provider.dart';
import 'package:ptune/states/over_limit_state.dart';
import 'package:ptune/states/remaining_time_state.dart';
import 'package:ptune/states/timer_phase_state.dart';
import 'package:ptune/views/components/timer/phase_button.dart';
import 'package:ptune/views/components/timer/task_header.dart';
import 'package:ptune/views/components/timer/timer_display.dart';

class TimerView extends ConsumerWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runningTask = ref.watch(selectedTimerTaskProvider);
    final completedTask = ref.watch(completedTimerTaskProvider);
    final displayTask = runningTask ?? completedTask;

    final timerState = ref.watch(remainingTimeProvider);
    final phase = ref.watch(timerPhaseProvider);
    final sessionType = ref.watch(sessionTypeProvider);
    final taskParentId = displayTask?.parent;
    final parentTask = taskParentId != null
        ? ref.read(tasksProvider.notifier).findById(taskParentId)
        : null;

    final controller = ref.read(timerControllerProvider);

    ref.listen<bool>(overLimitProvider, (previous, next) {
      if (next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("止め忘れを検知したため停止しました"),
            duration: const Duration(days: 1), // ユーザが閉じるまで残る
            action: SnackBarAction(
              label: "閉じる",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ref.read(overLimitProvider.notifier).state = false;
              },
            ),
          ),
        );
      }
    });
    ref.listen<String?>(timerEventProvider, (previous, next) {
      if (next == "almost_finished") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("⏰ まもなく終了します"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final commitController = TaskReviewCommitController(ref);
            await commitController.onExitToHome();

            if (context.mounted) {
              context.pop();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TaskHeader(
              task: displayTask,
              parentTask: parentTask,
              onToggle: displayTask == null
                  ? null
                  : () async => await controller.toggleTask(displayTask.id),
              onGoHome: () => context.go('/home'),
            ),
            const SizedBox(height: 16),
            TimerDisplay(
              task: displayTask,
              phase: phase,
              timerState: timerState,
              sessionType: sessionType,
            ),
            const SizedBox(height: 20),
            PhaseButton(
              phase: phase,
              onStart: controller.start,
              onPause: controller.pause,
              onResume: controller.resume,
              onReset: controller.reset,
            ),
          ],
        ),
      ),
    );
  }
}
