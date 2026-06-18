import 'dart:math';

import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/notification_port.dart';
import '../../domain/contracts/persona_repo.dart';
import '../../domain/contracts/scheduler.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/persona.dart' as domain;
import '../../domain/models/proactive_tier.dart';
import '../../prompts/proactive_prompts.dart';
import 'active_hours.dart';

/// 主动消息引擎（预生成 + 定时通知模式）。
///
/// App 活着时（启动/回前台）调 [scheduleNext]：按数字人的 [ProactiveTier] 算出
/// 下一个触发时刻（落在活跃时段、随机抖动、受配额约束），**提前用 LLM 生成**
/// 一条符合人设/记忆/时段的主动开场白，写入 `scheduled_proactives` 并排一条本地
/// 通知。到点（或下次启动对账，见 ProactiveBootstrap）把它投递成正式 message。
///
/// 这样即便 App 被系统杀掉，系统级闹钟仍能到点弹通知——这是手机端最可靠的形态。
class ProactiveMessageEngine {
  final AppDatabase db;
  final ModelAdapter adapter;
  final PersonaRepo personaRepo;
  final MemoryService memoryService;
  final Scheduler scheduler;
  final NotificationPort notifications;
  final ActiveHours activeHours;
  final int Function() nowMs;
  final Random _rng;

  /// 主动消息通知 ID 的偏移，避开开放回路通知（用 loop.id 作 id）的区间。
  static const int notifIdBase = 1000000;

  ProactiveMessageEngine({
    required this.db,
    required this.adapter,
    required this.personaRepo,
    required this.memoryService,
    required this.scheduler,
    required this.notifications,
    this.activeHours = const ActiveHours(),
    int Function()? nowMs,
    Random? rng,
  })  : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch),
        _rng = rng ?? Random();

  /// 给某个数字人排下一条主动消息。off 档、或已有未到点排期则跳过。
  Future<void> scheduleNext(int personaId) async {
    final persona = await personaRepo.getPersona(personaId);
    if (persona == null) return;
    final tier = ProactiveTier.fromIndex(persona.proactiveTier);
    if (!tier.isOn) return;

    // 已有未投递的排期：不重复排。
    final pending = await (db.select(db.scheduledProactives)
          ..where((s) =>
              s.personaId.equals(personaId) & s.status.equals('scheduled')))
        .get();
    if (pending.isNotEmpty) return;

    // 1) 算触发时刻：now + 抖动后的间隔，再夹进活跃时段。
    final fireAt = _nextFireTime(tier);

    // 2) 受调度中枢约束（与朋友圈/开放回路共用作息+配额）。
    final decision =
        scheduler.requestProactiveSlot(ProactiveType.message, fireAt);
    if (!decision.allow) {
      // 超配额/安静时段：本轮不排（下次启动/回前台再试）。
      return;
    }

    // 3) 预生成开场白（失败则不排，不影响其它流程）。
    final content = await _generate(persona, fireAt);
    if (content.trim().isEmpty) return;

    // 4) 落库排期 + 排本地通知。
    final id = await db.into(db.scheduledProactives).insert(
          ScheduledProactivesCompanion.insert(
            personaId: personaId,
            content: content.trim(),
            scheduledAt: fireAt.millisecondsSinceEpoch,
            createdAt: nowMs(),
          ),
        );
    final notifId = notifIdBase + id;
    await (db.update(db.scheduledProactives)..where((s) => s.id.equals(id)))
        .write(ScheduledProactivesCompanion(notificationId: Value(notifId)));

    await notifications.schedule(
      notifId,
      fireAt,
      NotificationPayload(
        personaId: personaId,
        title: persona.name,
        body: _notificationPreview(content.trim()),
      ),
    );
  }

  /// 计算下一次触发时间：在平均间隔上加 ±40% 抖动，落点不在活跃时段则顺延。
  DateTime _nextFireTime(ProactiveTier tier) {
    final now = DateTime.fromMillisecondsSinceEpoch(nowMs());
    final base = tier.avgGapHours;
    // ±40% 抖动，避免每次整点、过于规律。
    final jitter = (base * 0.4) * (_rng.nextDouble() * 2 - 1);
    final gapHours = (base + jitter).clamp(0.5, 48.0);
    var fire = now.add(Duration(minutes: (gapHours * 60).round()));
    if (!activeHours.isActiveAt(fire)) {
      fire = activeHours.nextActiveStart(fire);
    }
    return fire;
  }

  /// 调 LLM 生成主动开场白。
  Future<String> _generate(domain.Persona persona, DateTime at) async {
    final memory = await memoryService.readResident(persona.id, 800);
    final system = ProactivePrompts.system(
      personaName: persona.name,
      personaProfile: persona.personaJson,
      userAlias: persona.userAlias,
      memoryBlock: memory,
      now: at,
    );
    final buf = StringBuffer();
    await for (final c in adapter.chat(
      system: system,
      messages: [Msg.user(ProactivePrompts.user)],
      opts: const ChatOpts(temperature: 0.9),
    )) {
      buf.write(c);
    }
    return buf.toString();
  }

  /// 通知栏预览：去掉分条标记，截断。
  String _notificationPreview(String content) {
    final flat = content.replaceAll(ProactivePrompts.sep, ' ').trim();
    return flat.runes.length > 30
        ? '${String.fromCharCodes(flat.runes.take(30))}…'
        : flat;
  }
}
