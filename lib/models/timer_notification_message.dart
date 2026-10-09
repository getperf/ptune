import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/session_type.dart';

class TimerNotificationMessage {
  final String title;
  final String body;
  const TimerNotificationMessage(this.title, this.body);

  static TimerNotificationMessage start(MyTask? task, String? parentTitle) =>
      TimerNotificationMessage(
        '🟢 作業開始',
        _body(task, parentTitle, actual: true),
      );

  static TimerNotificationMessage end(
    MyTask? task,
    String? parentTitle, {
    required SessionType nextBreak,
    required int breakSeconds,
    required bool safeMode,
  }) {
    final duration = breakSeconds % 60 == 0
        ? '${breakSeconds ~/ 60}分'
        : '$breakSeconds秒';
    final title = safeMode
        ? '🔴 作業終了'
        : '🔴 作業終了 → ${nextBreak.label}($duration)';
    return TimerNotificationMessage(
      title,
      _body(task, parentTitle, actual: false),
    );
  }

  static String _body(
    MyTask? task,
    String? parentTitle, {
    required bool actual,
  }) {
    final pomodoro = task?.pomodoro;
    return [
      if (parentTitle != null && parentTitle.isNotEmpty) parentTitle,
      task?.title ?? 'タスクなし',
      if (pomodoro != null)
        (actual ? pomodoro : pomodoro.copyWith(actual: null)).toDisplayString(),
    ].join('\n');
  }
}
