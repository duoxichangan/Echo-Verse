import 'dart:math';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/memory/drift_memory_service.dart';
import 'package:virtual/app/proact/active_hours.dart';
import 'package:virtual/app/proact/default_scheduler.dart';
import 'package:virtual/app/proact/proactive_message_engine.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_persona_repo.dart';
import 'package:virtual/domain/contracts/notification_port.dart';
import 'package:virtual/domain/models/proactive_tier.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

class _FakeNotifications implements NotificationPort {
  final scheduled = <int>[];
  final canceled = <int>[];
  @override
  Future<void> schedule(int id, DateTime at, NotificationPayload payload) async {
    scheduled.add(id);
  }

  @override
  Future<void> cancel(int id) async {
    canceled.add(id);
  }
}

// 一个工作日下午（活跃时段内）的固定时刻。
final _now = DateTime(2026, 6, 17, 14, 0).millisecondsSinceEpoch;

void main() {
  final hasSqlite = _sqliteAvailable();

  group('ProactiveMessageEngine', () {
    late AppDatabase db;
    late DriftPersonaRepo personaRepo;
    late _FakeNotifications notifs;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      personaRepo = DriftPersonaRepo(db, nowMs: () => _now);
      notifs = _FakeNotifications();
    });
    tearDown(() async => db.close());

    ProactiveMessageEngine engine() => ProactiveMessageEngine(
          db: db,
          adapter: const MockAdapter(script: '在吗‹SEP›突然想你了'),
          personaRepo: personaRepo,
          memoryService: DriftMemoryService(db, nowMs: () => _now),
          scheduler: DefaultScheduler(
              activeHours: const ActiveHours(), dailyQuota: 5),
          notifications: notifs,
          activeHours: const ActiveHours(),
          nowMs: () => _now,
          rng: Random(42), // 固定种子，结果可重复
        );

    test('off 档不排期', () async {
      final id = await personaRepo.create(name: '小桃', personaJson: '{}');
      await personaRepo.setProactiveTier(id, ProactiveTier.off.index);
      await engine().scheduleNext(id);
      final rows = await db.select(db.scheduledProactives).get();
      expect(rows, isEmpty);
      expect(notifs.scheduled, isEmpty);
    }, skip: hasSqlite ? false : 'sqlite native 不可用');

    test('开启档位会预生成消息 + 落排期 + 排通知', () async {
      final id = await personaRepo.create(name: '小桃', personaJson: '{}');
      await personaRepo.setProactiveTier(id, ProactiveTier.normal.index);
      await engine().scheduleNext(id);

      final rows = await db.select(db.scheduledProactives).get();
      expect(rows.length, 1);
      expect(rows.first.content, contains('想你'));
      expect(rows.first.status, 'scheduled');
      expect(rows.first.scheduledAt, greaterThan(_now)); // 排在未来
      expect(notifs.scheduled.length, 1);
    }, skip: hasSqlite ? false : 'sqlite native 不可用');

    test('已有未投递排期则不重复排', () async {
      final id = await personaRepo.create(name: '小桃', personaJson: '{}');
      await personaRepo.setProactiveTier(id, ProactiveTier.normal.index);
      await engine().scheduleNext(id);
      await engine().scheduleNext(id); // 第二次应跳过

      final rows = await db.select(db.scheduledProactives).get();
      expect(rows.length, 1);
    }, skip: hasSqlite ? false : 'sqlite native 不可用');

    test('触发时刻落在活跃时段内', () async {
      final id = await personaRepo.create(name: '小桃', personaJson: '{}');
      await personaRepo.setProactiveTier(id, ProactiveTier.occasional.index);
      await engine().scheduleNext(id);

      final rows = await db.select(db.scheduledProactives).get();
      final at = DateTime.fromMillisecondsSinceEpoch(rows.first.scheduledAt);
      expect(const ActiveHours().isActiveAt(at), isTrue);
    }, skip: hasSqlite ? false : 'sqlite native 不可用');
  });
}
