import 'package:flutter/material.dart';
import 'package:ptune/providers/home_controller_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTaskForm extends ConsumerStatefulWidget {
  const AddTaskForm({super.key});

  @override
  ConsumerState<AddTaskForm> createState() => _AddTaskFormState();
}

// class AddTaskForm extends StatefulWidget {
//   const AddTaskForm({super.key});

//   @override
//   State<AddTaskForm> createState() => _AddTaskFormState();
// }

// class _AddTaskFormState extends State<AddTaskForm> {
class _AddTaskFormState extends ConsumerState<AddTaskForm> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  int _tomatoIndex = 0;

  final _tomatoLabels = [
    '-',
    '🍅x1',
    '🍅x2',
    '🍅x3',
    '🚫',
    '🚫🍅x1',
    '🚫🍅x2',
    '🚫🍅x3',
  ];

  void _cycleTomato() {
    setState(() {
      _tomatoIndex = (_tomatoIndex + 1) % _tomatoLabels.length;
    });
  }

  void _submit() async {
    final homeController = ref.read(homeControllerProvider(context));
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final note = _tomatoLabels[_tomatoIndex];
    try {
      await homeController.submitTask(title, note);
      if (!mounted) return;
      _controller.clear();
      setState(() => _tomatoIndex = 0);
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('登録失敗: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          // 入力フィールド
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'タスクを入力...',
              ),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: 8),
          // 🍅ボタン
          SizedBox(
            width: 72, // 実際の最大ラベル幅に見合う値に縮小
            child: ElevatedButton(
              onPressed: _cycleTomato,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              ),
              child: Text(
                _tomatoLabels[_tomatoIndex],
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 登録ボタン（省略可）
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'タスクを追加',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
