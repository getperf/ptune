import 'package:flutter/material.dart';
import 'package:ptune/models/timer_phase.dart';
import 'package:ptune/views/components/show_confirm_dialog.dart';
import 'package:ptune/views/components/app_buttons.dart';

class PhaseButton extends StatelessWidget {
  final TimerPhase phase;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onReset;

  const PhaseButton({
    super.key,
    required this.phase,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final style = AppButtons.largePrimary(context);

    switch (phase) {
      case TimerPhase.ready:
        return Tooltip(
          message: 'タイマー開始',
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: style,
              autofocus: true,
              icon: const Icon(Icons.play_arrow),
              label: const Text('開始'),
              onPressed: () {
                Feedback.forTap(context);
                onStart();
              },
            ),
          ),
        );

      case TimerPhase.running:
        return Tooltip(
          message: '一時停止',
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: style,
              icon: const Icon(Icons.pause),
              label: const Text('ポーズ'),
              onPressed: () {
                Feedback.forTap(context);
                onPause();
              },
            ),
          ),
        );

      case TimerPhase.paused:
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            SizedBox(
              width: 220, // 端末に合わせて調整。等幅化したいなら Expanded を Row で使う
              child: ElevatedButton.icon(
                style: style,
                icon: const Icon(Icons.play_arrow),
                label: const Text('再開'),
                onPressed: () {
                  Feedback.forTap(context);
                  onResume();
                },
              ),
            ),
            SizedBox(
              width: 220,
              child: ElevatedButton.icon(
                style: style,
                icon: const Icon(Icons.stop),
                label: const Text('リセット'),
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'セッション停止',
                    message: '現在のセッションを停止しますか？',
                  );
                  if (context.mounted && confirmed == true) {
                    Feedback.forTap(context);
                    onReset();
                  }
                },
              ),
            ),
          ],
        );

      case TimerPhase.end:
        return const SizedBox.shrink();
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final style = AppButtons.largePrimary(context);
  //   switch (phase) {
  //     case TimerPhase.ready:
  //       return ElevatedButton(
  //         style: style,
  //         onPressed: onStart,
  //         child: const Text("▶ 開始"),
  //       );
  //     case TimerPhase.running:
  //       return ElevatedButton(
  //         style: style,
  //         onPressed: onPause,
  //         child: const Text("⏸ ポーズ"),
  //       );
  //     case TimerPhase.paused:
  //       return Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           ElevatedButton(
  //             style: style,
  //             onPressed: onResume,
  //             child: const Text("▶ 再開"),
  //           ),
  //           const SizedBox(width: 16),
  //           ElevatedButton(
  //             style: style,
  //             onPressed: () async {
  //               final confirmed = await showConfirmDialog(
  //                 context,
  //                 title: "セッション停止",
  //                 message: "現在のセッションを停止しますか？",
  //               );
  //               if (confirmed == true) {
  //                 onReset();
  //               }
  //             },
  //             child: const Text("⏹ リセット"),
  //           ),
  //         ],
  //       );
  //     case TimerPhase.end:
  //       return const SizedBox(); // エラー回避
  //   }
  // }
}
