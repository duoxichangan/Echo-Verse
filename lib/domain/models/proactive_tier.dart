/// 数字人主动找用户的频率档位。
///
/// 落库为 `personas.proactiveTier` 的 int（[index]）。每档给一个「平均间隔小时数」，
/// 主动消息引擎据此排下一次触发时刻（叠加随机抖动 + 作息/配额约束）。
enum ProactiveTier {
  /// 关闭：从不主动找。
  off('关闭', '不会主动找你', 0),

  /// 偶尔：约每天 1 次。
  occasional('偶尔', '大概每天会找你一次', 24),

  /// 正常：每天 2–3 次。
  normal('正常', '每天会找你两三次', 9),

  /// 频繁：每天 4–5 次。
  frequent('频繁', '每天会找你好几次', 5),

  /// 话唠：每天 8–10 次。
  chatty('话唠', '隔一会就想找你聊聊', 2.5),

  /// 话痨狂魔：每天 15–20 次。
  superChatty('话痨狂魔', '几乎停不下来', 1.2);

  const ProactiveTier(this.label, this.description, this.avgGapHours);

  /// 档位中文名。
  final String label;

  /// 一句话说明（设置页展示）。
  final String description;

  /// 两条主动消息的平均间隔（小时）；0 表示不主动。
  final double avgGapHours;

  bool get isOn => this != ProactiveTier.off;

  /// 从落库的 int 还原；越界回退 off。
  static ProactiveTier fromIndex(int? i) {
    if (i == null || i < 0 || i >= ProactiveTier.values.length) {
      return ProactiveTier.off;
    }
    return ProactiveTier.values[i];
  }
}
