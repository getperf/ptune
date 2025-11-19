import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/home_controller.dart';
import 'package:ptune/models/my_task.dart';
import 'package:ptune/models/task_row.dart';
import 'package:ptune/views/components/home/drop_indicator_bar.dart';
import 'package:ptune/providers/drop_indicator_provider.dart';

class DropTargetWidget extends ConsumerWidget {
  final DropIndicator indicator;
  final HomeController controller;

  const DropTargetWidget({
    super.key,
    required this.indicator,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentDropIndicatorProvider);
    final isActive = current == indicator;

    return DragTarget<MyTask>(
      onWillAcceptWithDetails: (details) {
        ref.read(currentDropIndicatorProvider.notifier).state = indicator;
        return true;
      },
      onLeave: (_) {
        if (ref.read(currentDropIndicatorProvider) == indicator) {
          ref.read(currentDropIndicatorProvider.notifier).state = null;
        }
      },
      onAcceptWithDetails: (details) async {
        await controller.moveTask(
            details.data, indicator.previousTask, indicator.asChild);
        ref.read(currentDropIndicatorProvider.notifier).state = null;
      },
      builder: (context, _, __) {
        return DropIndicatorBar(
          active: isActive,
          asChild: indicator.asChild,
        );
      },
    );
  }
}
