import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/di/providers.dart';
import 'app/error_handling.dart';
import 'app/proact/local_notification_port.dart';
import 'app/proact/proactive_bootstrap.dart';
import 'ui/chat/chat_page.dart';
import 'ui/shell/main_shell.dart';

/// 全局导航 key：通知点开后从任意状态路由到对应聊天页。
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  installGlobalErrorHandling();

  // 用显式容器，便于启动后跑主动性补发对账。
  // 覆盖通知端口，注入点击路由回调（payload=personaId）。
  final container = ProviderContainer(
    overrides: [
      notificationPortProvider.overrideWithValue(
        LocalNotificationPort(onTap: (payload) => _onNotificationTap(payload)),
      ),
    ],
  );
  _container = container;

  runApp(UncontrolledProviderScope(
    container: container,
    child: VirtualApp(navigatorKey: navigatorKey),
  ));

  // 启动补发对账（PROACT-03）：到点未处理的开放回路 + 投递到点主动消息 + 重排。
  // fire-and-forget——失败不影响 UI。
  WidgetsBinding.instance.addPostFrameCallback((_) {
    runProactiveBootstrap(container);
  });
}

/// 持有容器引用，供通知回调与生命周期对账复用。
ProviderContainer? _container;

/// 跑一次主动性对账（启动 + 回前台共用）。
Future<void> runProactiveBootstrap(ProviderContainer container) async {
  try {
    final settings = await container.read(settingsProvider.future);
    final social = await container.read(socialServiceProvider.future);
    final messageEngine =
        await container.read(proactiveMessageEngineProvider.future);
    final bootstrap = ProactiveBootstrap(
      db: container.read(databaseProvider),
      engine: container.read(openLoopEngineProvider),
      social: social,
      messageEngine: messageEngine,
      momentFrequency: settings.momentFrequency,
    );
    await bootstrap.run();
  } catch (_) {/* 主动性补发失败不影响主流程 */}
}

/// 通知点开：payload 为 "personaId"（主动消息）或 "personaId:loopId"（开放回路）。
/// 先跑一次对账保证消息已落库，再路由到对应聊天页。
Future<void> _onNotificationTap(String? payload) async {
  final container = _container;
  if (payload == null || container == null) return;
  final personaId = int.tryParse(payload.split(':').first);
  if (personaId == null) return;

  // 先对账：把到点的预生成主动消息投递成正式消息。
  await runProactiveBootstrap(container);

  final persona = await container.read(personaRepoProvider).getPersona(personaId);
  if (persona == null) return;
  navigatorKey.currentState?.push(MaterialPageRoute(
    builder: (_) => ChatPage(
      personaId: persona.id,
      personaName: persona.name,
      peerAvatarPath: persona.avatarPath,
    ),
  ));
}

class VirtualApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const VirtualApp({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EchoVerse',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // 微信风格统一灰调：所有表面均为 #EDEDED，仅绿色图标做点缀
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF07C160),       // 微信绿（仅图标/强调）
          onPrimary: Colors.white,
          surface: Color(0xFFEDEDED),       // 卡片/弹出菜单/下拉框 → 微信灰
          onSurface: Color(0xFF191919),     // 主文字色
          surfaceContainerHighest: Color(0xFFF7F7F7),
          outline: Color(0xFFD9D9D9),       // 分割线
        ),
        scaffoldBackgroundColor: const Color(0xFFEDEDED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFEDEDED),
          foregroundColor: Color(0xFF191919),
          surfaceTintColor: Colors.transparent,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFFEDEDED),
          surfaceTintColor: Colors.transparent,
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFFEDEDED),
          surfaceTintColor: Colors.transparent,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFFEDEDED),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F7F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
          ),
        ),
        // Material 3 下拉菜单 → 微信灰
        menuTheme: const MenuThemeData(
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Color(0xFFEDEDED)),
            surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}
