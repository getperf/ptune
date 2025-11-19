import 'package:flutter_test/flutter_test.dart';
import 'package:ptune/utils/task_hierarchy.dart';
import 'package:ptune/models/my_task.dart';

MyTask t(String id, String title, {String? parent}) =>
    MyTask(id: id, title: title, parent: parent);

void main() {
  group('planToggleMove (two-level enforced)', () {
    test('a, b, c で b をサブタスク化 → parent=a, previous=null(先頭)', () {
      final a = t('a', 'a');
      final b = t('b', 'b');
      final c = t('c', 'c');
      final plan = planToggleMove([a, b, c], b);
      expect(plan.kind, MovePlanKind.makeSubtask);
      expect(plan.parent, 'a');
      expect(plan.previousId, isNull);
    });

    test('a > b の後に c をサブタスク化 → parent=a, previous=b', () {
      final a = t('a', 'a');
      final b = t('b', 'b', parent: 'a');
      final c = t('c', 'c');
      final plan = planToggleMove([a, b, c], c);
      expect(plan.kind, MovePlanKind.makeSubtask);
      expect(plan.parent, 'a');
      expect(plan.previousId, 'b');
    });

    test('先頭 a はサブタスク化できない（noop）', () {
      final a = t('a', 'a');
      final plan = planToggleMove([a], a);
      expect(plan.kind, MovePlanKind.noop);
    });

    test('子 b を解除 → TOP after a（parent=null, previous=a）', () {
      final a = t('a', 'a');
      final b = t('b', 'b', parent: 'a');
      final plan = planToggleMove([a, b], b);
      expect(plan.kind, MovePlanKind.unindent);
      expect(plan.parent, isNull);
      expect(plan.previousId, 'a');
    });

    test('子を持つ親 p のサブタスク化は禁止（noop: ERR_HAS_CHILDREN）', () {
      final p = t('p', 'p'); // 親
      final ch = t('ch', 'ch', parent: 'p'); // 子
      final x = t('x', 'x');
      final plan = planToggleMove([p, ch, x], p);
      expect(plan.kind, MovePlanKind.noop);
      expect(plan.reason.contains('ERR_HAS_CHILDREN'), isTrue);
    });

    test('不整合（孫）データの解除は TOP 先頭へ救済', () {
      final a = t('a', 'a');
      final b = t('b', 'b', parent: 'a');
      final c = t('c', 'c', parent: 'b'); // 本来禁止だが、解除時は救済
      final plan = planToggleMove([a, b, c], c);
      expect(plan.kind, MovePlanKind.unindent);
      expect(plan.parent, isNull);
      expect(plan.previousId, isNull); // 先頭へ
    });

    test('直前が別トップ d の場合、c をサブタスク化 → parent=d', () {
      final a = t('a', 'a');
      final d = t('d', 'd');
      final c = t('c', 'c');
      final plan = planToggleMove([a, d, c], c);
      expect(plan.kind, MovePlanKind.makeSubtask);
      expect(plan.parent, 'd');
      expect(plan.previousId, isNull);
    });
  });
}
