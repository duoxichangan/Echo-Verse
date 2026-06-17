import 'chat_message.dart';

/// 上下文组装的产物（手册 CHAT-01 → CHAT-02）。
///
/// 即“准备好喂给 ModelAdapter.chat 的东西”：一段 system + 一组消息。
class Prompt {
  final String system;
  final List<Msg> messages;

  const Prompt({required this.system, required this.messages});
}
