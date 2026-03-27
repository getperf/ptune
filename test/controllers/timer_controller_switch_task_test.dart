import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/pomodoro_scheduler.dart';
import 'package:ptune/providers/pomodoro_scheduler_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/providers/timer_controller_provider.dart';
import 'package:ptune/services/task_service_interface.dart';
import 'package:ptune/utils/logger.dart';
import 'package:wakelock_plus_platform_interface/wakelock_plus_platform_interface.dart';

class _FakeTaskService implements TaskServiceInterface {
  _FakeTaskService(List<MyTask> initialTasks)
    : _tasks = {for (final task in initialTasks) task.id: task};

  final Map<String, MyTask> _tasks;
  final List<MyTask> savedTasks = [];

  @override
  Future<MyTask> addTask(MyTask task) async {
    _tasks[task.id] = task;
    return task;
  }

  @override
  Future<void> deleteTask(String id) async {
    _tasks.remove(id);
  }

  @override
  Future<List<MyTask>> fetchTasks() async => _tasks.values.toList();

  @override
  Future<void> moveTask(
    String taskId, {
    String? parentId,
    String? previousId,
  }) async {}

  @override
  Future<void> saveTask(MyTask task) async {
    _tasks[task.id] = task;
    savedTasks.add(task);
  }

  @override
  Future<void> saveTasks(List<MyTask> tasks) async {
    for (final task in tasks) {
      _tasks[task.id] = task;
    }
  }
}

class _FakeWakelockPlusPlatform extends WakelockPlusPlatformInterface {
  bool _enabled = false;

  @override
  bool get isMock => true;

  @override
  Future<bool> get enabled async => _enabled;

  @override
  Future<void> toggle({required bool enable}) async {
    _enabled = enable;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    initLoggerForTest();
    WakelockPlusPlatformInterface.instance = _FakeWakelockPlusPlatform();
  });

  group('TimerController.switchTask', () {
    test('flushes partial summary for the previous task before switching', () async {
      final taskA = MyTask(
        id: 'task-a',
        title: 'Task A',
        pomodoro: const PomodoroInfo(planned: 1),
      );
      final taskB = MyTask(
        id: 'task-b',
        title: 'Task B',
        pomodoro: const PomodoroInfo(planned: 1),
      );
      final fakeService = _FakeTaskService([taskA, taskB]);

      final container = ProviderContainer(
        overrides: [
          taskServiceProvider.overrideWithValue(fakeService),
          pomodoroSchedulerProvider.overrideWithValue(
            PomodoroScheduler(isDemo: true),
          ),
        ],
      );
      addTearDown(container.dispose);

      container.read(tasksProvider);
      await Future<void>.delayed(Duration.zero);

      container.read(selectedTimerTaskProvider.notifier).state = taskA;
      final controller = container.read(timerControllerProvider);

      controller.start();

      container.read(selectedTimerTaskProvider.notifier).state = taskB;
      await controller.switchTask();

      final savedTaskA = fakeService.savedTasks.lastWhere(
        (task) => task.id == taskA.id,
      );

      expect(savedTaskA.pomodoro?.actual, isNotNull);
      expect(savedTaskA.pomodoro!.actual!, greaterThan(0));
      expect(container.read(selectedTimerTaskProvider)?.id, taskB.id);

      controller.pause();
    });
  });
}