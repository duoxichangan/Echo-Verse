// 记忆提炼的输出模型（说明书 §8.3）。
//
// 对应提炼 prompt 要求 LLM 返回的 JSON。宽容解析：缺字段给默认、坏值跳过，不抛。

/// 新抽取的一条事实。
class ExtractedFact {
  final String content;
  final double importance; // 0–1

  const ExtractedFact({required this.content, this.importance = 0.5});

  factory ExtractedFact.fromJson(Map<String, dynamic> j) => ExtractedFact(
        content: (j['content'] ?? '').toString(),
        importance: _d(j['importance'], 0.5),
      );

  bool get isValid => content.trim().isNotEmpty;
}

/// 一条“旧事实被覆盖”的指令（矛盾处理，§7.2）。
class SupersededFact {
  final int oldFactId;
  final String reason;

  const SupersededFact({required this.oldFactId, this.reason = ''});

  factory SupersededFact.fromJson(Map<String, dynamic> j) => SupersededFact(
        oldFactId: _i(j['old_fact_id']),
        reason: (j['reason'] ?? '').toString(),
      );
}

/// L3 关系状态的增量更新。
class RelationshipUpdate {
  final String? mood;
  final double closenessDelta; // 关系温度变化量
  final List<String> unresolved; // 未了结的事（覆盖式）

  const RelationshipUpdate({
    this.mood,
    this.closenessDelta = 0,
    this.unresolved = const [],
  });

  factory RelationshipUpdate.fromJson(Map<String, dynamic> j) =>
      RelationshipUpdate(
        mood: j['mood']?.toString(),
        closenessDelta: _d(j['closeness_delta'], 0),
        unresolved: (j['unresolved'] as List?)
                ?.map((e) => e.toString())
                .where((s) => s.trim().isNotEmpty)
                .toList() ??
            const [],
      );

  bool get hasChange =>
      (mood != null && mood!.trim().isNotEmpty) ||
      closenessDelta != 0 ||
      unresolved.isNotEmpty;
}

/// 新登记的开放回路（待回访，§7.3）。本轮先落库 pending，不调度。
class ExtractedOpenLoop {
  final String event;
  final String plannedAction;
  final String triggerType; // clock / event / recurring
  final String? triggerAtIso; // 钟点型的 ISO 时间，可空
  final double importance;

  const ExtractedOpenLoop({
    required this.event,
    required this.plannedAction,
    this.triggerType = 'event',
    this.triggerAtIso,
    this.importance = 0.5,
  });

  factory ExtractedOpenLoop.fromJson(Map<String, dynamic> j) => ExtractedOpenLoop(
        event: (j['event'] ?? '').toString(),
        plannedAction: (j['planned_action'] ?? '').toString(),
        triggerType: (j['trigger_type'] ?? 'event').toString(),
        triggerAtIso: j['trigger_at']?.toString(),
        importance: _d(j['importance'], 0.5),
      );

  bool get isValid => event.trim().isNotEmpty;

  /// 把 ISO 时间解析成毫秒时间戳；解析不出或非钟点型返回 null。
  int? triggerAtMs() {
    if (triggerAtIso == null || triggerAtIso!.trim().isEmpty) return null;
    final dt = DateTime.tryParse(triggerAtIso!.trim());
    return dt?.millisecondsSinceEpoch;
  }
}

/// 一次提炼的完整结果。
class MemoryExtraction {
  final String? summaryUpdate; // 新的滚动摘要（覆盖式）
  final List<ExtractedFact> newFacts;
  final List<SupersededFact> superseded;
  final RelationshipUpdate? relationshipUpdate;
  final List<ExtractedOpenLoop> newOpenLoops;

  const MemoryExtraction({
    this.summaryUpdate,
    this.newFacts = const [],
    this.superseded = const [],
    this.relationshipUpdate,
    this.newOpenLoops = const [],
  });

  factory MemoryExtraction.fromJson(Map<String, dynamic> j) => MemoryExtraction(
        summaryUpdate: j['summary_update']?.toString(),
        newFacts: (j['new_facts'] as List?)
                ?.whereType<Map>()
                .map((e) => ExtractedFact.fromJson(e.cast<String, dynamic>()))
                .where((f) => f.isValid)
                .toList() ??
            const [],
        superseded: (j['superseded'] as List?)
                ?.whereType<Map>()
                .map((e) => SupersededFact.fromJson(e.cast<String, dynamic>()))
                .where((s) => s.oldFactId > 0)
                .toList() ??
            const [],
        relationshipUpdate: j['relationship_update'] is Map
            ? RelationshipUpdate.fromJson(
                (j['relationship_update'] as Map).cast<String, dynamic>())
            : null,
        newOpenLoops: (j['new_open_loops'] as List?)
                ?.whereType<Map>()
                .map((e) => ExtractedOpenLoop.fromJson(e.cast<String, dynamic>()))
                .where((l) => l.isValid)
                .toList() ??
            const [],
      );
}

double _d(dynamic v, double fallback) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? fallback;
  return fallback;
}

int _i(dynamic v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? 0;
  return 0;
}
