import 'package:ptune/models/timer_phase.dart';

class PomodoroLog {
  final TimerPhase phase;
  final String? taskId;
  final DateTime timestamp;

  PomodoroLog(this.phase, {this.taskId, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    final ts = timestamp.toLocal().toIso8601String().split('T').last;
    return '${phase.label}:$taskId $ts';
  }
}
