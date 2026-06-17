import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/chat/chat_engine_impl.dart';
import 'package:virtual/app/chat/context_assembler_impl.dart';
import 'package:virtual/app/chat/output_post_processor_impl.dart';
import 'package:virtual/app/memory/drift_memory_service.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_persona_repo.dart';
import 'package:virtual/data/repos/in_memory_sticker_repo.dart';
import 'package:virtual/domain/models/rendered_message.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

const _now = 1000000000000;

void main() {
  final hasSqlite = _sqliteAvailable();

  group('对话闭环 (CHAT-01+02+03)', () {
    late AppDatabase db;
    late int counter; // 让落库时间戳单调递增，保证最近消息顺序稳定

    /// 构造一个 engine，adapter 用给定脚本的 MockAdapter。
    ChatEngineImpl engineWith(String script) {
      final repo = InMemoryStickerRepo(perPersona: {
        1: {'抱抱': '/stickers/hug.png'},
      });
      final assembler = ContextAssemblerImpl(
        personaRepo: DriftPersonaRepo(db, nowMs: () => _now),
        memoryService: DriftMemoryService(db, nowMs: () => _now),
        stickerRepo: repo,
      );
      return ChatEngineImpl(
        db: db,
        assembler: assembler,
        adapter: MockAdapter(script: script, chunkDelay: Duration.zero),
        postProcessor: OutputPostProcessorImpl(repo),
        nowMs: () => _now + (counter++), // 单调
        honorDelays: false, // 测试不等真实延迟
      );
    }

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      counter = 0;
      await DriftPersonaRepo(db, nowMs: () => _now).create(
        name: '团子',
        personaJson: '{"L2_style":{"multi_msg":true}}',
        userAlias: '笨蛋',
      );
    });

    tearDown(() async => db.close());

    test('发一句 → 收到分条回复流', () async {
      final engine = engineWith('嗯嗯‹SEP›我在的‹SEP›你说');
      final out = await engine.send(1, '在吗').toList();

      expect(out.length, 3);
      expect(out.map((m) => m.content), ['嗯嗯', '我在的', '你说']);
      expect(out.every((m) => m.kind == RenderedKind.text), isTrue);
    });

    test('回复里的 [表情:抱抱] 渲染为 sticker', () async {
      final engine = engineWith('别怕笨蛋‹SEP›[表情:抱抱]');
      final out = await engine.send(1, '好紧张').toList();

      expect(out.length, 2);
      expect(out[0].kind, RenderedKind.text);
      expect(out[1].kind, RenderedKind.sticker);
      expect(out[1].stickerPath, '/stickers/hug.png');
    });

    test('用户消息与数字人分条回复都落库', () async {
      final engine = engineWith('好呀‹SEP›[表情:抱抱]');
      await engine.send(1, '一起出去玩吧').toList();

      final rows = await (db.select(db.messages)
            ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
          .get();

      // 1 条 user + 2 条 persona
      expect(rows.length, 3);
      expect(rows[0].sender, 'user');
      expect(rows[0].content, '一起出去玩吧');
      expect(rows[1].sender, 'persona');
      expect(rows[1].content, '好呀');
      expect(rows[1].type, 'text');
      expect(rows[2].sender, 'persona');
      expect(rows[2].type, 'sticker');
      expect(rows[2].content, '/stickers/hug.png');
    });

    test('多轮对话：历史原文带进上下文（含上一轮回复）', () async {
      // 第一轮，回复固定。
      await engineWith('记住啦[记住:用户喜欢爬山]').send(1, '我喜欢爬山').toList();

      // 第二轮：用会读取历史的 MockAdapter，验证组装把历史原文带上了。
      final repo = InMemoryStickerRepo();
      final engine = ChatEngineImpl(
        db: db,
        assembler: ContextAssemblerImpl(
          personaRepo: DriftPersonaRepo(db, nowMs: () => _now),
          memoryService: DriftMemoryService(db, nowMs: () => _now),
          stickerRepo: repo,
        ),
        adapter: MockAdapter(
          chunkDelay: Duration.zero,
          scriptFor: (msgs) {
            // 历史里应能看到上一轮的用户原文。
            final joined = msgs.map((m) => m.content).join('|');
            return joined.contains('我喜欢爬山') ? '嗯！' : '没看到历史';
          },
        ),
        postProcessor: OutputPostProcessorImpl(repo),
        nowMs: () => _now + (counter++),
        honorDelays: false,
      );
      final out = await engine.send(1, '还记得我爱啥不').toList();
      expect(out.single.content, '嗯！');
    });

    test('honorDelays=false 时不阻塞（瞬时完成）', () async {
      final engine = engineWith('a‹SEP›b‹SEP›c‹SEP›d');
      final out = await engine.send(1, 'hi').toList();
      expect(out.length, 4);
      // 不对 delayMs 断言为 0（后处理仍会计算），只验证流能跑完不卡。
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
