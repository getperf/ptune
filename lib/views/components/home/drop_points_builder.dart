import 'package:collection/collection.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/my_task_ext.dart';
import 'package:ptune/models/task_row.dart';

class DropPoint {
  final DropIndicator indicator;
  final int index; // UI上での差し込み位置
  DropPoint(this.indicator, this.index);
}

DropIndicator makeIndicator(
  MyTask? previousTask,
  bool asChild,
  int index,
) {
  return DropIndicator(
    previousTask: previousTask,
    asChild: asChild,
    index: index,
  );
}

DropPoint drop(MyTask? task, bool asChild, int index, int uiIndex) {
  return DropPoint(makeIndicator(task, asChild, index), uiIndex);
}

List<DropPoint> buildDropPoints(List<TaskRow> rows) {
  final pts = <DropPoint>[];

  void add(MyTask? task, bool asChild, int uiIndex) {
    pts.add(drop(task, asChild, pts.length, uiIndex));
  }

  MyTask? tryFindParentTask(MyTask task, List<TaskRow> rows) {
    final parentId = task.parent;
    if (parentId == null) return null;
    return rows.firstWhereOrNull((row) => row.task.id == parentId)?.task;
  }

  for (int i = 0; i < rows.length; i++) {
    final prev = i > 0 ? rows[i - 1].task : null;
    final next = rows[i].task;

    if (prev == null) {
      // 先頭に挿入
      add(null, false, 0);
      continue;
    }
    // 親タスクまたは、サブタスクの先頭
    if (prev.isParent) {
      add(prev, true, i);
      add(prev, false, i);

      // サブタスクの末尾
    } else if (prev.parent != null && prev.parent != next.parent) {
      final parentTask = tryFindParentTask(prev, rows);
      add(prev, true, i);
      add(parentTask, false, i);

      // サブタスクの中間 → 親の兄弟として挿入
    } else {
      add(prev, true, i);
    }
  }

  if (rows.isNotEmpty) {
    final last = rows.last.task;
    final index = rows.length;
    // 最後のタスクの後ろに追加
    if (last.isParent) {
      add(last, true, index);
      add(last, false, index);
    } else {
      final parentTask = tryFindParentTask(last, rows);
      add(last, true, index);
      add(parentTask, false, index);
    }
  }

  return pts;
}
