// 模型适配层使用的消息与参数（与 ModelAdapter 契约配套）。
//
// 注意：这里的 Msg 是“喂给 LLM”的消息，区别于落库的会话消息。

enum Role { system, user, assistant }

/// 发给模型的一条消息。
class Msg {
  final Role role;
  final String content;

  const Msg(this.role, this.content);

  Msg.system(this.content) : role = Role.system;
  Msg.user(this.content) : role = Role.user;
  Msg.assistant(this.content) : role = Role.assistant;

  Map<String, dynamic> toOpenAiJson() => {
        'role': role.name,
        'content': content,
      };
}

/// 调用模型的可调参数。
class ChatOpts {
  final double temperature;
  final int? maxTokens;
  final double? topP;

  /// 整体超时（毫秒）；null = 用适配器默认。
  final int? timeoutMs;

  const ChatOpts({
    this.temperature = 0.8,
    this.maxTokens,
    this.topP,
    this.timeoutMs,
  });
}
