import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/timer_notification_service.dart';
import 'package:ptune/models/notification_settings.dart';
import 'package:ptune/states/notification_settings_provider.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/services/os_notification_service.dart';

final timerNotificationServiceProvider = Provider<TimerNotificationService>((
  ref,
) {
  final service = TimerNotificationServiceImpl(ref);
  NotificationSettings? previousSettings;
  ref.listen(notificationSettingsProvider, (_, next) {
    final value = next.asData?.value;
    if (value == null) return;
    final previous = previousSettings;
    previousSettings = value;
    if (previous != null &&
        (previous.startEnabled != value.startEnabled ||
            previous.endEnabled != value.endEnabled)) {
      service.refresh();
    }
  }, fireImmediately: true);
  NotificationPermission? previousPermission;
  ref.listen(notificationPermissionProvider, (_, next) {
    final value = next.asData?.value;
    if (value == null) return;
    final previous = previousPermission;
    previousPermission = value;
    if (previous != null &&
        (previous.allowed != value.allowed ||
            previous.exactAllowed != value.exactAllowed)) {
      service.refresh();
    }
  }, fireImmediately: true);
  ref.listen(autoModeProvider, (previous, next) {
    if (previous != next) service.refresh();
  });
  ref.onDispose(service.dispose);
  return service;
});
