import 'package:flutter/material.dart';

import '../home/home_page.dart';
import '../me/me_page.dart';
import '../moments/discover_page.dart';
import '../chat/wechat_theme.dart';

/// 应用主框架：底部 Tab（微信 / 发现 / 我），1:1 复刻微信主结构。
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    // 直接渲染当前页（切 Tab 即重建），保证发现页每次切入都刷新朋友圈。
    final pages = const [HomePage(), DiscoverPage(), MePage()];
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF7F7F7),
        selectedItemColor: WeChat.brand,
        unselectedItemColor: const Color(0xFF7A7A7A),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: '微信'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我'),
        ],
      ),
    );
  }
}
