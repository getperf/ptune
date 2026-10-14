import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ptune/controllers/timer_controller.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/models/session_type.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/pomodoro_summary_provider.dart';
import 'package:ptune/providers/timer_controller_provider.dart';
import 'package:ptune/providers/timer_notification_service_provider.dart';
import 'package:ptune/services/pomodoro_summary_applier.dart';
import 'package:ptune/services/timer_notification_service.dart';
import 'package:ptune/states/auto_mode_state.dart';
import 'package:ptune/states/remaining_time_state.dart';
import 'package:ptune/utils/logger.dart';
import 'package:ptune/states/blink_notifier.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/task_review/operation_miss_candidate_provider.dart';
import 'package:ptune/services/task_service_interface.dart';

class NoBlink extends BlinkNotifier {
  @override
  void startBlink({
    int times = 3,
    Duration interval = const Duration(seconds: 1),
  }) {}
}

class EmptyTasks implements TaskServiceInterface {
  @override
  Future<List<MyTask>> fetchTasks() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Notifications implements TimerNotificationService {
  final starts = <bool>[];
  final events = <String>[];
  int cancels = 0;
  int warnings = 0;
  @override
  Future<void> onTimerRunning(
    SessionType type,
    DateTime? endTime, {
    bool newSession = false,
    bool automaticStart = false,
  }) async {
    if (type == SessionType.work) starts.add(automaticStart);
  }

  @override
  Future<void> cancel() async {
    cancels++;
  }

  @override
  Future<void> onSessionCompleted(SessionType type) async {
    events.add(type.name);
  }

  @override
  void refresh() {}
  @override
  Future<void> onSessionAlmostEnding(SessionType type) async {
    if (type == SessionType.work) warnings++;
  }

  @override
  void dispose() {}
}

class Summary extends PomodoroSummaryApplier {
  final Notifications notifications;
  final pending = Completer<List<MyTask>>();
  bool hold = false;
  Summary(this.notifications);
  @override
  Future<List<MyTask>> apply(Ref ref, Map<String, double> summary) {
    notifications.events.add('save');
    return hold ? pending.future : Future.value([]);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    initLoggerForTest();
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
          'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.toggle',
          (_) async =>
              const StandardMessageCodec().encodeMessage(<Object?>[null]),
        );
  });
  Future<(ProviderContainer, TimerController, Notifications, Summary)>
  setup() async {
    final notifications = Notifications();
    final summary = Summary(notifications);
    final container = ProviderContainer(
      overrides: [
        blinkStateProvider.overrideWith((ref) => NoBlink()),
        taskServiceProvider.overrideWithValue(EmptyTasks()),
        timerNotificationServiceProvider.overrideWithValue(notifications),
        pomodoroSummaryApplierProvider.overrideWithValue(summary),
        pomodoroSchedulerProvider.overrideWithValue(
          PomodoroScheduler(isDemo: false),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(autoModeProvider);
    container.read(tasksProvider);
    await Future<void>.delayed(Duration.zero);
    await container.read(autoModeProvider.notifier).set(AutoMode.auto);
    return (
      container,
      container.read(timerControllerProvider),
      notifications,
      summary,
    );
  }

  test(
    'manual start, resume and reset never request automatic start notification',
    () async {
      final (_, controller, notifications, _) = await setup();
      controller.start();
      controller.pause();
      controller.resume();
      await Future<void>.delayed(Duration.zero);
      await controller.reset();
      controller.stop();
      expect(notifications.starts, [false, false, false]);
      expect(notifications.events.where((e) => e == 'work'), isEmpty);
      expect(notifications.cancels, greaterThanOrEqualTo(3));
    },
  );
  test(
    'time completion notifies before blocked save and stop prevents auto transition',
    () async {
      final (container, controller, notifications, summary) = await setup();
      summary.hold = true;
      controller.start();
      container.read(remainingTimeProvider.notifier).start(0);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(notifications.events, ['work', 'save']);
      controller.stop();
      summary.pending.complete([]);
      await Future<void>.delayed(Duration.zero);
      expect(notifications.starts, [false]);
    },
  );

  test(
    'crossing below 30 seconds warns once without waiting for completion',
    () async {
      final (container, controller, notifications, _) = await setup();
      controller.start();
      container.read(remainingTimeProvider.notifier).start(29);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(notifications.warnings, 1);
      expect(notifications.events, isEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(notifications.warnings, 1);
      controller.stop();
    },
  );

  test(
    'only automatic transition from break requests a work start notification',
    () async {
      final (container, controller, notifications, _) = await setup();
      controller.start();
      container.read(remainingTimeProvider.notifier).start(0);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(container.read(sessionTypeProvider), SessionType.shortBreak);
      container.read(remainingTimeProvider.notifier).start(0);
      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(container.read(sessionTypeProvider), SessionType.work);
      expect(notifications.starts, [false, true]);
      controller.stop();
    },
  );

  test('safe guard adds no stop or subsequent start notification', () async {
    final (container, controller, notifications, _) = await setup();
    await container.read(autoModeProvider.notifier).set(AutoMode.autoSafe);
    controller.start();
    container.read(tasksProvider.notifier).replaceAll([
      const MyTask(
        id: 'over',
        title: '超過',
        pomodoro: PomodoroInfo(planned: 0, actual: 5),
      ),
    ]);
    container.read(selectedTimerTaskIdProvider.notifier).state = 'over';
    container.read(remainingTimeProvider.notifier).start(0);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    expect(notifications.events, ['work', 'save']);
    expect(notifications.starts, [false]);
    expect(container.read(sessionTypeProvider), SessionType.work);
    expect(
      container.read(operationMissCandidateTaskIdsProvider),
      contains('over'),
    );
  });
}
