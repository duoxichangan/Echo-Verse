import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/app/proact/active_hours.dart';
import 'package:virtual/app/proact/default_scheduler.dart';
import 'package:virtual/domain/contracts/scheduler.dart';

void main() {
  group('ActiveHours', () {
    test('普通时段 8–23', () {
      const h = ActiveHours(startHour: 8, endHour: 23);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 10)), isTrue);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 2)), isFalse);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 23)), isFalse); // 含头不含尾
    });

    test('跨午夜时段 22–6（夜猫子）', () {
      const h = ActiveHours(startHour: 22, endHour: 6);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 23)), isTrue);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 3)), isTrue);
      expect(h.isActiveAt(DateTime(2026, 6, 17, 12)), isFalse);
    });

    test('安静时段顺延到下一个活跃开始', () {
      const h = ActiveHours(startHour: 8, endHour: 23);
      // 凌晨 2 点 → 顺延到当天 8 点
      final next = h.nextActiveStart(DateTime(2026, 6, 17, 2));
      expect(next.hour, 8);
      expect(next.day, 17);
      // 深夜 23:30 → 顺延到次日 8 点
      final next2 = h.nextActiveStart(DateTime(2026, 6, 17, 23, 30));
      expect(next2.hour, 8);
      expect(next2.day, 18);
    });

    test('JSON 往返', () {
      const h = ActiveHours(startHour: 9, endHour: 22);
      final back = ActiveHours.fromJson(h.toJsonString());
      expect(back.startHour, 9);
      expect(back.endHour, 22);
    });

    test('坏 JSON 回退默认', () {
      final h = ActiveHours.fromJson('not json');
      expect(h.startHour, 8);
      expect(h.endHour, 23);
    });
  });

  group('DefaultScheduler', () {
    test('安静时段拒绝并给顺延时间', () {
      final s = DefaultScheduler(
        activeHours: const ActiveHours(startHour: 8, endHour: 23),
        dailyQuota: 5,
      );
      final d = s.requestProactiveSlot(
          ProactiveType.message, DateTime(2026, 6, 17, 2));
      expect(d.allow, isFalse);
      expect(d.suggestedTime, isNotNull);
      final suggested = DateTime.fromMillisecondsSinceEpoch(d.suggestedTime!);
      expect(suggested.hour, 8);
    });

    test('活跃时段内允许，并占用配额', () {
      final s = DefaultScheduler(dailyQuota: 2);
      final t = DateTime(2026, 6, 17, 10);
      expect(s.requestProactiveSlot(ProactiveType.message, t).allow, isTrue);
      expect(s.requestProactiveSlot(ProactiveType.moment, t).allow, isTrue);
      // 第三次超配额
      expect(s.requestProactiveSlot(ProactiveType.message, t).allow, isFalse);
    });

    test('配额按天独立', () {
      final s = DefaultScheduler(dailyQuota: 1);
      final day1 = DateTime(2026, 6, 17, 10);
      final day2 = DateTime(2026, 6, 18, 10);
      expect(s.requestProactiveSlot(ProactiveType.message, day1).allow, isTrue);
      expect(s.requestProactiveSlot(ProactiveType.message, day1).allow, isFalse);
      // 换一天，配额重置
      expect(s.requestProactiveSlot(ProactiveType.message, day2).allow, isTrue);
    });

    test('releaseSlot 归还额度', () {
      final s = DefaultScheduler(dailyQuota: 1);
      final t = DateTime(2026, 6, 17, 10);
      expect(s.requestProactiveSlot(ProactiveType.message, t).allow, isTrue);
      expect(s.requestProactiveSlot(ProactiveType.message, t).allow, isFalse);
      s.releaseSlot(t);
      expect(s.requestProactiveSlot(ProactiveType.message, t).allow, isTrue);
    });
  });
}
