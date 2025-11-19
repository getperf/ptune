import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});
  // const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'ホーム'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'タイマー'),
        BottomNavigationBarItem(icon: Icon(Icons.sync), label: '同期'),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: '認証'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 0:
            context.push('/home');
            break;
          case 1:
            context.push('/timer');
            break;
          case 2:
            context.push('/sync');
            break;
          case 3:
            context.push('/auth');
            break;
          case 4:
            context.push('/settings');
            break;
        }
      },
    );
  }
}
