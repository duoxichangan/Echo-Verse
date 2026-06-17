import 'dart:convert';

/// 作息表（活动调度中枢用，说明书 §7.6）。
///
/// 唯一作息定义：活跃时段 [startHour, endHour)（24 小时制）。
/// 其余为安静时段，不主动打扰（除非人设是夜猫子——可把 endHour 设大）。
class ActiveHours {
  final int startHour; // 含
  final int endHour; // 不含

  const ActiveHours({this.startHour = 8, this.endHour = 23});

  /// 从 settings 的 activeHoursJson 解析；坏值/缺省回退默认 8–23。
  factory ActiveHours.fromJson(String jsonStr) {
    try {
      final m = jsonDecode(jsonStr);
      if (m is Map) {
        final s = m['start'];
        final e = m['end'];
        return ActiveHours(
          startHour: s is num ? s.toInt() : 8,
          endHour: e is num ? e.toInt() : 23,
        );
      }
    } catch (_) {/* 回退默认 */}
    return const ActiveHours();
  }

  String toJsonString() => jsonEncode({'start': startHour, 'end': endHour});

  /// 给定时刻是否在活跃时段内。
  bool isActiveAt(DateTime t) {
    final h = t.hour;
    if (startHour <= endHour) {
      return h >= startHour && h < endHour;
    }
    // 跨午夜（如 22–6）：活跃 = h>=start 或 h<end。
    return h >= startHour || h < endHour;
  }

  /// 从某时刻起，下一个活跃时段开始的时间。
  DateTime nextActiveStart(DateTime from) {
    if (isActiveAt(from)) return from;
    var candidate = DateTime(from.year, from.month, from.day, startHour);
    if (!candidate.isAfter(from)) {
      // 今天的活跃开始已过，顺延到明天。
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }
}
