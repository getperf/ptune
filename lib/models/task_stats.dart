import 'package:ptune/models/my_task.dart';

class TaskStats {
  late final int totalPlanned;
  late final double totalActual;
  late final String totalPlannedDuration;
  late final String totalActualDuration;

  TaskStats(List<MyTask> tasks, int unitSec) {
    totalPlanned = tasks.fold(0, (sum, t) => sum + (t.pomodoro?.planned ?? 0));
    totalActual = tasks.fold(0, (sum, t) => sum + (t.pomodoro?.actual ?? 0));
    final plannedSec = totalPlanned * unitSec;
    final actualSec = double.parse((totalActual * unitSec).toStringAsFixed(1));

    totalPlannedDuration = _formatDuration(plannedSec);
    totalActualDuration = _formatDuration(actualSec.round());
  }

  String get formattedTotalActual => totalActual.toStringAsFixed(1);

  static String _formatDuration(int sec) {
    final min = sec ~/ 60;
    final h = min ~/ 60;
    final m = min % 60;
    return "$h:${m.toString().padLeft(2, '0')}";
  }
}
