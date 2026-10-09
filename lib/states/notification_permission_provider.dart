import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/services/os_notification_service.dart';

final osNotificationServiceProvider = Provider(
  (ref) => OsNotificationService(),
);
final notificationPermissionProvider = FutureProvider<NotificationPermission>(
  (ref) => ref.read(osNotificationServiceProvider).status(),
);
