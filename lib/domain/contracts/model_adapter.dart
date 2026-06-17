import '../models/chat_message.dart';

/// 模型适配层的唯一契约（说明书 §9 / 手册 MODEL-01）。
///
/// 全项目所有需要 LLM 的模块（CHAT/PERSONA/MEM/PROACT/SOCIAL）都只依赖
/// 这一个接口；可用 MockAdapter 返回固定文本来离线开发。
abstract class ModelAdapter {
  /// 流式对话：逐字（或逐块）产出增量文本，供打字机 / 分条使用。
  Stream<String> chat({
    required String system,
    required List<Msg> messages,
    ChatOpts opts = const ChatOpts(),
  });
}
