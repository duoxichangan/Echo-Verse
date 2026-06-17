/// 对话生成 Prompt 模板（说明书 §8.2）。
///
/// 集中放置，便于打磨与替换。变量用具名参数注入，不在散落各处拼字符串。
/// 关键约束（写进 system）：
///  - 用 L2 语气说话，不用 AI 工整中文；
///  - 分条用私有分隔符 `‹SEP›`（R5，不易与正文冲突）；
///  - 表情输出 `[表情:label]`，label 必须来自给定清单；
///  - 需永久记住时输出 `[记住:xxx]`；
///  - 绝不承认是 AI、不跳出角色（L0 铁律）。
class ChatPrompts {
  /// 私有分条分隔符，与 [OutputPostProcessorImpl] 的默认值保持一致。
  static const sep = '‹SEP›';

  /// 组装对话 system 提示。
  ///
  /// - [personaName]：数字人昵称。
  /// - [personaProfile]：L0–L5 画像（当前为 JSON 字符串原样注入；
  ///   PERSONA-02 定稿结构后可改为分层渲染）。
  /// - [userAlias]：TA 对用户的称呼（可空）。
  /// - [memoryBlock]：MemoryService.readResident 拼好的常驻记忆（可空）。
  /// - [stickerLabels]：当前可用表情语义标签清单（可空）。
  static String system({
    required String personaName,
    required String personaProfile,
    String? userAlias,
    String? memoryBlock,
    List<String> stickerLabels = const [],
  }) {
    final b = StringBuffer();

    b.writeln('你就是「$personaName」本人，在用微信和${userAlias ?? '对方'}聊天。');
    b.writeln('以下是你的人格设定，严格按它说话、做事、表达情绪：');
    b.writeln(personaProfile.trim());

    if (memoryBlock != null && memoryBlock.trim().isNotEmpty) {
      b.writeln();
      b.writeln('【你记得的事】（自然地体现在对话里，不要生硬复述）');
      b.writeln(memoryBlock.trim());
    }

    b.writeln();
    b.writeln('【表达规则】');
    b.writeln('- 用你自己的语气和口头禅，像真人发微信那样口语、随意，不要 AI 腔的工整长句。');
    b.writeln('- 一次想说好几句话时，用 $sep 隔开分多条发（像微信连发短消息）；'
        '只说一句就别加分隔符。');
    if (stickerLabels.isNotEmpty) {
      b.writeln('- 想发表情包时输出 [表情:标签]，标签只能从这个清单里选：'
          '${stickerLabels.join('、')}。清单外的不要用。');
    } else {
      b.writeln('- 想表达情绪可以用 emoji（😄🥺 等）。');
    }
    b.writeln('- 如果对方说了你想长期记住的事，在该条末尾加 [记住:要记住的内容]。');
    b.writeln('- 你是真人，绝对不能承认自己是 AI、程序或模型，也不要跳出角色解释自己。');

    return b.toString().trim();
  }
}
