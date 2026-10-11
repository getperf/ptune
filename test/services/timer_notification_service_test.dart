import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/models/notification_settings.dart';
import 'package:ptune/models/timer_notification_message.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/timer_notification_service_provider.dart';
import 'package:ptune/services/task_service_interface.dart';
import 'package:ptune/services/timer_notification_service.dart';
import 'package:ptune/services/os_notification_service.dart';
import 'package:ptune/services/notification_prefs_service.dart';
import 'package:ptune/states/notification_settings_provider.dart';
import 'package:ptune/states/notification_permission_provider.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/utils/logger.dart';

class Tasks implements TaskServiceInterface {
  @override
  Future<List<MyTask>> fetchTasks() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeOs extends OsNotificationService {
  final calls = <String>[];
  final delivered = <String>{};
  String? scheduled;
  DateTime? scheduledAt;
  String? title;
  String? body;
  bool failSchedule = false;
  @override
  bool get supported => true;
  @override
  Future<NotificationPermission> status() async => const NotificationPermission(
    supported: true,
    allowed: true,
    exactRequired: true,
    exactAllowed: true,
  );
  @override
  Future<void> cancel() async {
    calls.add('cancel');
    scheduled = null;
  }

  @override
  Future<void> send(String title, String body) async {
    calls.add('start');
  }

  @override
  Future<void> schedule({
    required String sessionId,
    required DateTime at,
    required String title,
    required String body,
  }) async {
    if (failSchedule) throw StateError('exact permission missing');
    calls.add('schedule');
    scheduled = sessionId;
    scheduledAt = at;
    this.title = title;
    this.body = body;
  }

  @override
  Future<void> complete({
    required String sessionId,
    required String title,
    required String body,
  }) async {
    scheduled = null;
    if (delivered.add(sessionId)) calls.add('end');
  }
}

class DelayedPrefs extends NotificationPrefsService {
  final ready = Completer<NotificationSettings>();
  @override
  Future<NotificationSettings> load() => ready.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    initLoggerForTest();
  });
  const task = MyTask(
    id: 'child',
    title: '検証',
    parent: 'parent',
    pomodoro: PomodoroInfo(planned: 2, actual: 1.5),
  );
  test('messages show actual and use real break duration', () {
    expect(TimerNotificationMessage.start(task, '親').body, '親\n検証\n🍅x2 ✅x1.5');
    final end = TimerNotificationMessage.end(
      task,
      '親',
      nextBreak: SessionType.longBreak,
      breakSeconds: 900,
      safeMode: false,
    );
    expect(end.title, '🔴 まもなく作業終了 → 長い休憩(15分)');
    expect(end.body, '親\n検証\n🍅x2 ✅x1.5');
    expect(
      TimerNotificationMessage.end(
        null,
        null,
        nextBreak: SessionType.shortBreak,
        breakSeconds: 300,
        safeMode: true,
      ).title,
      '🔴 まもなく作業終了',
    );
  });
  Future<(ProviderContainer, TimerNotificationService, FakeOs)> setup({
    FakeOs? os,
  }) async {
    final fake = os ?? FakeOs();
    final container = ProviderContainer(
      overrides: [
        osNotificationServiceProvider.overrideWithValue(fake),
        taskServiceProvider.overrideWithValue(Tasks()),
        pomodoroSchedulerProvider.overrideWithValue(
          PomodoroScheduler(isDemo: false),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(autoModeProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(autoModeProvider.notifier).set(AutoMode.autoSafe);
    await container.read(notificationSettingsProvider.future);
    await container
        .read(notificationSettingsProvider.notifier)
        .set(startEnabled: true, endEnabled: true);
    container.read(selectedTimerTaskProvider.notifier).state = task;
    return (container, container.read(timerNotificationServiceProvider), fake);
  }

  test(
    'manual start and resume schedule only; automatic work start sends once',
    () async {
      final (_, service, os) = await setup();
      final at = DateTime.now().add(const Duration(minutes: 1));
      await service.onTimerRunning(SessionType.work, at, newSession: true);
      expect(os.calls, ['cancel', 'schedule']);
      expect(os.title, '🔴 まもなく作業終了');
      expect(os.scheduledAt, at.subtract(const Duration(seconds: 30)));
      final id = os.scheduled;
      await service.cancel();
      await service.onTimerRunning(SessionType.work, at);
      expect(os.scheduled, id);
      expect(os.calls.where((c) => c == 'start'), isEmpty);
      await service.onTimerRunning(
        SessionType.work,
        at,
        newSession: true,
        automaticStart: true,
      );
      expect(os.calls.where((c) => c == 'start').length, 1);
      await service.onTimerRunning(
        SessionType.shortBreak,
        at,
        newSession: true,
        automaticStart: true,
      );
      expect(os.calls.where((c) => c == 'start').length, 1);
      expect(os.scheduled, isNull);
    },
  );
  test('refresh updates reserved body with partially committed actual', () async {
    final (container, service, os) = await setup();
    await service.onTimerRunning(
      SessionType.work,
      DateTime.now().add(const Duration(minutes: 1)),
      newSession: true,
    );
    final id = os.scheduled;
    container.read(selectedTimerTaskProvider.notifier).state = task.copyWith(
      pomodoro: const PomodoroInfo(planned: 2, actual: 2.4),
    );
    service.refresh();
    await Future<void>.delayed(Duration.zero);
    expect(os.scheduled, id);
    expect(os.body, '検証\n🍅x2 ✅x2.4');
  });
  test(
    'OS delivery followed by app completion does not duplicate end',
    () async {
      final (_, service, os) = await setup();
      await service.onTimerRunning(
        SessionType.work,
        DateTime.now().add(const Duration(minutes: 1)),
        newSession: true,
      );
      os.delivered.add(os.scheduled!);
      await service.onSessionAlmostEnding(SessionType.work);
      expect(os.calls.where((c) => c == 'end'), isEmpty);
    },
  );
  test('missing exact permission still permits app-time completion', () async {
    final (_, service, os) = await setup(os: FakeOs()..failSchedule = true);
    await service.onTimerRunning(
      SessionType.work,
      DateTime.now().add(const Duration(minutes: 1)),
      newSession: true,
    );
    await service.onSessionAlmostEnding(SessionType.work);
    expect(os.calls.where((c) => c == 'end').length, 1);
  });
  test('turning end off cancels pending reservation', () async {
    final (container, service, os) = await setup();
    await service.onTimerRunning(
      SessionType.work,
      DateTime.now().add(const Duration(minutes: 1)),
      newSession: true,
    );
    expect(os.scheduled, isNotNull);
    await container
        .read(notificationSettingsProvider.notifier)
        .set(endEnabled: false);
    await Future<void>.delayed(Duration.zero);
    expect(os.scheduled, isNull);
    await service.onSessionAlmostEnding(SessionType.work);
    expect(os.calls.where((c) => c == 'end'), isEmpty);
  });
  test(
    'within 30 seconds warns once, and completion never sends another notification',
    () async {
      final (_, service, os) = await setup();
      final at = DateTime.now().add(const Duration(seconds: 20));
      await service.onTimerRunning(SessionType.work, at, newSession: true);
      expect(os.calls, ['cancel', 'end']);
      await service.onSessionAlmostEnding(SessionType.work);
      await service.cancel();
      await service.onTimerRunning(SessionType.work, at);
      await service.onSessionCompleted(SessionType.work);
      expect(os.calls.where((c) => c == 'end').length, 1);
      expect(os.scheduled, isNull);
    },
  );

  test(
    'completion without a prior warning does not issue a late notification',
    () async {
      final (_, service, os) = await setup();
      await service.onTimerRunning(
        SessionType.work,
        DateTime.now().add(const Duration(minutes: 1)),
        newSession: true,
      );
      await service.onSessionCompleted(SessionType.work);
      expect(os.calls.where((c) => c == 'end'), isEmpty);
      expect(os.scheduled, isNull);
    },
  );

  test(
    'pause during preference load prevents late start and reservation',
    () async {
      final prefs = DelayedPrefs();
      final os = FakeOs();
      final provider = Provider<TimerNotificationService>(
        (ref) => TimerNotificationServiceImpl(ref),
      );
      final container = ProviderContainer(
        overrides: [
          osNotificationServiceProvider.overrideWithValue(os),
          notificationPrefsServiceProvider.overrideWithValue(prefs),
          taskServiceProvider.overrideWithValue(Tasks()),
          pomodoroSchedulerProvider.overrideWithValue(
            PomodoroScheduler(isDemo: false),
          ),
        ],
      );
      addTearDown(container.dispose);
      final service = container.read(provider);
      final running = service.onTimerRunning(
        SessionType.work,
        DateTime.now().add(const Duration(minutes: 1)),
        newSession: true,
        automaticStart: true,
      );
      await Future<void>.delayed(Duration.zero);
      final cancelling = service.cancel();
      prefs.ready.complete(
        const NotificationSettings(startEnabled: true, endEnabled: true),
      );
      await running;
      await cancelling;
      expect(os.calls, ['cancel']);
    },
  );
}
