import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../main.dart' show runProactiveBootstrap;
import '../home/home_page.dart';
import '../me/me_page.dart';
import '../moments/discover_page.dart';
import '../chat/wechat_theme.dart';

/// 应用主框架：底部 Tab（微信 / 发现 / 我），1:1 复刻微信主结构。
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 回前台：跑一次主动性对账（投递到点主动消息 + 重排下一条）。
    if (state == AppLifecycleState.resumed) {
      runProactiveBootstrap(ProviderScope.containerOf(context, listen: false));
    }
  }

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
              icon: Icon(Icons.chat_bubble), label: 'Ta们'),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '我'),
        ],
      ),
    );
  }
}
