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

    test('未命中库的短标签降级成纯文字（不显示 [表情:] 穿帮）', () async {
      final out = await p.process(_stream('[表情:害羞]'), personaId: 1);
      expect(out.length, 1);
      expect(out.first.kind, RenderedKind.text);
      expect(out.first.content, '害羞'); // 降级成纯词，不带 [表情:]
    });

    test('未命中且像路径的标签直接丢弃（绝不输出路径）', () async {
      final out = await p.process(
          _stream('在的‹SEP›[表情:/data/app/st_123.png]'), personaId: 1);
      // 路径样标签被丢弃，只剩文本“在的”。
      expect(out.length, 1);
      expect(out.first.content, '在的');
    });

    test('全角冒号的 [表情：label] 也能解析', () async {
      final out = await p.process(_stream('[表情：微笑]'), personaId: 1);
      expect(out.first.kind, RenderedKind.sticker);
      expect(out.first.stickerPath, '/stickers/smile.png');
    });

    test('表情库对其它 persona 不可见（隔离）', () async {
      final out = await p.process(_stream('[表情:抱抱]'), personaId: 2);
      // persona 2 没有“抱抱”，降级成纯文字（不渲染图、不穿帮）。
      expect(out.first.kind, RenderedKind.text);
      expect(out.first.content, '抱抱');
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

    // ── 三个问题修复回归 ──────────────────────────────────

    test('句中表情被拆成独立的 sticker 消息（问题 2）', () async {
      final repo = InMemoryStickerRepo(perPersona: {
        1: {'开心': '/s/happy.png'},
      });
      final pp = OutputPostProcessorImpl(repo);
      // 表情夹在句子中间，没有分隔符。
      final out = await pp.process(_stream('好呀[表情:开心]那走吧'), personaId: 1);
      expect(out.length, 3);
      expect(out[0].kind, RenderedKind.text);
      expect(out[0].content, '好呀');
      expect(out[1].kind, RenderedKind.sticker);
      expect(out[1].stickerPath, '/s/happy.png');
      expect(out[2].kind, RenderedKind.text);
      expect(out[2].content, '那走吧');
    });

    test('没有 ‹SEP› 但有换行时按行分条（问题 3）', () async {
      final pp = OutputPostProcessorImpl(InMemoryStickerRepo());
      final out = await pp.process(_stream('在吗\n我在的\n你说'), personaId: 1);
      expect(out.length, 3);
      expect(out.map((m) => m.content), ['在吗', '我在的', '你说']);
    });

    test('展示剥掉 [记住:x] 标记，rawContent 保留供落库/MEM-02', () async {
      final pp = OutputPostProcessorImpl(InMemoryStickerRepo());
      final out = await pp.process(_stream('好的我记住啦[记住:用户喜欢爬山]'), personaId: 1);
      expect(out.length, 1);
      expect(out.first.content, '好的我记住啦'); // 展示无标记
      expect(out.first.rawContent, contains('[记住:用户喜欢爬山]')); // 落库保留
    });
  });
}
