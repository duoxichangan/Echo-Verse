import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/persona_repo.dart';
import '../../domain/contracts/scheduler.dart';
import '../../domain/contracts/social_service.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/moment.dart';
import '../../prompts/social_prompts.dart';

/// 社交服务实现（手册 SOCIAL-01/02/03，Phase 3 / 说明书第十七节）。
class DefaultSocialService implements SocialService {
  final AppDatabase db;
  final ModelAdapter adapter;
  final PersonaRepo personaRepo;
  final MemoryService memoryService;
  final Scheduler scheduler;
  final int Function() nowMs;

  DefaultSocialService({
    required this.db,
    required this.adapter,
    required this.personaRepo,
    required this.memoryService,
    required this.scheduler,
    int Function()? nowMs,
  }) : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  // ── SOCIAL-01 对外人格 ────────────────────────────────────

  @override
  Future<void> buildOutwardPersona(int personaId) async {
    final persona = await personaRepo.getPersona(personaId);
    if (persona == null) return;

    final outward = await _complete(
      system: SocialPrompts.outwardSystem,
      user: SocialPrompts.outwardUser(persona.personaJson),
    );
    if (outward.trim().isEmpty) return;

    await (db.update(db.personas)..where((p) => p.id.equals(personaId)))
        .write(PersonasCompanion(
      outwardPersonaJson: Value(outward.trim()),
      updatedAt: Value(nowMs()),
    ));
  }

  // ── SOCIAL-02 朋友圈发布 ──────────────────────────────────

  @override
  Future<MomentView?> maybePublish(int personaId) async {
    final now = nowMs();
    // 受活动调度中枢约束（R1）：与主动消息共用作息/配额。
    final decision = scheduler.requestProactiveSlot(
        ProactiveType.moment, DateTime.fromMillisecondsSinceEpoch(now));
    if (!decision.allow) return null;

    final persona = await personaRepo.getPersona(personaId);
    if (persona == null) return null;

    // 没有对外人格先推演一份。
    var outward = persona.outwardPersonaJson;
    if (outward == null || outward.trim().isEmpty) {
      await buildOutwardPersona(personaId);
      final refreshed = await personaRepo.getPersona(personaId);
      outward = refreshed?.outwardPersonaJson ?? persona.personaJson;
    }

    // 取近期记忆作素材。
    final memory = await memoryService.readResident(personaId, 600);
    final content = await _complete(
      system: SocialPrompts.momentSystem,
      user: SocialPrompts.momentUser(
          outwardPersona: outward, recentMemory: memory),
    );
    if (content.trim().isEmpty) return null;

    final id = await db.into(db.moments).insert(MomentsCompanion.insert(
          personaId: personaId,
          content: content.trim(),
          postedAt: now,
        ));

    // 挂一个"等待互动"开放回路（点赞后闭环——SOCIAL-03 复用 8.5 机制）。
    await db.into(db.openLoops).insert(OpenLoopsCompanion.insert(
          personaId: personaId,
          event: '发了条朋友圈：${content.trim()}',
          plannedAction: '如果对方点赞/评论了，下次私聊自然提起',
          triggerType: 'event',
          status: const Value('pending'),
          importance: const Value(0.4),
          createdAt: now,
        ));

    return MomentView(
      id: id,
      personaId: personaId,
      content: content.trim(),
      postedAt: now,
    );
  }

  @override
  Future<List<MomentView>> listMoments(int personaId) async {
    final rows = await (db.select(db.moments)
          ..where((m) => m.personaId.equals(personaId))
          ..orderBy([(m) => OrderingTerm.desc(m.postedAt)]))
        .get();
    return rows
        .map((r) => MomentView(
              id: r.id,
              personaId: r.personaId,
              content: r.content,
              postedAt: r.postedAt,
              likedByUser: r.likedByUser,
              userComment: r.userComment,
            ))
        .toList();
  }

  @override
  Future<List<MomentView>> listAllMoments() async {
    final rows = await (db.select(db.moments)
          ..orderBy([(m) => OrderingTerm.desc(m.postedAt)]))
        .get();
    // 批量取 persona 名/头像。
    final personas = await db.select(db.personas).get();
    final byId = {for (final p in personas) p.id: p};
    return rows.map((r) {
      final p = byId[r.personaId];
      return MomentView(
        id: r.id,
        personaId: r.personaId,
        content: r.content,
        postedAt: r.postedAt,
        likedByUser: r.likedByUser,
        userComment: r.userComment,
        personaName: p?.name,
        personaAvatarPath: p?.avatarPath,
      );
    }).toList();
  }

  @override
  Future<void> setLiked(int momentId, bool liked) async {
    final m = await (db.select(db.moments)..where((x) => x.id.equals(momentId)))
        .getSingleOrNull();
    if (m == null) return;

    await (db.update(db.moments)..where((x) => x.id.equals(momentId)))
        .write(MomentsCompanion(likedByUser: Value(liked)));

    if (!liked) return;
    // 点赞 → 登记一个开放回路，让数字人下次私聊自然提起（产品高光）。
    await db.into(db.openLoops).insert(OpenLoopsCompanion.insert(
          personaId: m.personaId,
          event: '对方给我的朋友圈点了赞：${m.content}',
          plannedAction: SocialPrompts.likeMentionAction(m.content),
          triggerType: 'event',
          status: const Value('pending'),
          importance: const Value(0.5),
          createdAt: nowMs(),
        ));
  }

  // ── 内部 ───────────────────────────────────────────────

  Future<String> _complete({required String system, required String user}) async {
    final buf = StringBuffer();
    await for (final c in adapter.chat(
      system: system,
      messages: [Msg.user(user)],
      opts: const ChatOpts(temperature: 0.8),
    )) {
      buf.write(c);
    }
    return buf.toString();
  }
}
