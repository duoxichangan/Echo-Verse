/// 社交层 Prompt 模板（说明书 §8.5 对外人格 / §8.6 朋友圈，Phase 3）。
class SocialPrompts {
  // ── §8.5 对外人格推演 ──────────────────────────────────

  static const outwardSystem = '''
你要从一个人「对你（私聊）」的样子，推演 TA「对外（朋友圈/公开场合）」的样子。
私聊和朋友圈常是两副面孔——私聊可能很丧，朋友圈却阳光；私聊毒舌，朋友圈得体。
基于 TA 的身份/性格/年龄，推断 TA 公开发朋友圈时的调性。

只输出一个 JSON 对象，不要解释、不要 markdown：
{
  "tone": "公开调性的一句话描述（如：阳光正能量、文艺感慨、爱晒生活）",
  "topics": ["爱发什么类型的朋友圈"],
  "style": "文案风格（长短、emoji、标点、是否爱配话题标签）"
}
严格只输出 JSON。''';

  static String outwardUser(String personaProfile) =>
      'TA「对你」的人格画像如下，请据此推演对外人格：\n$personaProfile';

  // ── §8.6 朋友圈生成 ────────────────────────────────────

  static const momentSystem = '''
你就是这个人，正在发一条朋友圈（公开给所有人看）。
按你的「对外人格」调性来写，取材于你最近的生活/心情。
要求：
- 纯文字，像真人随手发的朋友圈，自然、不做作。
- 一两句话即可，可带 emoji。
- 不要写"今天我要发一条朋友圈"这种话，直接就是朋友圈正文。
- 只输出朋友圈正文本身，不要引号、不要解释。''';

  static String momentUser({
    required String outwardPersona,
    required String recentMemory,
  }) {
    final b = StringBuffer();
    b.writeln('你的对外人格：');
    b.writeln(outwardPersona);
    if (recentMemory.trim().isNotEmpty) {
      b.writeln();
      b.writeln('你最近的生活/心情（可作素材）：');
      b.writeln(recentMemory.trim());
    }
    b.writeln();
    b.writeln('现在发一条朋友圈：');
    return b.toString();
  }

  // ── 点赞后私聊提起（SOCIAL-03）──────────────────────────

  /// 用户给某条朋友圈点了赞 → 数字人下次私聊自然提起的开场。
  static String likeMentionAction(String momentContent) =>
      '看到对方给我那条朋友圈「$momentContent」点赞了，自然地提一句、表示开心';
}
