/// 记忆提炼 Prompt 模板（说明书 §8.3）。
///
/// 输入近期对话 + 当前已知事实（带 id，供识别矛盾），输出提炼 JSON。
class MemoryPrompts {
  static const system = '''
你是一个“记忆提炼器”。读最近的对话，从中提炼出值得长期记住的信息，更新数字人的记忆。
站在“数字人”的视角理解这段关系（用户是 TA 在聊天的人）。

只输出一个 JSON 对象，不要解释、不要 markdown 代码块包裹，结构如下：
{
  "summary_update": "把最近对话压缩进滚动摘要后的新摘要（一两句话，覆盖式）",
  "new_facts": [{"content": "关于用户/关系的长期事实", "importance": 0.0}],
  "superseded": [{"old_fact_id": 0, "reason": "为什么这条旧事实被覆盖了"}],
  "relationship_update": {"mood": "数字人此刻情绪", "closeness_delta": 0.0, "unresolved": ["未了结的事"]},
  "new_open_loops": [{"event": "用户提到的待回访的事", "planned_action": "之后该做的关心动作", "trigger_type": "clock|event|recurring", "trigger_at": "ISO时间或null", "importance": 0.0}]
}

规则：
- new_facts 只记**值得长期记住**的（兴趣、关系、重要经历、偏好）；随口闲聊不要记。
  importance：越重要越接近 1（如“用户对花生过敏”=0.9），琐事接近 0.2。
- 若新信息与某条【已知事实】矛盾（如旧“在读书”、新“工作了”），把旧的 id 放进 superseded，
  并把新值写进 new_facts。不要堆叠矛盾。
- relationship_update：closeness_delta 是关系温度的变化量，-1 到 1 之间；没明显变化给 0。
- new_open_loops：只登记**值得一个在乎你的朋友回访**的事（汇报/面试/看病/考试），
  随口说吃啥不登记。trigger_type：有明确钟点→clock 并给 trigger_at；
  “等你考完”这类→event 且 trigger_at 为 null；“最近在健身”→recurring。
- 没有可提炼的内容时，对应字段给空数组 / null。
- 严格只输出 JSON。''';

  /// 拼装 user：当前已知事实（带 id）+ 最近对话。
  static String user({
    required String knownFacts,
    required String recentDialogue,
    required String currentSummary,
  }) {
    final b = StringBuffer();
    if (currentSummary.trim().isNotEmpty) {
      b.writeln('【当前摘要】');
      b.writeln(currentSummary.trim());
      b.writeln();
    }
    b.writeln('【已知事实】（矛盾时引用其 id 放进 superseded）');
    b.writeln(knownFacts.trim().isEmpty ? '（暂无）' : knownFacts.trim());
    b.writeln();
    b.writeln('【最近对话】');
    b.writeln(recentDialogue.trim());
    return b.toString();
  }
}
