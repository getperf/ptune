import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/providers/task_review/task_review_provider.dart';

class GoalInput extends ConsumerStatefulWidget {
  final String taskId;

  const GoalInput({super.key, required this.taskId});

  @override
  ConsumerState<GoalInput> createState() => _GoalInputState();
}

class _GoalInputState extends ConsumerState<GoalInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = ref.read(taskReviewProvider(widget.taskId));
    _controller = TextEditingController(text: state.goal ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 1,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'Goal',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: (value) {
        ref.read(taskReviewProvider(widget.taskId).notifier).setGoal(value);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
