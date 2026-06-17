import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/open_loop_engine.dart';
import '../../domain/models/open_loop.dart' as domain;

/// 启动补发对账（手册 PROACT-03 / 说明书 §4.6）。
///
/// App 启动时跑一次：
///  1. 预约未来的 pending 钟点回路（processPending）；
///  2. 对已到点但还没处理的回路做对账（reconcile）——已被提及则取消，
///     否则补发一条主动消息落库（简化：用 plannedAction 文本；
///     有 key 时未来可升级为按人设 LLM 生成，§8.4）。
///
/// 绝不漏、也绝不穿帮（R2）。
class ProactiveBootstrap {
  final AppDatabase db;
  final OpenLoopEngine engine;
  final int Function() nowMs;

  ProactiveBootstrap({
    required this.db,
    required this.engine,
    int Function()? nowMs,
  }) : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  Future<void> run() async {
    final personas = await db.select(db.personas).get();
    for (final p in personas) {
      await engine.processPending(p.id); // 预约未来的 pending 钟点回路
      await _catchUp(p.id); // 补发到点未处理的
    }
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
