import '../models/rendered_message.dart';

/// 对话引擎契约（手册 CHAT-02）。
///
/// 一次完整对话回合的编排入口：吃用户一句话，吐数字人的分条回复流。
/// 内部串起 ContextAssembler（组装）→ ModelAdapter（生成）→
/// OutputPostProcessor（分条/表情/延迟），并负责消息落库。
abstract class ChatEngine {
  /// 发送一条用户消息，返回数字人逐条蹦出的渲染消息流。
  ///
  /// 每条之间已按 [RenderedMessage.delayMs] 体现“正在输入”节奏；
  /// 调用方（UI）只管按到达顺序展示。
  Stream<RenderedMessage> send(int personaId, String userMsg);
}
