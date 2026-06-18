import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/app/proact/default_open_loop_engine.dart';
import 'package:virtual/app/proact/default_scheduler.dart';
import 'package:virtual/app/proact/proactive_bootstrap.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_persona_repo.dart';
import 'package:virtual/domain/contracts/notification_port.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

class _FakeNotifications implements NotificationPort {
  @override
  Future<void> schedule(int id, DateTime at, NotificationPayload payload) async {}
  @override
  Future<void> cancel(int id) async {}
}

const _now = 1700000000000;

void main() {
  final hasSqlite = _sqliteAvailable();

  group('ProactiveBootstrap 投递到点主动消息', () {
    late AppDatabase db;
    late DriftPersonaRepo personaRepo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      personaRepo = DriftPersonaRepo(db, nowMs: () => _now);
    });
    tearDown(() async => db.close());

    ProactiveBootstrap boot() => ProactiveBootstrap(
          db: db,
          engine: DefaultOpenLoopEngine(
            db: db,
            scheduler: DefaultScheduler(),
            notifications: _FakeNotifications(),
            nowMs: () => _now,
          ),
          momentFrequency: 0, // 不发朋友圈，聚焦主动消息投递
          nowMs: () => _now,
        );

    test('到点的排期被投递成 message 并标 delivered（分条变多行）', () async {
      final pid = await personaRepo.create(name: '小桃', personaJson: '{}');
      await db.into(db.scheduledProactives).insert(
            ScheduledProactivesCompanion.insert(
              personaId: pid,
              content: '在吗‹SEP›突然想你了',
              scheduledAt: _now - 1000, // 已到点
              createdAt: _now - 1000,
            ),
          );

      await boot().run();

      final msgs = await (db.select(db.messages)
            ..where((m) => m.personaId.equals(pid)))
          .get();
      expect(msgs.length, 2); // 两条分条各落一行
      expect(msgs.every((m) => m.isProactive), isTrue);
      expect(msgs.map((m) => m.content), containsAll(['在吗', '突然想你了']));

      final sched = await db.select(db.scheduledProactives).getSingle();
      expect(sched.status, 'delivered');
    }, skip: hasSqlite ? false : 'sqlite native 不可用');

    test('未到点的排期不投递', () async {
      final pid = await personaRepo.create(name: '小桃', personaJson: '{}');
      await db.into(db.scheduledProactives).insert(
            ScheduledProactivesCompanion.insert(
              personaId: pid,
              content: '还没到点',
              scheduledAt: _now + 3600 * 1000, // 一小时后
              createdAt: _now,
            ),
          );

      await boot().run();

      final msgs = await db.select(db.messages).get();
      expect(msgs, isEmpty);
      final sched = await db.select(db.scheduledProactives).getSingle();
      expect(sched.status, 'scheduled');
    }, skip: hasSqlite ? false : 'sqlite native 不可用');
  });
}
