import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/app/proact/default_open_loop_engine.dart';
import 'package:virtual/app/proact/default_scheduler.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/domain/contracts/notification_port.dart';
import 'package:virtual/domain/models/open_loop.dart' as dom;

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

/// 记录调用的假通知端口。
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

const _now = 1700000000000;

void main() {
  final hasSqlite = _sqliteAvailable();

  group('DefaultOpenLoopEngine', () {
    late AppDatabase db;
    late _FakeNotifications notif;
    late DefaultOpenLoopEngine engine;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      notif = _FakeNotifications();
      engine = DefaultOpenLoopEngine(
        db: db,
        scheduler: DefaultScheduler(dailyQuota: 10),
        notifications: notif,
        nowMs: () => _now,
      );
      await db.into(db.personas).insert(PersonasCompanion.insert(
            name: '小桃',
            personaJson: '{}',
            personaJsonInitial: '{}',
            createdAt: _now,
            updatedAt: _now,
          ));
    });
    tearDown(() async => db.close());

    Future<int> addLoop({
      required String event,
      required String triggerType,
      int? triggerAt,
      String status = 'pending',
    }) {
      return db.into(db.openLoops).insert(OpenLoopsCompanion.insert(
            personaId: 1,
            event: event,
            plannedAction: '关心地问',
            triggerType: triggerType,
            triggerAt: Value(triggerAt),
            status: Value(status),
            createdAt: _now,
          ));
    }

    dom.OpenLoop loopOf(int id, String event, int triggerAt) => dom.OpenLoop(
          id: id,
          personaId: 1,
          event: event,
          plannedAction: '关心地问',
          triggerType: dom.LoopTriggerType.clock,
          triggerAt: triggerAt,
          status: dom.LoopStatus.pending,
        );

    test('register 钟点型 → 预约通知（活跃时段内）', () async {
      // 活跃时段（白天）的时间戳。
      final at = DateTime(2026, 6, 17, 14).millisecondsSinceEpoch;
      final id = await addLoop(event: '明天面试', triggerType: 'clock', triggerAt: at);
      await engine.register(loopOf(id, '明天面试', at));
      expect(notif.scheduled, contains(id));
    });

    test('processPending 扫描并预约所有 pending 钟点回路', () async {
      final at = DateTime(2026, 6, 17, 15).millisecondsSinceEpoch;
      await addLoop(event: '周五体检', triggerType: 'clock', triggerAt: at);
      await addLoop(event: '随口说说', triggerType: 'event'); // 非钟点，不预约
      await engine.processPending(1);
      expect(notif.scheduled.length, 1);
    });

    test('reconcile：事件已被后续对话提及 → 取消不发（R2）', () async {
      final at = DateTime(2026, 6, 17, 14).millisecondsSinceEpoch;
      final id = await addLoop(event: '今晚汇报', triggerType: 'clock', triggerAt: at);
      // 用户后来自己说了汇报结果。
      await db.into(db.messages).insert(MessagesCompanion.insert(
            personaId: 1,
            sender: 'user',
            content: '汇报顺利结束啦',
            createdAt: _now + 1000,
          ));
      final should = await engine.reconcile(loopOf(id, '今晚汇报', at));
      expect(should, isFalse); // 已提及，不发
      expect(notif.canceled, contains(id));
      // 状态置 closed
      final row = await (db.select(db.openLoops)..where((l) => l.id.equals(id))).getSingle();
      expect(row.status, 'closed');
    });

    test('reconcile：未提及 → 仍应触发', () async {
      final at = DateTime(2026, 6, 17, 14).millisecondsSinceEpoch;
      final id = await addLoop(event: '周六爬山', triggerType: 'clock', triggerAt: at);
      await db.into(db.messages).insert(MessagesCompanion.insert(
            personaId: 1,
            sender: 'user',
            content: '今天天气真好',
            createdAt: _now + 1000,
          ));
      final should = await engine.reconcile(loopOf(id, '周六爬山', at));
      expect(should, isTrue);
    });

    test('close / expire 更新状态', () async {
      final at = DateTime(2026, 6, 17, 14).millisecondsSinceEpoch;
      final id = await addLoop(event: '看牙', triggerType: 'clock', triggerAt: at);
      await engine.close(loopOf(id, '看牙', at));
      var row = await (db.select(db.openLoops)..where((l) => l.id.equals(id))).getSingle();
      expect(row.status, 'closed');

      final id2 = await addLoop(event: '取快递', triggerType: 'clock', triggerAt: at);
      await engine.expire(loopOf(id2, '取快递', at));
      row = await (db.select(db.openLoops)..where((l) => l.id.equals(id2))).getSingle();
      expect(row.status, 'expired');
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
