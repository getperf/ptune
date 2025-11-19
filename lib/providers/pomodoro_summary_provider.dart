import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/pomodoro_summary_applier.dart';

final pomodoroSummaryApplierProvider = Provider<PomodoroSummaryApplier>(
  (_) => PomodoroSummaryApplier(),
);
