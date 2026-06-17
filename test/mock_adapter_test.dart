import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/domain/models/chat_message.dart';

void main() {
  group('MockAdapter', () {
    test('流式输出拼回完整脚本', () async {
      const adapter = MockAdapter(
        script: '你好世界',
        chunkDelay: Duration.zero,
      );
      final buffer = StringBuffer();
      await for (final chunk in adapter.chat(system: '', messages: [])) {
        buffer.write(chunk);
      }
      expect(buffer.toString(), '你好世界');
    });

    test('scriptFor 可按输入动态返回', () async {
      final adapter = MockAdapter(
        chunkDelay: Duration.zero,
        scriptFor: (msgs) => '收到:${msgs.last.content}',
      );
      final out = await adapter
          .chat(system: '', messages: [Msg.user('在吗')])
          .join();
      expect(out, '收到:在吗');
    });
  });
}
