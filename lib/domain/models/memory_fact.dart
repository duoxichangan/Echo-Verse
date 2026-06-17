/// 记忆面板用的轻量事实模型（手册 MEM-04）。
///
/// 与 drift 行解耦——面板/契约层不直接依赖 drift 生成类。
class MemoryFact {
  final int id;
  final String content;
  final double importance; // 0–1
  final bool pinned; // 置顶为永久，跳过衰减
  final int lastReferencedAt; // 毫秒
  final double salience; // 当前显著度（已算衰减），供面板排序/展示

  const MemoryFact({
    required this.id,
    required this.content,
    required this.importance,
    required this.pinned,
    required this.lastReferencedAt,
    required this.salience,
  });
}

/// 记忆面板用的关系状态快照（L3）。
class RelationshipSnapshot {
  final String mood;
  final double closeness;
  final List<String> unresolved;

  const RelationshipSnapshot({
    this.mood = '',
    this.closeness = 0.5,
    this.unresolved = const [],
  });
}
