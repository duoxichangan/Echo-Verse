import '../../domain/contracts/scheduler.dart';
import 'active_hours.dart';

/// 活动调度中枢实现（手册 PROACT-01 / 说明书 §7.6，R1）。
///
/// 唯一作息表 + 全局每日主动配额：所有主动行为（消息/朋友圈）共用一处闸门，
/// 杜绝“刚说睡觉不回你，却发了条朋友圈”的自相矛盾。
///
/// 纯逻辑、无 LLM、无 UI。当日配额用内存计数（跨重启重置，MVP 可接受）。
class DefaultScheduler implements Scheduler {
  final ActiveHours activeHours;

  /// 每日主动行为配额上限（消息 + 朋友圈共用）。
  final int dailyQuota;

  /// 当日已用配额：dateKey(yyyymmdd) → count。
  final Map<int, int> _used = {};

  DefaultScheduler({
    this.activeHours = const ActiveHours(),
    this.dailyQuota = 5,
  });

  int _dateKey(DateTime t) => t.year * 10000 + t.month * 100 + t.day;

  @override
  SlotDecision requestProactiveSlot(ProactiveType type, DateTime time) {
    // 1) 安静时段：拒绝，顺延到下一个活跃时段开始。
    if (!activeHours.isActiveAt(time)) {
      return SlotDecision(false,
          suggestedTime:
              activeHours.nextActiveStart(time).millisecondsSinceEpoch);
    }
    // 2) 超配额：拒绝（不顺延——今天额度用完了）。
    final key = _dateKey(time);
    final used = _used[key] ?? 0;
    if (used >= dailyQuota) {
      return const SlotDecision(false);
    }
    // 3) 允许：占用一个额度。
    _used[key] = used + 1;
    return const SlotDecision(true);
  }

  /// 测试/对账用：归还一个额度（如对账后取消发送）。
  void releaseSlot(DateTime time) {
    final key = _dateKey(time);
    final used = _used[key] ?? 0;
    if (used > 0) _used[key] = used - 1;
  }
}
