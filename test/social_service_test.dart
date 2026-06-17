import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/memory/drift_memory_service.dart';
import 'package:virtual/app/proact/active_hours.dart';
import 'package:virtual/app/proact/default_scheduler.dart';
import 'package:virtual/app/social/default_social_service.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_persona_repo.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

const _now = 1700000000000;

void main() {
  final hasSqlite = _sqliteAvailable();

  group('DefaultSocialService', () {
    late AppDatabase db;
    late DriftPersonaRepo personaRepo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      personaRepo = DriftPersonaRepo(db, nowMs: () => _now);
      await personaRepo.create(
        name: '小桃',
        personaJson: '{"L2_style":{"emoji":"爱用🥺"}}',
      );
    });
    tearDown(() async => db.close());

    DefaultSocialService svc(String script, {ActiveHours? hours}) =>
        DefaultSocialService(
          db: db,
          adapter: MockAdapter(script: script, chunkDelay: Duration.zero),
          personaRepo: personaRepo,
          memoryService: DriftMemoryService(db, nowMs: () => _now),
          scheduler: DefaultScheduler(
            activeHours: hours ?? const ActiveHours(startHour: 0, endHour: 24),
            dailyQuota: 5,
          ),
          nowMs: () => _now,
        );

    test('buildOutwardPersona 存库', () async {
      await svc('{"tone":"阳光正能量","topics":["健身"],"style":"短句+emoji"}')
          .buildOutwardPersona(1);
      final p = await personaRepo.getPersona(1);
      expect(p?.outwardPersonaJson, contains('阳光正能量'));
    });

    test('maybePublish 生成朋友圈 + 挂等待互动回路', () async {
      // 全天活跃，配额足。脚本同时被对外人格推演和朋友圈生成复用。
      final m = await svc('今天去爬山啦，风景超好🌄').maybePublish(1);
      expect(m, isNotNull);
      expect(m!.content, contains('爬山'));

      final moments = await db.select(db.moments).get();
      expect(moments.length, 1);
      // 挂了"等待互动"开放回路
      final loops = await db.select(db.openLoops).get();
      expect(loops.any((l) => l.event.contains('朋友圈')), isTrue);
    });

    test('安静时段/超配额时不发（受调度约束 R1）', () async {
      // 活跃时段设为永不活跃（start==end 时段为空 → isActiveAt 恒假）。
      final m = await svc('内容',
              hours: const ActiveHours(startHour: 9, endHour: 9))
          .maybePublish(1);
      expect(m, isNull);
      expect((await db.select(db.moments).get()), isEmpty);
    });

    test('setLiked 点赞 → 登记私聊提起的开放回路（SOCIAL-03 高光）', () async {
      final m = await svc('发条朋友圈').maybePublish(1);
      // 清掉发布时挂的"等待互动"回路，只看点赞新增的。
      final before = (await db.select(db.openLoops).get()).length;

      await svc('x').setLiked(m!.id, true);

      final moment = await (db.select(db.moments)..where((x) => x.id.equals(m.id)))
          .getSingle();
      expect(moment.likedByUser, isTrue);
      final after = (await db.select(db.openLoops).get()).length;
      expect(after, before + 1); // 新增一个"点赞→私聊提起"回路
      final loops = await db.select(db.openLoops).get();
      expect(loops.any((l) => l.event.contains('点了赞')), isTrue);
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
