import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/auth_controller_provider.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/states/remaining_time_state.dart';
import 'package:ptune/utils/logger.dart';

class AppStartupInitializer {
  static Future<void> initialize(ProviderContainer container) async {
    const initialType = SessionType.work;
    final scheduler = container.read(pomodoroSchedulerProvider);
    // final scheduler = PomodoroScheduler();
    final duration = scheduler.getDuration(initialType);

    container.read(sessionTypeProvider.notifier).state = initialType;
    container.read(remainingTimeProvider.notifier).start(duration);

    // 🔽 認証状態の初期化を追加
    await container.read(authControllerProvider).restore();

    logger.i(
      "[AppStartupInitializer] sessionType = $initialType, duration = $duration",
    );
  }
}
