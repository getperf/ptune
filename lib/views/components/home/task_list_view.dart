import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/pomodoro_info.dart';
import 'package:ptune/providers/home_controller_provider.dart';
import 'package:ptune/views/components/home/draggable_task_list.dart';
import 'package:ptune/views/components/show_confirm_dialog.dart';
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

    final incompleteTasks =
        tasks.where((t) => t.status != "completed").toList();
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
              _buildHierarchicalTaskList(incompleteTasks, controller),
              _buildCompletedTab(completedTasks, controller),
            ],
          ),
        ),
      ],
    );
  }

  // 階層表示（未完了タスク用）
  Widget _buildHierarchicalTaskList(
    List<MyTask> tasks,
    HomeController controller,
  ) {
    return DraggableTaskList(allTasks: tasks);

    // final parentTasks = tasks.where((t) => t.parent == null).toList()
    //   ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));
    // return ListView(
    //   children: parentTasks
    //       .expand(
    //         (parent) => [
    //           _buildTaskTile(parent, controller, indent: 0),
    //           ..._buildSubTaskTiles(tasks, parent.id, controller, indent: 16),
    //         ],
    //       )
    //       .toList(),
    // );
  }
  // Widget _buildHierarchicalTaskList(
  //   List<MyTask> tasks,
  //   HomeController controller, // ← 今回は使いませんが引数はそのまま
  // ) {
  //   return DraggableTaskList(allTasks: tasks);
  // }

  // List<Widget> _buildSubTaskTiles(
  //   List<MyTask> allTasks,
  //   String parentId,
  //   HomeController controller, {
  //   required double indent,
  // }) {
  //   final children = allTasks.where((t) => t.parent == parentId).toList()
  //     ..sort((a, b) => (a.position ?? '').compareTo(b.position ?? ''));

  //   return children
  //       .expand(
  //         (child) => [
  //           _buildTaskTile(child, controller, indent: indent),
  //           ..._buildSubTaskTiles(
  //             allTasks,
  //             child.id,
  //             controller,
  //             indent: indent + 16,
  //           ),
  //         ],
  //       )
  //       .toList();
  // }

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
        Expanded(child: _buildFlatTaskList(tasks, controller)),
      ],
    );
  }

  // フラット表示（完了タスク用）
  Widget _buildFlatTaskList(List<MyTask> tasks, HomeController controller) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, index) {
        return _buildTaskTile(tasks[index], controller, indent: 0);
      },
    );
  }

  // 共通のタイル表示
  Widget _buildTaskTile(
    MyTask task,
    HomeController controller, {
    required double indent,
  }) {
    final pomodoro = task.pomodoro;
    final planned = pomodoro?.planned ?? 0;

    return InkWell(
      onTap: () => controller.onTaskTapped(task),
      child: Padding(
        padding: EdgeInsets.only(
          left: indent,
          right: 12.0,
          top: 1.0,
          bottom: 1.0,
        ),
        child: Row(
          children: [
            // ✅ チェックボタン
            IconButton(
              icon: Icon(
                task.status == "completed"
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
              ),
              onPressed: () => controller.toggleTask(task.id),
            ),

            // 📄 タイトル（左詰め）
            Expanded(
              child: Text(
                task.title,
                overflow: TextOverflow.ellipsis, // ✅ 省略記号で切り捨て
                maxLines: 1, // ✅ 1行に制限（改行させない）
                softWrap: false, // ✅ 明示的に改行禁止
                style: TextStyle(
                  fontSize: 16,
                  decoration: task.status == "completed"
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),

            // 🍅 予定/実績（予定がある場合のみ）
            if (pomodoro != null && planned > 0)
              Text(pomodoro.toDisplayString()),

            const SizedBox(width: 8),

            // ⏱ タイマーボタン（未完了で予定がある場合のみ）
            if (planned > 0 && task.status != "completed")
              IconButton(
                iconSize: 32,
                constraints: const BoxConstraints(minWidth: 56, minHeight: 56),
                padding: const EdgeInsets.all(8),
                icon: const Icon(Icons.play_arrow, color: Colors.green),
                onPressed: () => controller.startTimer(task),
              ),
          ],
        ),
      ),
    );
  }
}
