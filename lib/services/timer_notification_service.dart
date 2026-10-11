import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/timer_notification_message.dart';
import 'package:ptune/providers/haptic_service_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/states/haptic_setting_provider.dart';
import 'package:ptune/states/haptic_setting.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/notification_settings_provider.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/services/os_notification_service.dart';

abstract class TimerNotificationService {
  Future<void> onTimerRunning(
    SessionType type,
    DateTime? endTime, {
    bool newSession = false,
    bool automaticStart = false,
  });
  Future<void> cancel();
  void refresh();
  void dispose();
  Future<void> onSessionAlmostEnding(SessionType type);
  Future<void> onSessionCompleted(SessionType type);
}

class TimerNotificationServiceImpl implements TimerNotificationService {
  final Ref ref;
  final OsNotificationService os;
  bool _disposed = false;
  TimerNotificationServiceImpl(this.ref)
    : os = ref.read(osNotificationServiceProvider);
  String? _sessionId;
  DateTime? _endTime;
  SessionType? _type;
  bool _startRequested = false;
  int _revision = 0;
  Future<void> _pending = Future.value();

  Future<void> _enqueue(Future<void> Function() action) {
    _pending = _pending.then((_) async {
      if (_disposed) return;
      try {
        await action();
      } catch (e, st) {
        logger.e(
          '[TimerNotificationService] Notification failed',
          error: e,
          stackTrace: st,
        );
      }
    });
    return _pending;
  }

  TimerNotificationMessage _message({bool start = false}) {
    final task = ref.read(selectedTimerTaskProvider);
    final tasks = ref.read(tasksProvider).asData?.value;
    final parent = tasks?.firstWhereOrNull((t) => t.id == task?.parent)?.title;
    if (start) return TimerNotificationMessage.start(task, parent);
    final scheduler = ref.read(pomodoroSchedulerProvider);
    final next = scheduler.getNextSessionType();
    return TimerNotificationMessage.end(
      task,
      parent,
      nextBreak: next,
      breakSeconds: scheduler.getDuration(next),
      safeMode: ref.read(autoModeProvider).isSafeEnabled,
    );
  }

  @override
  Future<void> onTimerRunning(
    SessionType type,
    DateTime? endTime, {
    bool newSession = false,
    bool automaticStart = false,
  }) {
    if (newSession) {
      _sessionId = DateTime.now().microsecondsSinceEpoch.toString();
      _startRequested = automaticStart;
    }
    _sessionId ??= DateTime.now().microsecondsSinceEpoch.toString();
    _type = type;
    _endTime = endTime;
    final revision = ++_revision;
    final id = _sessionId!;
    final end = _message();
    final start = _message(start: true);
    return _enqueue(() async {
      if (revision != _revision) return;
      final settings = await ref.read(notificationSettingsProvider.future);
      if (revision != _revision) return;
      await os.cancel();
      if (revision != _revision || type != SessionType.work) return;
      final notifyStart = _startRequested;
      _startRequested = false;
      if (notifyStart && settings.startEnabled) {
        await os.send(start.title, start.body);
      }
      if (revision != _revision) return;
      if (settings.endEnabled &&
          endTime != null &&
          endTime.isAfter(DateTime.now())) {
        final warningTime = endTime.subtract(const Duration(seconds: 30));
        if (!warningTime.isAfter(DateTime.now())) {
          await os.complete(sessionId: id, title: end.title, body: end.body);
        } else {
          await os.schedule(
            sessionId: id,
            at: warningTime,
            title: end.title,
            body: end.body,
          );
        }
      }
    });
  }

  @override
  void refresh() {
    if (_endTime != null && _type != null) {
      unawaited(onTimerRunning(_type!, _endTime));
    } else {
      unawaited(cancel());
    }
  }

  @override
  Future<void> cancel() {
    ++_revision;
    _endTime = null;
    _startRequested = false;
    return _enqueue(os.cancel);
  }

  @override
  Future<void> onSessionAlmostEnding(SessionType type) {
    if (type != SessionType.work ||
        _endTime == null ||
        !_endTime!.isAfter(DateTime.now())) {
      return Future.value();
    }
    final id = _sessionId;
    final end = _message();
    final revision = _revision;
    return _enqueue(() async {
      final settings = await ref.read(notificationSettingsProvider.future);
      if (revision != _revision) return;
      if (settings.endEnabled && id != null) {
        await os.complete(sessionId: id, title: end.title, body: end.body);
      } else {
        await os.cancel();
      }
    });
  }

  @override
  Future<void> onSessionCompleted(SessionType type) async {
    final notification = cancel();
    // Haptics remain independent of OS permission and notification preferences.
    if (type == SessionType.work) {
      final setting = ref.read(hapticSettingProvider);
      if (setting.isEnabled) {
        try {
          await ref.read(hapticServiceProvider).test(setting);
        } catch (e, st) {
          logger.e(
            '[TimerNotificationService] Haptics failed',
            error: e,
            stackTrace: st,
          );
        }
      }
    }
    await notification;
  }

  @override
  void dispose() {
    _disposed = true;
    ++_revision;
    unawaited(
      _pending.then((_) => os.cancel()).catchError((Object e, StackTrace st) {
        logger.e(
          '[TimerNotificationService] Dispose cancellation failed',
          error: e,
          stackTrace: st,
        );
      }),
    );
  }
}
