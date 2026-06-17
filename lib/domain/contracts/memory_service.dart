import '../models/chat_message.dart';

/// 记忆服务契约（手册 MEM-01/02/03）。
///
/// 聚合“读取常驻记忆 / 写入提炼 / 衰减检索”三件事。LLM 依赖只经 ModelAdapter。
abstract class MemoryService {
  /// 读取当前应常驻的记忆集合（L1 摘要 + L3 关系 + 高显著 L2 事实），受预算约束。
  /// 返回拼好的文本片段，供 ContextAssembler 注入。
  Future<String> readResident(int personaId, int budgetTokens);

  /// 从新增对话提炼：更新摘要 / 抽事实 / 处理矛盾 / 登记开放回路（说明书 §8.3）。
  Future<void> extract(int personaId, List<Msg> newMsgs);

  /// L5 关键词 + 时间检索（不依赖 embedding，R-embed），返回命中的原文片段。
  Future<List<String>> search(int personaId, String query);
}
