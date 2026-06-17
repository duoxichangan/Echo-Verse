import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/memory_extraction.dart';
import '../../prompts/memory_prompts.dart';
import '../persona/json_extract.dart';
import 'salience.dart';

/// 记忆服务的 drift 实现（手册 MEM-01 读取 / MEM-02 写入 / MEM-03 衰减检索）。
///
/// - [readResident]：拼装常驻记忆（L1 摘要 + L3 关系 + 高显著 L2 事实），受预算约束。
/// - [search]：L5 关键词 + 时间检索（拆词 LIKE，按命中词数 + 显著度排序，无 embedding）。
/// - [extract]（MEM-02）：识别 [记住:x] 内联标记 + 调 LLM 提炼（§8.3）→ 写 L2 新事实、
///   矛盾覆盖、更新 L1 摘要 / L3 关系、开放回路落 open_loops(pending，本轮不调度)。
///
/// 显著度衰减委托 [Salience]（指数 / pinned 跳过）。`now` 由构造注入便于测试。
class DriftMemoryService implements MemoryService {
  final AppDatabase db;

  /// 提炼用的模型适配器；null 时 [extract] 只处理 [记住:x] 内联标记、跳过 LLM 提炼。
  final ModelAdapter? adapter;

  /// 取当前时间戳（毫秒）。注入便于测试与避免直接依赖时钟。
  final int Function() nowMs;

  /// 常驻集最多带几条 L2 事实。
  final int maxResidentFacts;

  /// token≈字符的粗略换算系数（中文每字约 1 token；预算按字符近似裁剪，MVP 足够）。
  final double tokensPerChar;

  DriftMemoryService(
    this.db, {
    this.adapter,
    int Function()? nowMs,
    this.maxResidentFacts = 12,
    this.tokensPerChar = 1.0,
  }) : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  // ── MEM-01 读取 ─────────────────────────────────────────────

  @override
  Future<String> readResident(int personaId, int budgetTokens) async {
    final now = nowMs();
    final buf = StringBuffer();
    var usedTokens = 0;

    // 估算并尝试追加一段；超预算则跳过该段（高优先级段先进，故低优先级先被砍）。
    bool tryAppend(String section) {
      if (section.isEmpty) return true;
      final cost = (section.length * tokensPerChar).ceil();
      if (usedTokens + cost > budgetTokens) return false;
      if (buf.isNotEmpty) buf.write('\n');
      buf.write(section);
      usedTokens += cost;
      return true;
    }

    // L1 会话摘要（常驻，优先级高）。
    final summary = await (db.select(db.sessionSummaries)
          ..where((t) => t.personaId.equals(personaId)))
        .getSingleOrNull();
    if (summary != null && summary.summary.trim().isNotEmpty) {
      tryAppend('【最近聊了什么】\n${summary.summary.trim()}');
    }

    // L3 关系状态（精简版常驻）。
    final rel = await (db.select(db.relationshipStates)
          ..where((t) => t.personaId.equals(personaId)))
        .getSingleOrNull();
    if (rel != null) {
      final parts = <String>[];
      if (rel.mood.trim().isNotEmpty) parts.add('当前情绪：${rel.mood.trim()}');
      parts.add('关系亲密度：${rel.closeness.toStringAsFixed(2)}');
      tryAppend('【此刻对你的感觉】\n${parts.join('；')}');
    }

    // L2 高显著事实（按显著度排序，pinned 优先）。
    final facts = await topFacts(personaId, now: now);
    if (facts.isNotEmpty) {
      final lines = facts.map((f) => '- ${f.content}').join('\n');
      tryAppend('【关于你我的事】\n$lines');
    }

    return buf.toString();
  }

  /// 取高显著 L2 事实：有效、未被覆盖，按显著度降序，pinned 置顶，截断到 [maxResidentFacts]。
  Future<List<Fact>> topFacts(int personaId, {int? now}) async {
    final t = now ?? nowMs();
    final rows = await (db.select(db.facts)
          ..where((f) =>
              f.personaId.equals(personaId) &
              f.valid.equals(true) &
              f.supersededBy.isNull()))
        .get();

    rows.sort((a, b) {
      // pinned 永远排在未 pinned 之前。
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      final sa = Salience.score(
        importance: a.importance,
        lastReferencedAtMs: a.lastReferencedAt,
        nowMs: t,
        pinned: a.pinned,
      );
      final sb = Salience.score(
        importance: b.importance,
        lastReferencedAtMs: b.lastReferencedAt,
        nowMs: t,
        pinned: b.pinned,
      );
      return sb.compareTo(sa);
    });

    return rows.length > maxResidentFacts
        ? rows.sublist(0, maxResidentFacts)
        : rows;
  }

  // ── MEM-03 检索 ─────────────────────────────────────────────

  @override
  Future<List<String>> search(int personaId, String query) async {
    final terms = _tokenize(query);
    if (terms.isEmpty) return const [];

    // 命中的事实与原文消息，按“命中词数 → 时间新近”排序。
    final factHits = <_Hit>[];
    final facts = await (db.select(db.facts)
          ..where((f) => f.personaId.equals(personaId) & f.valid.equals(true)))
        .get();
    for (final f in facts) {
      final n = _countHits(f.content, terms);
      if (n > 0) factHits.add(_Hit(f.content, n, f.lastReferencedAt));
    }

    final msgHits = <_Hit>[];
    final msgs = await (db.select(db.messages)
          ..where((m) => m.personaId.equals(personaId)))
        .get();
    for (final m in msgs) {
      final n = _countHits(m.content, terms);
      if (n > 0) msgHits.add(_Hit(m.content, n, m.createdAt));
    }

    final all = [...factHits, ...msgHits]
      ..sort((a, b) {
        if (a.hits != b.hits) return b.hits.compareTo(a.hits);
        return b.at.compareTo(a.at); // 同命中数取较新的
      });

    // 去重（同一句被事实和原文重复命中）。
    final seen = <String>{};
    final out = <String>[];
    for (final h in all) {
      if (seen.add(h.text)) out.add(h.text);
    }
    return out;
  }

  /// 极简中英文分词：抽取连续的中文段与字母数字段，去重去空。
  /// MVP 不引入分词库（R-embed：不依赖额外 NLP），关键词整段 `contains` 足够。
  List<String> _tokenize(String query) {
    final matches = RegExp(r'[一-龥]+|[a-zA-Z0-9]+').allMatches(query);
    final terms = <String>{};
    for (final m in matches) {
      terms.add(m.group(0)!);
    }
    return terms.toList();
  }

  int _countHits(String text, List<String> terms) {
    var n = 0;
    for (final term in terms) {
      if (text.contains(term)) n++;
    }
    return n;
  }

  // ── MEM-02 写入 / 提炼 ─────────────────────────────────────

  /// 匹配内联记忆标记 `[记住:xxx]`（全/半角冒号）。
  static final _rememberExp = RegExp(r'\[记住[:：]\s*(.+?)\s*\]');

  @override
  Future<void> extract(int personaId, List<Msg> newMsgs) async {
    final now = nowMs();

    // 1) 内联标记：[记住:xxx] 直接写为高重要性事实（说明书 §8.3）。
    for (final m in newMsgs) {
      for (final mt in _rememberExp.allMatches(m.content)) {
        final content = mt.group(1)!.trim();
        if (content.isNotEmpty) {
          await _insertFact(personaId, content, importance: 0.8, now: now);
        }
      }
    }

    // 无适配器：只做内联标记，跳过 LLM 提炼。
    if (adapter == null || newMsgs.isEmpty) return;

    // 2) 备齐提炼输入：已知事实（带 id）+ 当前摘要 + 最近对话。
    final knownFacts = await _knownFactsText(personaId, now);
    final summaryRow = await (db.select(db.sessionSummaries)
          ..where((t) => t.personaId.equals(personaId)))
        .getSingleOrNull();
    final dialogue = newMsgs
        .map((m) => '${m.role == Role.user ? '用户' : 'TA'}: ${m.content}')
        .join('\n');

    // 3) 调 LLM 提炼。
    final buf = StringBuffer();
    await for (final chunk in adapter!.chat(
      system: MemoryPrompts.system,
      messages: [
        Msg.user(MemoryPrompts.user(
          knownFacts: knownFacts,
          recentDialogue: dialogue,
          currentSummary: summaryRow?.summary ?? '',
        )),
      ],
      opts: const ChatOpts(temperature: 0.3),
    )) {
      buf.write(chunk);
    }
    final json = extractJsonObject(buf.toString());
    if (json == null) return; // 提炼不出结构就不动库（已写过内联标记）
    final ex = MemoryExtraction.fromJson(json);

    // 4) 落库。
    // 4a) 矛盾覆盖：旧事实置 superseded_by=-1（占位“被覆盖”）+ valid=false。
    for (final s in ex.superseded) {
      await (db.update(db.facts)
            ..where((f) => f.id.equals(s.oldFactId) & f.personaId.equals(personaId)))
          .write(const FactsCompanion(
        valid: Value(false),
        supersededBy: Value(-1),
      ));
    }
    // 4b) 新事实入库。
    for (final f in ex.newFacts) {
      await _insertFact(personaId, f.content, importance: f.importance, now: now);
    }
    // 4c) L1 摘要更新（覆盖式）。
    if (ex.summaryUpdate != null && ex.summaryUpdate!.trim().isNotEmpty) {
      await _upsertSummary(personaId, ex.summaryUpdate!.trim(), now);
    }
    // 4d) L3 关系更新。
    if (ex.relationshipUpdate?.hasChange ?? false) {
      await _applyRelationshipUpdate(personaId, ex.relationshipUpdate!, now);
    }
    // 4e) 开放回路落库（pending，本轮不调度——PROACT-02 后续接）。
    for (final l in ex.newOpenLoops) {
      await db.into(db.openLoops).insert(OpenLoopsCompanion.insert(
            personaId: personaId,
            event: l.event,
            plannedAction: l.plannedAction,
            triggerType: l.triggerType,
            triggerAt: Value(l.triggerAtMs()),
            importance: Value(l.importance),
            createdAt: now,
          ));
    }
  }

  Future<void> _insertFact(int personaId, String content,
      {required double importance, required int now}) async {
    await db.into(db.facts).insert(FactsCompanion.insert(
          personaId: personaId,
          content: content,
          lastReferencedAt: now,
          createdAt: now,
          importance: Value(importance),
        ));
  }

  /// 当前有效事实拼成 "id. content" 文本，供提炼识别矛盾。
  Future<String> _knownFactsText(int personaId, int now) async {
    final facts = await topFacts(personaId, now: now);
    return facts.map((f) => '${f.id}. ${f.content}').join('\n');
  }

  Future<void> _upsertSummary(int personaId, String summary, int now) async {
    await db.into(db.sessionSummaries).insertOnConflictUpdate(
          SessionSummariesCompanion.insert(
            personaId: Value(personaId),
            summary: Value(summary),
            updatedAt: now,
          ),
        );
  }

  Future<void> _applyRelationshipUpdate(
      int personaId, RelationshipUpdate u, int now) async {
    final existing = await (db.select(db.relationshipStates)
          ..where((t) => t.personaId.equals(personaId)))
        .getSingleOrNull();
    final oldCloseness = existing?.closeness ?? 0.5;
    final newCloseness =
        (oldCloseness + u.closenessDelta).clamp(0.0, 1.0).toDouble();
    final mood = (u.mood != null && u.mood!.trim().isNotEmpty)
        ? u.mood!.trim()
        : (existing?.mood ?? '');
    final unresolvedJson =
        u.unresolved.isNotEmpty ? _encodeList(u.unresolved) : (existing?.unresolved ?? '[]');

    await db.into(db.relationshipStates).insertOnConflictUpdate(
          RelationshipStatesCompanion.insert(
            personaId: Value(personaId),
            mood: Value(mood),
            closeness: Value(newCloseness),
            unresolved: Value(unresolvedJson),
            updatedAt: now,
          ),
        );
  }

  String _encodeList(List<String> items) {
    // 简单 JSON 数组编码（unresolved 列存 JSON 列表）。
    final escaped = items.map((s) => '"${s.replaceAll('"', r'\"')}"');
    return '[${escaped.join(',')}]';
  }
}

/// 检索命中项（内部用）。
class _Hit {
  final String text;
  final int hits;
  final int at;
  const _Hit(this.text, this.hits, this.at);
}
