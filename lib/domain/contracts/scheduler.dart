/// 主动行为类型。
enum ProactiveType { message, moment }

/// 调度中枢的决策。
class SlotDecision {
  final bool allow;

  /// 不允许立即发时，建议顺延到的时间戳（毫秒）；可为 null。
  final int? suggestedTime;

  const SlotDecision(this.allow, {this.suggestedTime});
}

/// 活动调度中枢契约（手册 PROACT-01，R1）。
///
/// 持有唯一作息表 + 全局每日主动配额；所有主动行为（消息/朋友圈）都向它申请。
/// 纯逻辑、无 LLM、无 UI，是所有主动行为的前置闸门。
abstract class Scheduler {
  /// 申请一个主动行为时段。安静时段拒绝/顺延；超配额拒绝。
  SlotDecision requestProactiveSlot(ProactiveType type, DateTime time);
}
