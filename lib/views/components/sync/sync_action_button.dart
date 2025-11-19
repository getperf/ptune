import 'package:flutter/material.dart';
import 'package:ptune/views/components/show_confirm_dialog.dart';

class SyncActionButton extends StatelessWidget {
  final String title;
  final String note;
  final IconData icon;
  final bool isEnabled; // ← AsyncValue<bool> → bool に変更
  final bool isLoading;
  final String confirmTitle;
  final String confirmMessage;
  final VoidCallback onConfirmed;

  const SyncActionButton({
    super.key,
    required this.title,
    required this.note,
    required this.icon,
    required this.isEnabled,
    required this.isLoading,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: isEnabled && !isLoading
              ? () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: confirmTitle,
                    message: confirmMessage,
                  );
                  if (confirmed == true) onConfirmed();
                }
              : null,
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(),
                )
              : Icon(icon),
          label: Text(title),
        ),
        if (note.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(note, style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }
}
