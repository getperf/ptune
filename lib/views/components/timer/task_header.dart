import 'package:flutter/material.dart';
import 'package:ptune/models/my_task.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (parentTask != null)
          Align(
            // alignment: Alignment.centerLeft,
            // padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '親タスク: ${parentTask?.title}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        Row(
          children: [
            // IconButton(
            IconButton(
              iconSize: 32,
              constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
              padding: const EdgeInsets.all(8),
              icon: Icon(
                task?.status == "completed"
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onPressed: onToggle,
            ),
            const SizedBox(width: 8),
            task == null
                ? GestureDetector(
                    onTap: onGoHome,
                    child: const Text(
                      "タスクを選んでください",
                      style: TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                  )
                : Expanded(
                    // 追加
                    child: Text(
                      task!.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
