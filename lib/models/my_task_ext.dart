import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/utils/logger.dart'; // ← 追加
import 'my_task.dart';

extension MyTaskExt on MyTask {
  String get statusMarker => status == "completed" ? "[x]" : "[ ]";

  String toDisplayString() {
    final tomato = pomodoro != null ? " ${pomodoro!.toDisplayString()}" : "";
    return "$statusMarker $title$tomato";
  }

  MyTask markStarted() {
    final updated = copyWith(started: started ?? DateTime.now().toUtc());
    logger.d("[MyTaskExt] markStarted: ${updated.id} → ${updated.started}");
    return updated;
  }

  MyTask markCompleted() {
    final now = DateTime.now().toUtc();
    final updated = copyWith(
      status: "completed",
      started: started ?? now,
      completed: now,
    );
    logger.i("[MyTaskExt] markCompleted: ${updated.id} at $now");
    return updated;
  }

  MyTask markUncompleted() {
    final updated = copyWith(status: "needsAction", completed: null);
    logger.i("[MyTaskExt] markUncompleted: ${updated.id}");
    return updated;
  }

  bool get isParent => parent == null || parent!.isEmpty;
}
