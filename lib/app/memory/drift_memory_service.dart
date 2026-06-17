import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/models/chat_message.dart';
import 'salience.dart';

/// 记忆服务的 drift 实现（手册 MEM-01 读取 / MEM-03 衰减检索）。
///
/// - [readResident]：拼装常驻记忆（L1 摘要 + L3 关系 + 高显著 L2 事实），受预算约束。
/// - [search]：L5 关键词 + 时间检索（拆词 LIKE，按命中词数 + 显著度排序，无 embedding）。
/// - [recomputeTopFacts]：按显著度排序取前 K（衰减体现在排序里，低分自然沉底）。
/// - [extract]（MEM-02）：依赖 ModelAdapter + OpenLoopEngine，留待后续工单，暂抛未实现。
///
/// 显著度衰减委托 [Salience]（指数 / pinned 跳过）。`now` 由构造注入便于测试。
class DriftMemoryService implements MemoryService {
  final AppDatabase db;

  /// 取当前时间戳（毫秒）。注入便于测试与避免直接依赖时钟。
  final int Function() nowMs;

  /// 常驻集最多带几条 L2 事实。
  final int maxResidentFacts;

  /// token≈字符的粗略换算系数（中文每字约 1 token；预算按字符近似裁剪，MVP 足够）。
  final double tokensPerChar;

  DriftMemoryService(
    this.db, {
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

  // ── MEM-02 写入提炼（后续工单）─────────────────────────────

  @override
  Future<void> extract(int personaId, List<Msg> newMsgs) {
    throw UnimplementedError(
      'MEM-02 记忆写入/提炼依赖 ModelAdapter + OpenLoopEngine，留待对应工单实现。',
    );
  }
}

/// 检索命中项（内部用）。
class _Hit {
  final String text;
  final int hits;
  final int at;
  const _Hit(this.text, this.hits, this.at);
}
