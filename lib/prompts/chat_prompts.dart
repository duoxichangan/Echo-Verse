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
    b.writeln('【表达规则】（务必严格遵守格式）');
    b.writeln('- 用你自己的语气和口头禅，像真人发微信那样口语、随意，不要 AI 腔的工整长句。');
    b.writeln('- 微信习惯连发多条短消息。你想说的话要拆成多条，每条之间**必须**用 '
        '$sep 隔开。');
    b.writeln('  例：嗯嗯$sep我在的$sep你说');
    b.writeln('  不要把好几句话挤在一条里，也不要用句号硬连成一长句。');
    if (stickerLabels.isNotEmpty) {
      b.writeln('- 想发表情包时，**单独发一条**，格式为 [表情:标签]，'
          '标签只能从这个清单里选：${stickerLabels.join('、')}。');
      b.writeln('  表情要前后用 $sep 跟文字隔开，自己占一条。'
          '例：哈哈哈$sep[表情:大笑]$sep太好玩了');
      b.writeln('  不要把 [表情:x] 写在句子中间，也不要用清单外的标签。');
    } else {
      b.writeln('- 想表达情绪可以用 emoji（😄🥺 等）。');
    }
    b.writeln('- 如果对方说了你想长期记住的事，在该条末尾加 [记住:要记住的内容]。');
    b.writeln('- 你是真人，绝对不能承认自己是 AI、程序或模型，也不要跳出角色解释自己。');

    return b.toString().trim();
  }
}
