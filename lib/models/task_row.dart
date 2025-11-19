import 'package:ptune/models/my_task.dart';

class TaskRow {
  final MyTask task;
  final int depth;
  TaskRow(this.task, this.depth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskRow &&
          runtimeType == other.runtimeType &&
          task.id == other.task.id;

  @override
  int get hashCode => task.id.hashCode;
}

class DropIndicator {
  final MyTask? previousTask;
  final bool asChild;
  final int index;

  const DropIndicator({
    required this.previousTask,
    required this.asChild,
    required this.index,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DropIndicator &&
          runtimeType == other.runtimeType &&
          previousTask?.id == other.previousTask?.id &&
          asChild == other.asChild &&
          index == other.index;

  @override
  int get hashCode => Object.hash(previousTask?.id, asChild, index);

  @override
  String toString() {
    final prev = previousTask?.title ?? "(null)";
    return "[${asChild ? "CHILD" : "PARENT"}] $prev @ $index";
  }
}

class DropPoint {
  final DropIndicator indicator;
  final int index;

  const DropPoint(this.indicator, this.index);
}

// class DropIndicator {
//   final String? previousId;
//   final String? parentId;
//   DropIndicator({required this.previousId, required this.parentId});

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is DropIndicator &&
//           runtimeType == other.runtimeType &&
//           previousId == other.previousId &&
//           parentId == other.parentId;

//   @override
//   int get hashCode => Object.hash(previousId, parentId);
// }
