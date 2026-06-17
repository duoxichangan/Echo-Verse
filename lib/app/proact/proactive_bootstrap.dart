import 'dart:math';

import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/open_loop_engine.dart';
import '../../domain/contracts/social_service.dart';
import '../../domain/models/open_loop.dart' as domain;

/// 启动补发对账（手册 PROACT-03 / 说明书 §4.6）。
///
/// App 启动时跑一次：
///  1. 预约未来的 pending 钟点回路（processPending）；
///  2. 对已到点但还没处理的回路做对账（reconcile）——已被提及则取消，
///     否则补发一条主动消息落库；
///  3. 按「朋友圈活跃度」概率，让数字人自发朋友圈（受调度作息/配额约束）。
///
/// 绝不漏、也绝不穿帮（R2）。
class ProactiveBootstrap {
  final AppDatabase db;
  final OpenLoopEngine engine;
  final SocialService? social;

  /// 朋友圈自发活跃度 0–100（来自 settings.momentFrequency）。
  final int momentFrequency;

  /// 同一数字人两条自发朋友圈的最小间隔（小时），避免一启动连发。
  final int momentMinGapHours;

  final int Function() nowMs;
  final Random _rng;

  ProactiveBootstrap({
    required this.db,
    required this.engine,
    this.social,
    this.momentFrequency = 30,
    this.momentMinGapHours = 6,
    int Function()? nowMs,
    Random? rng,
  })  : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch),
        _rng = rng ?? Random();

  Future<void> run() async {
    final personas = await db.select(db.personas).get();
    for (final p in personas) {
      await engine.processPending(p.id); // 预约未来的 pending 钟点回路
      await _catchUp(p.id); // 补发到点未处理的
      await _maybePostMoment(p.id); // 按概率自发朋友圈
    }
  }

  /// 按活跃度概率自发朋友圈：距上次发够久 + 命中概率 + 受调度约束。
  Future<void> _maybePostMoment(int personaId) async {
    final svc = social;
    if (svc == null || momentFrequency <= 0) return;

    // 距上次发圈不足 momentMinGapHours 则跳过。
    final last = await (db.select(db.moments)
          ..where((m) => m.personaId.equals(personaId))
          ..orderBy([(m) => OrderingTerm.desc(m.postedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (last != null) {
      final gapMs = nowMs() - last.postedAt;
      if (gapMs < momentMinGapHours * 3600 * 1000) return;
    }

    // 命中概率（momentFrequency/100）。
    if (_rng.nextInt(100) >= momentFrequency) return;

    // 实际发布受调度中枢作息/配额约束（maybePublish 内部判定）。失败静默。
    try {
      await svc.maybePublish(personaId);
    } catch (_) {/* 发圈失败不影响启动 */}
  }

  /// 补发对账：到点未闭环的 pending 回路 → reconcile → 未提及则补发消息。
  Future<void> _catchUp(int personaId) async {
    final now = nowMs();
    final due = await (db.select(db.openLoops)
          ..where((l) =>
              l.personaId.equals(personaId) &
              l.status.equals('pending') &
              l.triggerAt.isNotNull() &
              l.triggerAt.isSmallerOrEqualValue(now)))
        .get();

    for (final r in due) {
      final loop = _toDomain(r);
      final shouldFire = await engine.reconcile(loop);
      if (!shouldFire) continue; // 已提及/闭环，reconcile 已置 closed

      // 补发一条主动消息（简化文本版）。
      final text = r.plannedAction.isEmpty ? '在想你～' : r.plannedAction;
      await db.into(db.messages).insert(MessagesCompanion.insert(
            personaId: personaId,
            sender: 'persona',
            content: text,
            type: const Value('text'),
            isProactive: const Value(true),
            createdAt: now,
          ));
      await engine.close(loop);
    }
  }

  domain.OpenLoop _toDomain(OpenLoop r) => domain.OpenLoop(
        id: r.id,
        personaId: r.personaId,
        event: r.event,
        plannedAction: r.plannedAction,
        triggerType: switch (r.triggerType) {
          'clock' => domain.LoopTriggerType.clock,
          'recurring' => domain.LoopTriggerType.recurring,
          _ => domain.LoopTriggerType.event,
        },
        triggerAt: r.triggerAt,
        importance: r.importance,
        status: domain.LoopStatus.pending,
        notificationId: r.notificationId,
      );
}
