import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/home_controller_provider.dart';
import 'package:ptune/views/components/home/draggable_task_row.dart';
import 'package:ptune/models/task_row.dart';
import 'package:ptune/views/components/home/drop_target.dart';
import 'package:ptune/views/components/home/task_tile.dart';
import 'package:ptune/views/components/home/drop_points_builder.dart';
import '../../../models/my_task.dart';
import '../../../utils/task_flatten_utils.dart';

final currentDropIndicatorProvider =
    StateProvider<DropIndicator?>((ref) => null);

class DraggableTaskList extends ConsumerStatefulWidget {
  final List<MyTask> allTasks;
  const DraggableTaskList({super.key, required this.allTasks});

  @override
  ConsumerState<DraggableTaskList> createState() => _DraggableTaskListState();
}

class _DraggableTaskListState extends ConsumerState<DraggableTaskList> {
  // DropIndicator? _currentIndicator;

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(homeControllerProvider(context));
    final rows = flattenTasksHierarchically(widget.allTasks);
    final drops = buildDropPoints(rows);

    final children = <Widget>[];

    for (int i = 0; i < rows.length; i++) {
      final dropBefore = drops.where((d) => d.index == i);

      for (final drop in dropBefore) {
        children.add(DropTargetWidget(
          indicator: drop.indicator,
          controller: controller,
        ));
      }

      final row = rows[i];
      children.add(DraggableTaskRow(
        key: ValueKey(row.task.id),
        row: row,
        controller: controller,
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: TaskTile(row: row, controller: controller),
        ),
      ));
    }

    // 最後の行の後ろのインジケータ
    final dropAfter = drops.where((d) => d.index == rows.length);
    for (final drop in dropAfter) {
      children.add(DropTargetWidget(
        indicator: drop.indicator,
        controller: controller,
      ));
    }

    return ListView.builder(
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
    );
  }
}
