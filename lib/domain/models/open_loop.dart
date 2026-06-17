/// 开放回路 / 待回访记忆（说明书 §6.6 / §7.3）。主动性的来源。
enum LoopTriggerType { clock, event, recurring }

enum LoopStatus { pending, triggered, closed, expired }

class OpenLoop {
  final int id;
  final int personaId;

  /// 事件，如“用户今晚要汇报”。
  final String event;

  /// 计划动作，如“关心地问汇报结果”。
  final String plannedAction;

  final LoopTriggerType triggerType;

  /// 钟点型的触发时间戳（毫秒）；其余类型为 null。
  final int? triggerAt;

  final double importance;
  final LoopStatus status;

  /// 关联的本地通知 ID（便于取消，对账时用）。
  final int? notificationId;

  const OpenLoop({
    required this.id,
    required this.personaId,
    required this.event,
    required this.plannedAction,
    required this.triggerType,
    required this.status,
    this.triggerAt,
    this.importance = 0.5,
    this.notificationId,
  });
}
