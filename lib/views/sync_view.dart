import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ptune/constants/messages.dart';
import 'package:ptune/controllers/sync_controller.dart';
import 'package:ptune/providers/task_list_check_provider.dart';
import 'package:ptune/providers/task_provider.dart';
import 'package:ptune/routes/app_router.dart';
import 'package:ptune/services/common_task_service.dart';
import 'package:ptune/views/components/sync/sync_action_button.dart';

class SyncView extends ConsumerWidget {
  const SyncView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(syncControllerProvider);
    final taskListCheck = ref.watch(taskListCheckProvider);
    final taskService = ref.read(taskServiceProvider);
    final needsSync =
        taskService is CommonTaskService && taskService.hasUnSyncedLogs();

    // final needsSync = commonTaskService.unsyncedLog.hasUnSynced;
    final isEnabled = taskListCheck.maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('同期'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400), // ← 最大幅指定
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, // ← ボタン幅を揃える
              children: [
                if (needsSync)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      '未同期の変更があります。タスクの反映を実行してください。',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                SyncActionButton(
                  title: SyncLabels.initButton,
                  note: SyncLabels.initNote,
                  icon: Icons.download,
                  isEnabled: true,
                  isLoading: controller.isLoadingInit,
                  confirmTitle: '確認',
                  confirmMessage: SyncMessages.initConfirm,
                  onConfirmed: () =>
                      ref.read(syncControllerProvider).initializeToday(context),
                ),
                SyncActionButton(
                  title: SyncLabels.importButton,
                  note: SyncLabels.importNote,
                  icon: Icons.download,
                  isEnabled: isEnabled,
                  isLoading: controller.isLoadingImport,
                  confirmTitle: '確認',
                  confirmMessage: SyncMessages.importConfirm,
                  onConfirmed: () =>
                      ref.read(syncControllerProvider).importTasks(context),
                ),
                SyncActionButton(
                  title: SyncLabels.exportButton,
                  note: SyncLabels.exportNote,
                  icon: Icons.download,
                  isEnabled: isEnabled,
                  isLoading: controller.isLoadingExport,
                  confirmTitle: '確認',
                  confirmMessage: SyncMessages.exportConfirm,
                  onConfirmed: () =>
                      ref.read(syncControllerProvider).exportTasks(context),
                ),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () => context.go(RoutePaths.auth),
                  child: const Text("ログインし直す"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
