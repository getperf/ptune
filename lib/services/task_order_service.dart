import 'package:ptune/utils/logger.dart';

import '../models/my_task.dart';

enum MovePlanType { add, move, indent, unindent, error }

class MovePlan {
  final MovePlanType type;
  final String? parent;
  final String? previous;
  final String reason;

  const MovePlan({
    required this.type,
    this.parent,
    this.previous,
    this.reason = '',
  });

  const MovePlan.error(this.reason)
    : type = MovePlanType.error,
      parent = null,
      previous = null;
}

class TaskOrderService {
  /// -----------------------------
  /// normalize (UI表示順)
  /// -----------------------------
  static List<MyTask> normalizeForUi(List<MyTask> tasks) {
    final sorted = [...tasks];

    sorted.sort((a, b) {
      final ap = a.position;
      final bp = b.position;

      if (ap == null && bp == null) return 0;
      if (ap == null) return 1;
      if (bp == null) return -1;

      return ap.compareTo(bp);
    });

    final parents = sorted.where((t) => t.parent == null).toList();

    final Map<String, List<MyTask>> children = {};

    for (final t in sorted) {
      if (t.parent != null) {
        children.putIfAbsent(t.parent!, () => []).add(t);
      }
    }

    final result = <MyTask>[];

    for (final p in parents) {
      result.add(p);

      final c = children[p.id];
      if (c != null) {
        result.addAll(c);
      }
    }
    logger.i("=== NORMALIZE RESULT ===");
    for (final t in result) {
      logger.i("${t.title} pos=${t.position}");
    }

    return result;
  }

  /// -----------------------------
  /// ADD
  /// -----------------------------
  MovePlan planAdd(List<MyTask> tasks) {
    if (tasks.isEmpty) {
      return const MovePlan(
        type: MovePlanType.add,
        parent: null,
        previous: null,
      );
    }

    final last = tasks.last;

    return MovePlan(
      type: MovePlanType.add,
      parent: last.parent,
      previous: last.id,
      reason: "append after last",
    );
  }

  /// -----------------------------
  /// MOVE
  /// -----------------------------
  MovePlan planMove({
    required List<MyTask> tasks,
    required MyTask task,
    required int targetIndex,
  }) {
    final currentIndex = tasks.indexWhere((t) => t.id == task.id);

    if (currentIndex < 0) {
      return const MovePlan.error("TASK_NOT_FOUND");
    }

    final target = tasks[targetIndex];

    /// 同一レベルのみ
    if (task.parent != target.parent) {
      return const MovePlan.error("DIFFERENT_LEVEL_MOVE");
    }

    String? previous;

    if (targetIndex == 0) {
      previous = null;
    } else {
      previous = tasks[targetIndex - 1].id;
    }

    return MovePlan(
      type: MovePlanType.move,
      parent: task.parent,
      previous: previous,
      reason: "move within same level",
    );
  }

  /// -----------------------------
  /// TOGGLE
  /// -----------------------------
  MovePlan planToggle({required List<MyTask> tasks, required MyTask task}) {
    if (task.parent == null) {
      return _planIndent(tasks, task);
    } else {
      return _planUnindent(tasks, task);
    }
  }

  /// -----------------------------
  /// INDENT
  /// -----------------------------
  MovePlan _planIndent(List<MyTask> tasks, MyTask task) {
    final index = tasks.indexWhere((t) => t.id == task.id);

    if (index <= 0) {
      return const MovePlan.error("NO_PREVIOUS_TASK");
    }

    final prev = tasks[index - 1];

    /// prev が親
    if (prev.parent == null) {
      return MovePlan(
        type: MovePlanType.indent,
        parent: prev.id,
        previous: null,
        reason: "indent under previous parent",
      );
    }

    /// prev が子
    return MovePlan(
      type: MovePlanType.indent,
      parent: prev.parent,
      previous: prev.id,
      reason: "indent as sibling of previous child",
    );
  }

  /// -----------------------------
  /// UNINDENT
  /// -----------------------------
  MovePlan _planUnindent(List<MyTask> tasks, MyTask task) {
    final parent = tasks.firstWhere(
      (t) => t.id == task.parent,
      orElse: () => throw Exception("Parent not found"),
    );

    final siblings = tasks.where((t) => t.parent == task.parent).toList();

    /// 末尾子のみ
    if (siblings.last.id != task.id) {
      return const MovePlan.error("NOT_LAST_CHILD");
    }

    return MovePlan(
      type: MovePlanType.unindent,
      parent: parent.parent,
      previous: parent.id,
      reason: "unindent after parent",
    );
  }

  /// -----------------------------
  /// Task sort
  /// -----------------------------
  static List<MyTask> sortByPosition(List<MyTask> tasks) {
    final copy = [...tasks];

    copy.sort((a, b) {
      final ap = a.position;
      final bp = b.position;

      if (ap == null && bp == null) return 0;
      if (ap == null) return 1; // null は最後
      if (bp == null) return -1;

      return ap.compareTo(bp);
    });

    return copy;
  }

  static List<MyTask> siblings(
    List<MyTask> tasks,
    String? parent, {
    String? excludeId,
  }) {
    final list = tasks
        .where((t) => t.parent == parent && t.id != excludeId)
        .toList();

    return sortByPosition(list);
  }
}
