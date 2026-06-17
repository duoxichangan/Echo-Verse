import 'dart:math' as math;

/// 显著度评分（说明书 §7.2 / 手册 MEM-03）。
///
/// 拟真遗忘：`salience = importance × exp(-Δt / τ)`（艾宾浩斯式指数衰减）——
/// 越重要的事衰减越慢，久不提起的事慢慢淡出常驻集（但**不删**，仍可被 L5 检索召回）。
/// `pinned` 事实跳过衰减，恒为 importance（用户置顶为永久）。
///
/// 纯函数、无时钟依赖（`now` 由调用方传入），可独立单测。
class Salience {
  /// 默认半衰期：14 天。Δt = τ·ln2 时 score 减半。
  static const Duration defaultHalfLife = Duration(days: 14);

  /// 计算单条事实的显著度。
  ///
  /// - [importance] 0–1 的重要性。
  /// - [lastReferencedAtMs] / [nowMs] 毫秒时间戳，差值即“多久没提起”。
  /// - [pinned] 为真时跳过衰减，直接返回 importance。
  /// - [halfLife] 半衰期，越长记得越牢；默认 [defaultHalfLife]。
  static double score({
    required double importance,
    required int lastReferencedAtMs,
    required int nowMs,
    bool pinned = false,
    Duration halfLife = defaultHalfLife,
  }) {
    if (pinned) return importance;

    // 时间倒流（数据异常 / 未来戳）视为刚提起，不衰减。
    final dtMs = nowMs - lastReferencedAtMs;
    if (dtMs <= 0) return importance;

    // τ = halfLife / ln2，使得 Δt = halfLife 时衰减因子恰为 0.5。
    final tauMs = halfLife.inMilliseconds / math.ln2;
    final decay = math.exp(-dtMs / tauMs);
    return importance * decay;
  }
}
