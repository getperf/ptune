import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/utils/env_config.dart';
import 'package:ptune/utils/logger.dart'; // ← 追加

final pomodoroSchedulerProvider = Provider<PomodoroScheduler>((ref) {
  final isDemo = EnvConfig.isDemo;
  final scheduler = PomodoroScheduler(isDemo: isDemo);
  logger.i(
    "[Provider] PomodoroScheduler initialized (isDemo=${scheduler.isDemo})",
  );
  return scheduler;
});

final sessionTypeProvider = StateProvider<SessionType>(
  (ref) => SessionType.work,
);
