import '../models/chat_message.dart';
import '../models/prompt.dart';

/// 上下文组装契约（手册 CHAT-01）。
///
/// 按说明书 §7.1 的 8 级优先级组装，超预算时从低到高裁剪；注入表情库清单；
/// 预留 L5 检索钩子。
abstract class ContextAssembler {
  Future<Prompt> assemble(
    int personaId,
    List<Msg> recentMsgs,
    int budgetTokens,
  );
}
