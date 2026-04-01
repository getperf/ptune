import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/timer_notification_service.dart';

final timerNotificationServiceProvider = Provider<TimerNotificationService>((
  ref,
) {
  return TimerNotificationServiceImpl(ref);
});
