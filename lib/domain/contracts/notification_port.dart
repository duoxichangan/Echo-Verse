/// 本地通知契约（手册 PROACT-03）。封装 flutter_local_notifications。
class NotificationPayload {
  final int personaId;
  final int? openLoopId;
  final String title;
  final String body;

  const NotificationPayload({
    required this.personaId,
    required this.title,
    required this.body,
    this.openLoopId,
  });
}

abstract class NotificationPort {
  Future<void> schedule(int id, DateTime at, NotificationPayload payload);
  Future<void> cancel(int id);
}
