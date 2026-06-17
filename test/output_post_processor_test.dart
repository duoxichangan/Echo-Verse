import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/app/chat/output_post_processor_impl.dart';
import 'package:virtual/data/repos/in_memory_sticker_repo.dart';
import 'package:virtual/domain/models/rendered_message.dart';

/// 把字符串包成原始文本流（模拟 ModelAdapter.chat 的产出）。
Stream<String> _stream(String s, {int chunk = 3}) async* {
  for (var i = 0; i < s.length; i += chunk) {
    yield s.substring(i, (i + chunk).clamp(0, s.length));
  }
}

void main() {
  group('OutputPostProcessorImpl', () {
    // 表情库：persona 1 有“抱抱”，全局有“微笑”。
    final repo = InMemoryStickerRepo(
      global: {'微笑': '/stickers/smile.png'},
      perPersona: {
        1: {'抱抱': '/stickers/hug.png'},
      },
    );
    final p = OutputPostProcessorImpl(repo);

    test('按 ‹SEP› 分条，逐条变成 text 消息', () async {
      final out = await p.process(_stream('嗯嗯‹SEP›我在的‹SEP›你说'), personaId: 1);
      expect(out.length, 3);
      expect(out.every((m) => m.kind == RenderedKind.text), isTrue);
      expect(out.map((m) => m.content), ['嗯嗯', '我在的', '你说']);
    });

    test('无分隔符时整段当作一条（R5 兜底）', () async {
      final out = await p.process(_stream('就一段普通的话没有分隔'), personaId: 1);
      expect(out.length, 1);
      expect(out.first.content, '就一段普通的话没有分隔');
    });

    test('每条去掉首尾空白、空条被丢弃', () async {
      final out = await p.process(_stream('  你好 ‹SEP›  ‹SEP› 在吗 '), personaId: 1);
      expect(out.map((m) => m.content), ['你好', '在吗']);
    });

    test('命中库的 [表情:label] 渲染为 sticker（含人格专属与全局）', () async {
      final out = await p.process(_stream('[表情:抱抱]‹SEP›[表情:微笑]'), personaId: 1);
      expect(out.length, 2);
      expect(out[0].kind, RenderedKind.sticker);
      expect(out[0].stickerPath, '/stickers/hug.png');
      expect(out[1].kind, RenderedKind.sticker);
      expect(out[1].stickerPath, '/stickers/smile.png');
    });

    test('未命中库的表情标记保留为普通文本（不丢语义）', () async {
      final out = await p.process(_stream('[表情:不存在的]'), personaId: 1);
      expect(out.length, 1);
      expect(out.first.kind, RenderedKind.text);
      expect(out.first.content, '[表情:不存在的]');
    });

    test('全角冒号的 [表情：label] 也能解析', () async {
      final out = await p.process(_stream('[表情：微笑]'), personaId: 1);
      expect(out.first.kind, RenderedKind.sticker);
      expect(out.first.stickerPath, '/stickers/smile.png');
    });

    test('表情库对其它 persona 不可见（隔离）', () async {
      final out = await p.process(_stream('[表情:抱抱]'), personaId: 2);
      // persona 2 没有“抱抱”，落回文本。
      expect(out.first.kind, RenderedKind.text);
      expect(out.first.content, '[表情:抱抱]');
    });

    test('空流 / 纯空白 → 空列表', () async {
      expect(await p.process(_stream(''), personaId: 1), isEmpty);
      expect(await p.process(_stream('   ‹SEP›  '), personaId: 1), isEmpty);
    });

    test('首条带思考延迟、长条延迟更大、且夹在上下限内', () async {
      final pp = OutputPostProcessorImpl(
        InMemoryStickerRepo(),
        msPerChar: 100,
        minDelayMs: 300,
        maxDelayMs: 2000,
        thinkingDelayMs: 500,
      );
      final out = await pp.process(
        _stream('一二三‹SEP›四'),
        personaId: 1,
      );
      // 首条 3 字 ×100=300，+思考500 = 800。
      expect(out[0].delayMs, 800);
      // 次条 1 字 ×100=100 < min(300) → 300。
      expect(out[1].delayMs, 300);
    });

    test('总延迟被压缩到上限内', () async {
      final pp = OutputPostProcessorImpl(
        InMemoryStickerRepo(),
        msPerChar: 100,
        minDelayMs: 100,
        maxDelayMs: 5000,
        thinkingDelayMs: 0,
        maxTotalDelay: 1000,
      );
      // 五条各约 500ms，累计远超 1000ms 上限。
      final out = await pp.process(
        _stream('一二三四五‹SEP›一二三四五‹SEP›一二三四五‹SEP›一二三四五'),
        personaId: 1,
      );
      final total = out.fold<int>(0, (s, m) => s + m.delayMs);
      expect(total, lessThanOrEqualTo(1000));
    });
  });
}
