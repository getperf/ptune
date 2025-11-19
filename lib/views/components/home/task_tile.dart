import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/home_controller.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/models/task_row.dart';

class TaskTile extends ConsumerWidget {
  final TaskRow row;
  final HomeController controller;
  const TaskTile({super.key, required this.row, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = row.task;
    final pomodoro = task.pomodoro;
    final planned = pomodoro?.planned ?? 0;
    final isFormVisible = ref.watch(isFormVisibleProvider);

    return InkWell(
      onTap: () => controller.onTaskTapped(task),
      child: Padding(
        padding: EdgeInsets.only(
            left: row.depth * 16.0, right: 12, top: 1, bottom: 1),
        child: Row(
          children: [
            IconButton(
              icon: Icon(task.status == "completed"
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onPressed: () => controller.toggleTask(task.id),
            ),
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 16,
                  decoration: task.status == "completed"
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            if (pomodoro != null && planned > 0)
              Text(pomodoro.toDisplayString()),
            const SizedBox(width: 8),
            if (!isFormVisible && planned > 0 && task.status != "completed")
              IconButton(
                iconSize: 32,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                padding: const EdgeInsets.all(4),
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () => controller.startTimer(task),
              ),
            if (isFormVisible)
              IconButton(
                iconSize: 32,
                constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                icon: Icon(task.parent == null
                    ? Icons.chevron_right
                    : Icons.chevron_left),
                tooltip: task.parent == null ? 'サブタスク化' : 'サブタスク解除',
                onPressed: () => controller.toggleSubtask(task),
              ),
          ],
        ),
      ),
    );
  }
}
