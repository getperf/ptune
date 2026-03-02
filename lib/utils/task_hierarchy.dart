import 'package:collection/collection.dart';
import 'package:ptune/models/my_task_ext.dart';
import '../models/my_task.dart';

/// トグル結果の種類
enum MovePlanKind { makeSubtask, unindent, noop, error }

/// Google Tasks tasks.move 相当の計画
class MovePlan {
  final MovePlanKind kind;
  final String? parent; // null → TOP レベル
  final String? previousId; // null → 親配下 or TOP の先頭
  final String reason;

  const MovePlan(this.kind, {this.parent, this.previousId, this.reason = ''});
}

/// 事前条件の型（必要ならUIで理由表示に使える）
class MovePrecheck {
  final bool ok;
  final String reason;
  const MovePrecheck(this.ok, this.reason);

  static const okResult = MovePrecheck(true, '');
}

/// -------------------------
/// public API
/// -------------------------

MovePlan planMove(
  List<MyTask> allTasks,
  MyTask task,
  MyTask? uiPrevious,
  bool asChild,
) {
  final hasChild = allTasks.any((t) => t.parent == task.id);

  if (asChild && hasChild) {
    return MovePlan(MovePlanKind.error, reason: "子を持つ親タスクはサブタスクにできません");
  }

  // =========================
  // ① 親決定
  // =========================

  String? targetParent;

  if (asChild) {
    if (uiPrevious == null) {
      return const MovePlan(MovePlanKind.error, reason: "previous が必要です");
    }

    if (uiPrevious.parent == null) {
      targetParent = uiPrevious.id;
    } else {
      targetParent = uiPrevious.parent;
    }
  } else {
    targetParent = uiPrevious?.parent;
  }

  // =========================
  // ② sibling を安全取得
  // =========================

  final siblings =
      allTasks
          .where((t) => t.parent == targetParent && t.id != task.id)
          .toList()
        ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));

  String? safePreviousId;

  if (uiPrevious != null) {
    final match = siblings.firstWhereOrNull((t) => t.id == uiPrevious.id);
    safePreviousId = match?.id;
  }

  return MovePlan(
    asChild ? MovePlanKind.makeSubtask : MovePlanKind.unindent,
    parent: targetParent,
    previousId: safePreviousId,
    reason: "safeMove: parent=$targetParent previous=$safePreviousId",
  );
}

/// 表示順（フラット）と対象タスクから、トグル時の move 計画を返す
MovePlan planToggleMove(List<MyTask> flat, MyTask task) {
  final sorted = sortByHierarchyPosition(flat);

  final pre = precheckTwoLevel(sorted, task);
  if (!pre.ok) {
    return MovePlan(MovePlanKind.error, reason: pre.reason);
  }

  return (task.parent == null)
      ? _planMakeSubtask(sorted, task)
      : _planUnindent(sorted, task);
}

MovePlan planInsertLast(List<MyTask> flat) {
  final sorted = sortByHierarchyPosition(flat);

  if (sorted.isEmpty) {
    return const MovePlan(
      MovePlanKind.noop,
      parent: null,
      previousId: null,
      reason: 'empty: 先頭に追加',
    );
  }

  final last = sorted.last;

  if (last.parent == null) {
    return MovePlan(
      MovePlanKind.noop,
      parent: null,
      previousId: last.id,
      reason: '末尾タスクの後ろに追加: ${last.title}',
    );
  }

  // サブタスク → 親タスクの後ろに追加する
  final parent = _getById(sorted, last.parent!);
  if (parent != null) {
    return MovePlan(
      MovePlanKind.noop,
      parent: null,
      previousId: parent.id,
      reason: '末尾がサブタスクのため、親の後ろに追加: ${parent.title}',
    );
  }

  // 不整合：親が不明 → 末尾サブタスクの後ろに追加（安全側）
  return MovePlan(
    MovePlanKind.noop,
    parent: null,
    previousId: last.id,
    reason: '親不明の末尾サブタスク → 自身の後ろに追加',
  );
}

/// -------------------------
/// 2階層ルールの事前チェック
/// -------------------------

MovePrecheck precheckTwoLevel(List<MyTask> sorted, MyTask task) {
  if (task.parent != null) {
    final parent = _getById(sorted, task.parent!);
    if (parent == null) {
      return MovePrecheck(false, 'ERR_INVALID_PARENT: 親が見つかりません');
    }
    if (parent.parent != null) {
      // 親の親がある＝孫 → 許容して解除時にTOPへ救済
    }
  }
  return MovePrecheck.okResult;
}

/// -------------------------
/// internal: サブタスク化
/// -------------------------

MovePlan _planMakeSubtask(List<MyTask> sorted, MyTask task) {
  if (_hasChildren(sorted, task)) {
    return MovePlan(
      MovePlanKind.error,
      reason: 'ERR_HAS_CHILDREN: 子を持つタスクはサブタスク化できません',
    );
  }

  final idx = sorted.indexWhere((t) => t.id == task.id);
  if (idx <= 0) {
    return MovePlan(MovePlanKind.error, reason: '先頭要素はサブタスク化できません（previous不在）');
  }

  final prev = sorted[idx - 1];
  final parent = (prev.parent == null)
      ? prev
      : _getById(sorted, prev.parent!) ?? prev;

  final previousSibling = _findPreviousSiblingUnder(
    sorted,
    beforeIndex: idx,
    parent: parent.id,
  );

  return MovePlan(
    MovePlanKind.makeSubtask,
    parent: parent.id,
    previousId: previousSibling?.id,
    reason:
        'makeSubtask: parent=${parent.title}, previous=${previousSibling?.title ?? "先頭(null)"}',
  );
}

/// -------------------------
/// internal: サブタスク解除（子→TOP）
/// -------------------------

MovePlan _planUnindent(List<MyTask> sorted, MyTask task) {
  if (task.parent == null) {
    return MovePlan(MovePlanKind.noop, reason: 'TOP レベルは解除不要');
  }
  final parent = _getById(sorted, task.parent!);
  if (parent == null) {
    return const MovePlan(
      MovePlanKind.unindent,
      parent: null,
      previousId: null,
      reason: '親が不明のため TOP 先頭へ',
    );
  }

  if (parent.parent == null) {
    return MovePlan(
      MovePlanKind.unindent,
      parent: null,
      previousId: parent.id,
      reason: 'unindent(child): to TOP after parent=${parent.title}',
    );
  } else {
    return const MovePlan(
      MovePlanKind.unindent,
      parent: null,
      previousId: null,
      reason: 'unindent(grandchild-data): to TOP head',
    );
  }
}

/// -------------------------
/// helpers
/// -------------------------

List<MyTask> sortByHierarchyPosition(List<MyTask> flat) {
  // parent == null のタスク（トップレベル）
  final topLevel = flat.where((t) => t.parent == null).toList()
    ..sort((a, b) => (b.position ?? '').compareTo(a.position ?? ''));

  // parentId ごとのサブタスクリストをマップ化（position順）
  final Map<String, List<MyTask>> childrenMap = {};
  for (final t in flat) {
    if (t.parent != null) {
      childrenMap.putIfAbsent(t.parent!, () => []).add(t);
    }
  }
  for (final list in childrenMap.values) {
    list.sort((a, b) => (b.position ?? '').compareTo(a.position ?? ''));
  }

  // 階層順にフラット化
  final List<MyTask> sorted = [];
  for (final parent in topLevel) {
    sorted.add(parent);
    final children = childrenMap[parent.id];
    if (children != null) {
      sorted.addAll(children);
    }
  }
  return sorted;
}

MyTask? _getById(List<MyTask> sorted, String id) =>
    sorted.firstWhereOrNull((t) => t.id == id);

bool _hasChildren(List<MyTask> sorted, MyTask parent) =>
    sorted.any((t) => t.parent == parent.id);

MyTask? _findPreviousSiblingUnder(
  List<MyTask> sorted, {
  required int beforeIndex,
  required String parent,
}) {
  for (int i = beforeIndex - 1; i >= 0; i--) {
    final t = sorted[i];
    if (t.parent == parent) return t;
  }
  return null;
}
