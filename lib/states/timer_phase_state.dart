import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/timer_phase.dart';

extension TimerPhaseExtension on TimerPhase {
  bool get isRunning => this == TimerPhase.running;
  bool get isPaused => this == TimerPhase.paused;
}

final timerPhaseProvider = StateProvider<TimerPhase>((ref) => TimerPhase.ready);
