import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/edit_task_controller.dart';
import '../providers/task_provider.dart';

class EditTaskView extends ConsumerStatefulWidget {
  const EditTaskView({super.key});

  @override
  ConsumerState<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends ConsumerState<EditTaskView> {
  int _tempPlanned = 0;
  late final TextEditingController _textController;
  late final EditTaskController controller;

  @override
  void initState() {
    super.initState();
    controller = EditTaskController(ref);
    final task = ref.read(selectedEditTaskProvider);
    _tempPlanned = task?.pomodoro?.planned ?? 0;
    _textController = TextEditingController(text: task?.title ?? "");
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final task = ref.watch(selectedEditTaskProvider);

    if (task == null) {
      return const Center(child: Text("タスクが選択されていません"));
    }

    final parentTask = task.parent != null
        ? ref.read(tasksProvider.notifier).findById(task.parent!)
        : null;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) return;

        controller.setTempTitle(_textController.text);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("タスクを編集"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final title = _textController.text;
              final planned = _tempPlanned;
              final navigator = Navigator.of(context);
              await controller.saveAll(title: title, planned: planned);
              if (mounted) navigator.pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (parentTask != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '親タスク: ${parentTask.title}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              Row(
                children: [
                  Checkbox(
                    value: task.status == "completed",
                    onChanged: (checked) {
                      if (checked != null) {
                        controller.updateCompleted(checked);
                      }
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(labelText: "タイトル"),
                      onChanged: (value) {
                        controller.setTempTitle(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("ポモドーロ数: "),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_tempPlanned > 0) _tempPlanned--;
                      });
                    },
                  ),
                  Text('$_tempPlanned 🍅'),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _tempPlanned++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
