import 'package:flutter/material.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/views/components/timer/review_flag_chips.dart';

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

  @override
  Widget build(BuildContext context) {
    // ★ task が null の場合は安全に早期リターン
    if (task == null) {
      return GestureDetector(
        onTap: onGoHome,
        child: const Text(
          "タスクを選んでください",
          style: TextStyle(
            fontSize: 14,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
      );
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
              child: Text(
                task!.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: _isCompleted ? 14 : 18,
                  color: _isCompleted ? Colors.grey : Colors.white,
                  fontWeight: _isCompleted
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // ★ 完了時のみレビューUI
        if (_isCompleted) ...[
          const SizedBox(height: 6),
          const Text(
            '問題があった場合は記録してください',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          const ReviewFlagChips(),
        ],
      ],
    );
  }
}
