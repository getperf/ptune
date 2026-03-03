import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ptune/providers/home_controller_provider.dart';
import 'package:ptune/views/components/show_confirm_dialog.dart';

import 'package:ptune/views/components/home/task_tile.dart';
import 'package:ptune/utils/task_flatten_utils.dart';
import 'package:ptune/models/task_row.dart';

import '../../../providers/task_provider.dart';
import '../../../models/my_task.dart';
import '../../../controllers/home_controller.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncTasks = ref.watch(tasksProvider);
    final tasks = asyncTasks.value ?? [];
    final controller = ref.read(homeControllerProvider(context));

    final incompleteTasks = tasks
        .where((t) => t.status != "completed")
        .toList();
    final completedTasks = tasks.where((t) => t.status == "completed").toList();

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '未完了'),
            Tab(text: '完了'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildIncompleteTab(incompleteTasks, controller),
              _buildCompletedTab(completedTasks, controller),
            ],
          ),
        ),
      ],
    );
  }

  /// =========================
  /// 未完了タブ（DnD 廃止）
  /// TaskTile 経由でのみ描画
  /// =========================
  Widget _buildIncompleteTab(List<MyTask> tasks, HomeController controller) {
    final List<TaskRow> rows = flattenTasksHierarchically(tasks);

    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (_, index) {
        final row = rows[index];
        return TaskTile(
          key: ValueKey(row.task.id),
          row: row,
          controller: controller,
        );
      },
    );
  }

  /// =========================
  /// 完了タブ（従来どおり）
  /// =========================
  Widget _buildCompletedTab(List<MyTask> tasks, HomeController controller) {
    return Column(
      children: [
        if (tasks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("完了済みタスクをすべて削除"),
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: "確認",
                  message: "完了済みのタスクをすべて削除しますか？",
                  confirmLabel: "削除",
                  confirmColor: Colors.redAccent,
                );
                if (confirmed == true) {
                  await controller.deleteCompletedTasks();
                }
              },
            ),
          ),
        Expanded(child: _buildCompletedFlatList(tasks, controller)),
      ],
    );
  }

  /// 完了タスクはフラット表示（DnD/階層なし）
  Widget _buildCompletedFlatList(
    List<MyTask> tasks,
    HomeController controller,
  ) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        final task = tasks[index];
        final row = TaskRow(task, 0);
        return TaskTile(
          key: ValueKey(task.id),
          row: row,
          controller: controller,
        );
      },
    );
  }
}
