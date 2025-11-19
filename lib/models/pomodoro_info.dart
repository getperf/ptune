// lib/models/pomodoro_info.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pomodoro_info.freezed.dart';
part 'pomodoro_info.g.dart'; // ← 追加

@freezed
class PomodoroInfo with _$PomodoroInfo {
  const factory PomodoroInfo({required int planned, double? actual}) =
      _PomodoroInfo;

  factory PomodoroInfo.fromJson(Map<String, dynamic> json) =>
      _$PomodoroInfoFromJson(json); // ← 追加
}

extension PomodoroInfoDisplay on PomodoroInfo {
  String toDisplayString() {
    final tomato = "🍅x$planned";
    final done = actual != null ? " ✅x${actual!.toStringAsFixed(1)}" : "";
    return "$tomato$done";
  }
}
