import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/timer_controller.dart';
import 'pomodoro_scheduler_provider.dart';
import '../utils/logger.dart';

/// TimerController Provider
/// - アプリ内で単一インスタンスを維持
/// - dispose 時に TimerController.dispose() を確実に呼ぶ
final timerControllerProvider = Provider<TimerController>((ref) {
  logger.i('[Provider] timerControllerProvider created');

  final scheduler = ref.read(pomodoroSchedulerProvider);
  final controller = TimerController(ref, scheduler);

  ref.onDispose(() {
    logger.i('[Provider] timerControllerProvider disposed');
    controller.dispose();
  });

  return controller;
});
