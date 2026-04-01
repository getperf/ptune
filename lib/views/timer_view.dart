import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/controllers/task_review_commit_controller.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';
import 'package:ptune/providers/timer_completed_task_provider.dart';
import 'package:ptune/providers/timer_controller_provider.dart';
import 'package:ptune/providers/timer_event_provider.dart';
import 'package:ptune/states/over_limit_state.dart';
import 'package:ptune/states/remaining_time_state.dart';
import 'package:ptune/states/timer_phase_state.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/views/components/timer/phase_button.dart';
import 'package:ptune/views/components/timer/task_header.dart';
import 'package:ptune/views/components/timer/timer_display.dart';

class TimerView extends ConsumerWidget {
  const TimerView({super.key});

  Future<void> _exitToHome(BuildContext context, WidgetRef ref) async {
    final commitController = TaskReviewCommitController(ref);
    await commitController.onExitToHome();

    if (context.mounted) {
      context.go('/home');
    }
  }

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
    ref.listen<MyTask?>(completedTimerTaskProvider, (previous, next) {
      logger.i(
        '[TimerView] completedTimerTask changed: '
        '${previous?.id ?? 'null'}:${previous?.status ?? '-'} -> '
        '${next?.id ?? 'null'}:${next?.status ?? '-'}',
      );
      if (next != null) {
        ref.read(taskReviewProvider(next.id).notifier).initFromTask(next);
      }
    });
    ref.listen<MyTask?>(selectedTimerTaskProvider, (previous, next) {
      logger.i(
        '[TimerView] selectedTimerTask changed: '
        '${previous?.id ?? 'null'}:${previous?.status ?? '-'} -> '
        '${next?.id ?? 'null'}:${next?.status ?? '-'}',
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _exitToHome(context, ref),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// -------- Header（スクロール対象） --------
              Flexible(
                flex: 0,
                child: SingleChildScrollView(
                  child: TaskHeader(
                    task: displayTask,
                    parentTask: parentTask,
                    onToggle: displayTask == null
                        ? null
                        : () async =>
                              await controller.toggleTask(displayTask.id),
                    onGoHome: () => _exitToHome(context, ref),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// -------- Timer（中央固定） --------
              Expanded(
                child: Center(
                  child: TimerDisplay(
                    task: displayTask,
                    phase: phase,
                    timerState: timerState,
                    sessionType: sessionType,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// -------- PhaseButton（下固定） --------
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
      ),
    );
  }
}
