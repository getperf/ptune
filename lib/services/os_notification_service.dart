import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NotificationPermission {
  final bool supported;
  final bool allowed;
  final bool exactRequired;
  final bool exactAllowed;
  const NotificationPermission({
    required this.supported,
    this.allowed = false,
    this.exactRequired = false,
    this.exactAllowed = false,
  });
}

class OsNotificationService {
  static const _channel = MethodChannel('ptune/notification_permissions');
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  Future<NotificationPermission> status() async {
    if (!supported) return const NotificationPermission(supported: false);
    final values = await _channel.invokeMapMethod<String, dynamic>('status');
    return NotificationPermission(
      supported: true,
      allowed: values?['allowed'] == true,
      exactRequired: values?['exactRequired'] == true,
      exactAllowed: values?['exactAllowed'] == true,
    );
  }

  Future<void> request() => _channel.invokeMethod<void>('request');
  Future<void> openSettings() => _channel.invokeMethod<void>('settings');
  Future<void> openExactSettings() =>
      _channel.invokeMethod<void>('exactSettings');
}
