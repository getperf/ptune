import 'package:flutter/material.dart';

class AppButtons {
  static ButtonStyle largePrimary(BuildContext context) {
    return ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(56), // 高さを確保（幅は親で制御）
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      // ここで色や影のポリシーを統一してもOK
    );
  }
}
