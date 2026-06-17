import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/ui/chat/chat_bubble.dart';

void main() {
  // 气泡是纯 widget（不碰 DB / 不依赖真异步 I/O），适合 widget 单测。
  // HomePage / ChatPage 涉及真异步 drift 查询，在 fake-async 的 widget 测试
  // 环境下不会推进完成，留待真机 / 集成测试覆盖（逻辑闭环已由 chat_engine_test 验证）。
  group('ChatBubble 渲染', () {
    testWidgets('文本气泡显示内容', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ChatBubble(data: ChatBubbleData.text('在吗', isSelf: false)),
        ),
      ));
      expect(find.text('在吗'), findsOneWidget);
    });

    testWidgets('自己/对方气泡都能渲染', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: Column(children: [
            ChatBubble(data: ChatBubbleData.text('我说的', isSelf: true)),
            ChatBubble(data: ChatBubbleData.text('对方说的', isSelf: false)),
          ]),
        ),
      ));
      expect(find.text('我说的'), findsOneWidget);
      expect(find.text('对方说的'), findsOneWidget);
    });

    testWidgets('坏路径的表情气泡兜底显示占位图标', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ChatBubble(
            data: ChatBubbleData.sticker('/no/such/file.png', isSelf: false),
          ),
        ),
      ));
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
    });
  });
}

