import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/haptic_service_provider.dart';
import 'package:ptune/states/haptic_setting_provider.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/states/haptic_setting.dart';

abstract class TimerNotificationService {
  Future<void> onSessionCompleted(SessionType type);
}

class TimerNotificationServiceImpl implements TimerNotificationService {
  final Ref ref;

  TimerNotificationServiceImpl(this.ref);

  @override
  Future<void> onSessionCompleted(SessionType type) async {
    // WORK終了時のみ通知
    if (type != SessionType.work) return;

    final setting = ref.read(hapticSettingProvider);
    if (!setting.isEnabled) return;

    await ref.read(hapticServiceProvider).test(setting);
  }
}
