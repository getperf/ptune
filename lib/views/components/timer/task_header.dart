import 'package:flutter/material.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/views/components/timer/review_flag_chips.dart';
import 'package:ptune/views/components/timer/goal_input.dart';

class TaskHeader extends StatelessWidget {
  final MyTask? task;
  final MyTask? parentTask;
  final VoidCallback? onToggle;
  final VoidCallback? onGoHome;

  const TaskHeader({
    super.key,
    required this.task,
    required this.parentTask,
    this.onToggle,
    this.onGoHome,
  });

  bool get _isCompleted => task?.status == "completed";

  /// 「タスクを選んでください」リンク表示（共通）
  Widget _buildSelectTaskLink({double fontSize = 18}) {
    return GestureDetector(
      onTap: onGoHome,
      child: Text(
        'タスクを選んでください',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // task 未選択時
    if (task == null) {
      return _buildSelectTaskLink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (parentTask != null)
          Text(
            '親タスク: ${parentTask!.title}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        Row(
          children: [
            IconButton(
              iconSize: 28,
              visualDensity: VisualDensity.compact,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              icon: Icon(
                _isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              ),
              onPressed: onToggle,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _isCompleted
                  ? _buildSelectTaskLink()
                  : Text(
                      task!.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),

        // 完了時のみレビューUI
        if (_isCompleted) ...[
          const SizedBox(height: 6),
          const Text(
            '問題があった場合は記録してください',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          ReviewFlagChips(taskId: task!.id),

          const SizedBox(height: 8),
          GoalInput(taskId: task!.id),
        ],
      ],
    );
  }
}
