import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/my_timer_state.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/states/blink_notifier.dart';

class TimerDisplay extends ConsumerWidget {
  final MyTask? task;
  final TimerPhase phase;
  final MyTimerState timerState;
  final SessionType sessionType;

  const TimerDisplay({
    super.key,
    required this.task,
    required this.phase,
    required this.timerState,
    required this.sessionType,
  });

  Color getSessionColor(SessionType type) {
    switch (type) {
      case SessionType.work:
        return Colors.red;
      case SessionType.shortBreak:
        return Colors.blue;
      case SessionType.longBreak:
        return Colors.lightGreen;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = timerState.progress;
    final formattedTime = timerState.formattedTime;
    final pomodoroInfo = task?.pomodoro?.toDisplayString() ?? "🍅 情報なし";

    final isBlinking = ref.watch(blinkStateProvider); // ← 点滅状態を取得

    return Column(
      children: [
        Text("📘 現在: ${phase.label}"),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final baseSize = min(constraints.maxWidth, constraints.maxHeight);
            final width = baseSize.clamp(200.0, 400.0) - 32;
            final color = getSessionColor(sessionType);

            return Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: isBlinking ? 0.3 : 1.0, // ← 点滅効果
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: width,
                      height: width,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        sessionType.label,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          pomodoroInfo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
