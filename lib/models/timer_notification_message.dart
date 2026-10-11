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
        _body(task, parentTitle),
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
        ? '🔴 まもなく作業終了'
        : '🔴 まもなく作業終了 → ${nextBreak.label}($duration)';
    return TimerNotificationMessage(title, _body(task, parentTitle));
  }

  // 実績は本文作成時点の値。OS予約分は予約時のスナップショットになる。
  static String _body(MyTask? task, String? parentTitle) {
    final pomodoro = task?.pomodoro;
    return [
      if (parentTitle != null && parentTitle.isNotEmpty) parentTitle,
      task?.title ?? 'タスクなし',
      if (pomodoro != null) pomodoro.toDisplayString(),
    ].join('\n');
  }
}
