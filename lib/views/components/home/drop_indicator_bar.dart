import 'package:flutter/material.dart';

class DropIndicatorBar extends StatelessWidget {
  final bool active;
  final bool asChild; // ← 新しく追加
  const DropIndicatorBar({
    super.key,
    required this.active,
    required this.asChild,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 6,
      margin: EdgeInsets.only(
        left: asChild ? 24 : 0, // ← 子用はインデントを追加
        right: 8,
        top: 1,
        bottom: 0,
      ),
      // margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: active ? Colors.blue : Colors.transparent, width: 4),
        ),
      ),
    );
  }
}
