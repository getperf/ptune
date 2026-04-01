import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task.dart';

/// タイマー完了直後のタスク（レビュー表示用）
/// Home に戻るまで一時保持する
final completedTimerTaskProvider = StateProvider<MyTask?>((ref) => null);
