import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/contracts/notification_port.dart';

/// 本地通知封装（手册 PROACT-03）。flutter_local_notifications 的薄封装。
///
/// 负责权限/渠道/时区初始化、到点预约、取消。通知点开后由路由层（main）
/// 把 payload 还原成完整人设消息落入会话（说明书 §4.6）。
class LocalNotificationPort implements NotificationPort {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _inited = false;

  /// 点击通知的回调（payload 字符串：personaId:openLoopId）。由 main 注入。
  final void Function(String? payload)? onTap;

  LocalNotificationPort({this.onTap});

  static const _channelId = 'proactive_v2';
  static const _channelName = '主动消息(声音)';

  Future<void> init() async {
    if (_inited) return;
    tzdata.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (resp) => onTap?.call(resp.payload),
    );

    // Android 13+ 通知权限。
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _inited = true;
  }

  @override
  Future<void> schedule(int id, DateTime at, NotificationPayload payload) async {
    await init();
    final when = tz.TZDateTime.from(at, tz.local);
    // 过去时间：直接立即提示（兜底）。
    final fireAt = when.isAfter(tz.TZDateTime.now(tz.local))
        ? when
        : tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1));

    await _plugin.zonedSchedule(
      id,
      payload.title,
      payload.body,
      fireAt,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: '数字人到点主动来找你',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '${payload.personaId}:${payload.openLoopId ?? ''}',
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
