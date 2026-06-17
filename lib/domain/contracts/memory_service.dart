import '../models/chat_message.dart';
import '../models/memory_fact.dart';

/// 记忆服务契约（手册 MEM-01/02/03 + MEM-04 管理）。
///
/// 聚合“读取常驻记忆 / 写入提炼 / 衰减检索 / 面板管理”。LLM 依赖只经 ModelAdapter。
abstract class MemoryService {
  /// 读取当前应常驻的记忆集合（L1 摘要 + L3 关系 + 高显著 L2 事实），受预算约束。
  /// 返回拼好的文本片段，供 ContextAssembler 注入。
  Future<String> readResident(int personaId, int budgetTokens);

  /// 从新增对话提炼：更新摘要 / 抽事实 / 处理矛盾 / 登记开放回路（说明书 §8.3）。
  Future<void> extract(int personaId, List<Msg> newMsgs);

  /// L5 关键词 + 时间检索（不依赖 embedding，R-embed），返回命中的原文片段。
  Future<List<String>> search(int personaId, String query);

  // ── MEM-04 记忆面板管理（可看可改，信任卖点）──────────────

  /// 列出某人格的有效事实（按显著度降序，pinned 优先），供面板展示。
  Future<List<MemoryFact>> listFacts(int personaId);

  /// 读取关系状态快照（L3）。
  Future<RelationshipSnapshot?> readRelationship(int personaId);

  /// 改一条事实的内容。
  Future<void> updateFactContent(int factId, String content);

  /// 置顶/取消置顶（pinned=true 跳过衰减，永久常驻）。
  Future<void> setFactPinned(int factId, bool pinned);

  /// 删除一条事实（用户手动清理）。
  Future<void> deleteFact(int factId);
}
