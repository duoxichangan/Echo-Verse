import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/error_handling.dart';
import 'ui/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  installGlobalErrorHandling();
  runApp(const ProviderScope(child: VirtualApp()));
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
      home: const HomePage(),
    );
  }
}
