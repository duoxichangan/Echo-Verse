import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/notification_port.dart';
import '../../domain/contracts/open_loop_engine.dart';
import '../../domain/contracts/scheduler.dart';
import '../../domain/models/open_loop.dart' as domain;

/// 开放回路引擎实现（手册 PROACT-02 / 说明书 §7.3）。
///
/// 把记忆里登记的「待回访的事」变成到点的主动关心：
///  - register：钟点型→向 Scheduler 申请额度→NotificationPort 预约到点弹；
///    事件型/周期型→留表，等下次相关对话触发（MVP 不自动定时）。
///  - reconcile：触发前对账（R2）——若该事已在后续对话被提及/闭环，则取消不发。
///  - close / expire：闭环（沉淀为事实由调用方接 MEM-02）/ 过期淡出。
///
/// Scheduler/NotificationPort 通过契约注入，可 mock 离线单测。
class DefaultOpenLoopEngine implements OpenLoopEngine {
  final AppDatabase db;
  final Scheduler scheduler;
  final NotificationPort notifications;
  final int Function() nowMs;

  DefaultOpenLoopEngine({
    required this.db,
    required this.scheduler,
    required this.notifications,
    int Function()? nowMs,
  }) : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  @override
  Future<void> register(domain.OpenLoop loop) async {
    if (loop.triggerType == domain.LoopTriggerType.clock &&
        loop.triggerAt != null) {
      final at = DateTime.fromMillisecondsSinceEpoch(loop.triggerAt!);
      final decision =
          scheduler.requestProactiveSlot(ProactiveType.message, at);
      // 安静时段/超配额 → 顺延或暂不预约（留 pending，下次再试）。
      final fireAt = decision.allow
          ? at
          : (decision.suggestedTime != null
              ? DateTime.fromMillisecondsSinceEpoch(decision.suggestedTime!)
              : null);
      if (fireAt == null) return; // 超配额，保持 pending 等下次

      await notifications.schedule(
        loop.id,
        fireAt,
        NotificationPayload(
          personaId: loop.personaId,
          openLoopId: loop.id,
          title: '有人惦记你',
          body: loop.plannedAction.isEmpty ? '在想你' : loop.plannedAction,
        ),
      );
      await _setNotificationId(loop.id, loop.id);
    }
    // 事件型/周期型：留表 pending，由对话话题匹配触发（后续接 CHAT）。
  }

  @override
  Future<bool> reconcile(domain.OpenLoop loop) async {
    // 触发前对账（R2）：该事件关键词是否已在登记后的对话里被提及？
    final mentioned = await _mentionedAfter(loop);
    if (mentioned) {
      await notifications.cancel(loop.id);
      await _setStatus(loop.id, 'closed');
      return false; // 已提及/闭环，不再发
    }
    return true; // 仍应触发
  }

  @override
  Future<void> close(domain.OpenLoop loop) async {
    await notifications.cancel(loop.id);
    await _setStatus(loop.id, 'closed');
  }

  @override
  Future<void> expire(domain.OpenLoop loop) async {
    await notifications.cancel(loop.id);
    await _setStatus(loop.id, 'expired');
  }

  /// 扫描某 persona 的 pending 钟点型回路并逐个 register（启动/每轮后调用）。
  @override
  Future<void> processPending(int personaId) async {
    final rows = await (db.select(db.openLoops)
          ..where((l) =>
              l.personaId.equals(personaId) &
              l.status.equals('pending') &
              l.triggerType.equals('clock') &
              l.triggerAt.isNotNull()))
        .get();
    for (final r in rows) {
      await register(_toDomain(r));
    }
  }

  // ── 内部 ───────────────────────────────────────────────

  /// 登记后是否有提到该事件关键词的消息（说明该事已被聊起/闭环）。
  Future<bool> _mentionedAfter(domain.OpenLoop loop) async {
    final keywords = _keywords(loop.event);
    if (keywords.isEmpty) return false;

    final msgs = await (db.select(db.messages)
          ..where((m) => m.personaId.equals(loop.personaId)))
        .get();
    for (final msg in msgs) {
      for (final t in keywords) {
        if (msg.content.contains(t)) return true;
      }
    }
    return false;
  }

  /// 从事件文本提取匹配关键词：中文按 2-gram 滑窗（“今晚汇报”→今晚/晚汇/汇报…），
  /// 英文/数字取整词。这样“汇报顺利”能命中“今晚汇报”里的“汇报”。
  Set<String> _keywords(String text) {
    final out = <String>{};
    for (final m in RegExp(r'[一-龥]+').allMatches(text)) {
      final seg = m.group(0)!;
      if (seg.length >= 2) {
        for (var i = 0; i + 2 <= seg.length; i++) {
          out.add(seg.substring(i, i + 2));
        }
      } else {
        out.add(seg);
      }
    }
    for (final m in RegExp(r'[a-zA-Z]{3,}').allMatches(text)) {
      out.add(m.group(0)!);
    }
    return out;
  }

  Future<void> _setStatus(int id, String status) async {
    await (db.update(db.openLoops)..where((l) => l.id.equals(id)))
        .write(OpenLoopsCompanion(status: Value(status)));
  }

  Future<void> _setNotificationId(int id, int notifId) async {
    await (db.update(db.openLoops)..where((l) => l.id.equals(id)))
        .write(OpenLoopsCompanion(
      status: const Value('triggered'),
      notificationId: Value(notifId),
    ));
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
        status: switch (r.status) {
          'triggered' => domain.LoopStatus.triggered,
          'closed' => domain.LoopStatus.closed,
          'expired' => domain.LoopStatus.expired,
          _ => domain.LoopStatus.pending,
        },
        notificationId: r.notificationId,
      );
}
