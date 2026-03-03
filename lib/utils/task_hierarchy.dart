import 'package:collection/collection.dart';
import 'package:ptune/models/my_task.dart';

/// トグル結果の種類
enum MovePlanKind { makeSubtask, unindent, noop, error }

/// Google Tasks tasks.move 相当の計画
class MovePlan {
  final MovePlanKind kind;
  final String? parent; // null → TOP レベル
  final String? previousId; // null → 先頭
  final String reason;

  const MovePlan(this.kind, {this.parent, this.previousId, this.reason = ''});
}

/// -------------------------
/// 公開 API
/// -------------------------

/// 通常の行移動（UI からの指定 previous / asChild を Logic 順で解決）
MovePlan planMove(
  List<MyTask> allTasks,
  MyTask task,
  MyTask? uiPrevious,
  bool asChild,
) {
  // ① 親決定（UI 指定は parent のみ反映）
  final String? targetParent = asChild
      ? (uiPrevious == null ? null : (uiPrevious.parent ?? uiPrevious.id))
      : uiPrevious?.parent;

  // 子を持つタスクをサブタスク化しない
  if (asChild && _hasChildren(allTasks, task)) {
    return const MovePlan(MovePlanKind.error, reason: 'ERR_HAS_CHILDREN');
  }

  // ② siblings を Logic 順で取得
  final siblings = _siblingsInLogicOrder(
    allTasks,
    parentId: targetParent,
    excludeId: task.id,
  );

  // ③ previousId 解決（Logic 順）
  String? previousId;
  if (uiPrevious != null) {
    final idx = siblings.indexWhere((t) => t.id == uiPrevious.id);
    if (idx >= 0) {
      previousId = siblings[idx].id;
    }
  }

  return MovePlan(
    asChild ? MovePlanKind.makeSubtask : MovePlanKind.unindent,
    parent: targetParent,
    previousId: previousId,
    reason: 'planMove: parent=$targetParent previous=$previousId (logic-order)',
  );
}

/// 親子トグル（UI 非依存）
// -------------------------
// 親子トグル（UI 非依存・Logic 順）
// -------------------------
// -------------------------
// 親子トグル（修正版）
// -------------------------
MovePlan planToggleMove(List<MyTask> allTasks, MyTask task) {
  // ===== SUBTASK → TOP =====
  if (task.parent != null) {
    final parent = _getById(allTasks, task.parent!);

    // TOP レベル siblings（Logic 順・昇順）
    final topLevel = _siblingsInLogicOrder(
      allTasks,
      parentId: null,
      excludeId: task.id,
    );

    // 親の位置を特定
    final parentIndex = topLevel.indexWhere((t) => t.id == parent?.id);

    // 親が先頭なら previousId = parent
    // それ以外なら previousId = 親の直前 sibling
    final String? previousId = parentIndex <= 0
        ? parent?.id
        : topLevel[parentIndex - 1].id;

    return MovePlan(
      MovePlanKind.unindent,
      parent: null,
      previousId: previousId,
      reason: 'toggle: unindent after parent=${parent?.title}',
    );
  }

  // ===== TOP → SUBTASK =====
  final topLevel = _siblingsInLogicOrder(
    allTasks,
    parentId: null,
    excludeId: task.id,
  );

  if (topLevel.isEmpty) {
    return const MovePlan(
      MovePlanKind.error,
      reason: 'toggle: no previous TOP task',
    );
  }

  // 直前（Logic 順で最後）の TOP を親にする
  final parent = topLevel.last;

  return MovePlan(
    MovePlanKind.makeSubtask,
    parent: parent.id,
    previousId: null, // 子の先頭
    reason: 'toggle: makeSubtask under ${parent.title}',
  );
}

// -------------------------
// internal: Logic 順 siblings（昇順）
// -------------------------
List<MyTask> _siblingsInLogicOrder(
  List<MyTask> allTasks, {
  required String? parentId,
  String? excludeId,
}) {
  final list = allTasks
      .where((t) => t.parent == parentId && t.id != excludeId)
      .toList();

  // Logic 順（昇順）
  list.sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));
  return list;
}

MyTask? _getById(List<MyTask> allTasks, String id) =>
    allTasks.firstWhereOrNull((t) => t.id == id);

/// 最後の行に追加（Logic 順の末尾）
/// -------------------------
/// insert: TOP レベル末尾（Logic 順）
/// -------------------------

class InsertPlan {
  final String? previousId;
  final String? parent;
  InsertPlan({required this.previousId, required this.parent});
}

///
/// 最後の行に追加するための plan
/// - position が null のタスクは除外
/// - 「最後の sibling」を previousId に指定
///
InsertPlan planInsertLast(List<MyTask> tasks) {
  // トップレベルのみ
  final topLevel = tasks.where((t) => t.parent == null).toList();

  if (topLevel.isEmpty) {
    // 最初の1件
    return InsertPlan(previousId: null, parent: null);
  }

  // position が確定しているものだけを対象にする
  final positioned = topLevel.where((t) => t.position != null).toList();

  if (positioned.isEmpty) {
    // 全て null の場合は previousId を指定しない
    // （move により API 側で採番される）
    return InsertPlan(previousId: null, parent: null);
  }

  // position 昇順（小さい → 上）
  positioned.sort((a, b) => a.position!.compareTo(b.position!));

  final last = positioned.last;

  return InsertPlan(previousId: last.id, parent: null);
}

bool _hasChildren(List<MyTask> allTasks, MyTask parent) =>
    allTasks.any((t) => t.parent == parent.id);

/// ----------------------------------------
/// 互換用（既存 Provider / Debug 用）
/// UI 表示順（降順）
/// ----------------------------------------
List<MyTask> sortByHierarchyPosition(List<MyTask> flat) {
  // parent == null のタスク（トップレベル）
  final topLevel = flat.where((t) => t.parent == null).toList()
    ..sort((a, b) => (b.position ?? '').compareTo(a.position ?? ''));

  // parentId ごとのサブタスク
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
