import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ptune/models/my_task_list.dart';
import 'package:ptune/utils/env_config.dart';

final taskListsProvider =
    StateNotifierProvider<TaskListsNotifier, Map<String, MyTaskList>>((ref) {
  return TaskListsNotifier();
});

class TaskListsNotifier extends StateNotifier<Map<String, MyTaskList>> {
  TaskListsNotifier() : super({});

  void setAll(Map<String, MyTaskList> lists) => state = lists;
  void add(MyTaskList list) => state = {...state, list.id: list};
  void remove(String id) => state = {...state}..remove(id);
}

// final selectedTaskListProvider = StateProvider<MyTaskList?>((ref) => null);

final selectedTaskListProvider = StateProvider<MyTaskList?>((ref) {
  final isDemo = EnvConfig.isDemo;
  if (isDemo) {
    return MyTaskList(id: 'demo-list-1', title: 'Today');
  }
  return null;
});
