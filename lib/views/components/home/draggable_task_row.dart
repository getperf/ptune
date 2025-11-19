import 'package:flutter/material.dart';
import 'package:ptune/controllers/home_controller.dart';
import 'package:ptune/models/task_row.dart';
import 'package:ptune/views/components/home/task_tile.dart';
import '../../../models/my_task.dart';

class DraggableTaskRow extends StatelessWidget {
  final TaskRow row;
  final HomeController controller;
  final Widget childWhenDragging;
  const DraggableTaskRow(
      {super.key,
      required this.row,
      required this.controller,
      required this.childWhenDragging});

  @override
  Widget build(BuildContext context) {
    final task = row.task;
    return LongPressDraggable<MyTask>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey.withValues(alpha: 0.8),
          child: Text(task.title, style: const TextStyle(color: Colors.white)),
        ),
      ),
      childWhenDragging: childWhenDragging,
      child: TaskTile(row: row, controller: controller),
    );
  }
}
