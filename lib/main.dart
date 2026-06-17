import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/di/providers.dart';
import 'app/error_handling.dart';
import 'app/proact/proactive_bootstrap.dart';
import 'ui/shell/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  installGlobalErrorHandling();

  // 用显式容器，便于启动后跑主动性补发对账。
  final container = ProviderContainer();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const VirtualApp(),
  ));

  // 启动补发对账（PROACT-03）：到点未处理的开放回路补发/取消。
  // fire-and-forget——失败不影响 UI。
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final settings = await container.read(settingsProvider.future);
      final social = await container.read(socialServiceProvider.future);
      final bootstrap = ProactiveBootstrap(
        db: container.read(databaseProvider),
        engine: container.read(openLoopEngineProvider),
        social: social,
        momentFrequency: settings.momentFrequency,
      );
      await bootstrap.run();
    } catch (_) {/* 主动性补发失败不影响主流程 */}
  });
}

class VirtualApp extends StatelessWidget {
  const VirtualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '虚拟数字人',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF07C160)),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}
