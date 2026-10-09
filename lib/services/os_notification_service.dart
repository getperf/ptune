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

  Future<void> send(String title, String body) async {
    if (supported) {
      await _channel.invokeMethod<void>('send', {'title': title, 'body': body});
    }
  }

  Future<void> schedule({
    required String sessionId,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    if (supported) {
      await _channel.invokeMethod<void>('schedule', {
        'sessionId': sessionId,
        'at': at.millisecondsSinceEpoch,
        'title': title,
        'body': body,
      });
    }
  }

  Future<void> cancel() async {
    if (supported) await _channel.invokeMethod<void>('cancel');
  }

  Future<void> complete({
    required String sessionId,
    required String title,
    required String body,
  }) async {
    if (supported) {
      await _channel.invokeMethod<void>('complete', {
        'sessionId': sessionId,
        'title': title,
        'body': body,
      });
    }
  }
}
