// lib/views/components/timer/review_flag_chips.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/review_flag.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';

class ReviewFlagChips extends ConsumerWidget {
  final String taskId;
  const ReviewFlagChips({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskReviewProvider(taskId));
    final notifier = ref.read(taskReviewProvider(taskId).notifier);

    final visibleFlags = ReviewFlag.values
        .where((f) => f != ReviewFlag.unknown)
        .toList();

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: visibleFlags.map((flag) {
        final selected = state.selected.contains(flag);

        return FilterChip(
          visualDensity: VisualDensity.compact,
          labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          label: Text(_labelOf(flag), style: const TextStyle(fontSize: 16)),
          selected: selected,
          onSelected: (_) => notifier.toggle(flag),
        );
      }).toList(),
    );
  }

  String _labelOf(ReviewFlag flag) {
    switch (flag) {
      case ReviewFlag.operationMiss:
        return '止め忘れ';
      case ReviewFlag.toolOrEnvIssue:
        return '環境問題';
      case ReviewFlag.decisionPending:
        return '未解決';
      case ReviewFlag.scopeExpanded:
        return '難問';
      case ReviewFlag.unresolved:
        return '残件あり';
      case ReviewFlag.newIssueFound:
        return '新たな課題';
      case ReviewFlag.unknown:
        return '';
    }
  }
}
