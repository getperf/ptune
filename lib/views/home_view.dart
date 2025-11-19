import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/controllers/home_controller.dart';
import 'package:ptune/providers/home_controller_provider.dart';
import 'package:ptune/views/components/home/add_task_form.dart';
import 'components/home/task_list_view.dart';
import 'components/home/summary_view.dart';
import 'components/home/bottom_nav_bar.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  Widget buildAddTaskButton(
      BuildContext context, bool isVisible, Future<bool> Function() onToggle) {
    return Tooltip(
      message: isVisible ? '閉じる' : 'タスクを編集',
      child: IconButton(
        icon: Icon(isVisible ? Icons.close : Icons.add),
        onPressed: () async {
          final ok = await onToggle();
          if (!ok && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('オフラインのためタスクの編集はできません')),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = HomeController(ref, context);
    final controller = ref.read(homeControllerProvider(context));

    final isFormVisible = ref.watch(isFormVisibleProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        actions: [
          buildAddTaskButton(context, isFormVisible, controller.toggleTaskForm)
        ],
      ),
      // appBar: AppBar(toolbarHeight: 40),
      body: Column(
        children: [
          const SummaryView(),
          AnimatedCrossFade(
            duration: Duration(milliseconds: 200),
            crossFadeState: isFormVisible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: const AddTaskForm(),
            secondChild: const SizedBox.shrink(),
          ),
          const Expanded(child: TaskListView()),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
