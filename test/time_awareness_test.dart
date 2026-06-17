import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/prompts/chat_prompts.dart';
import 'package:virtual/ui/chat/chat_bubble.dart';

void main() {
  group('ChatPrompts 时间注入', () {
    test('注入 now 时 system 含时间与时段提示', () {
      final sys = ChatPrompts.system(
        personaName: '小桃',
        personaProfile: '{}',
        now: DateTime(2026, 6, 17, 23, 40), // 周三深夜
      );
      expect(sys, contains('现在的时间'));
      expect(sys, contains('2026年6月17日'));
      expect(sys, contains('深夜'));
      expect(sys, contains('困')); // 提示按时段反应
    });

    test('不传 now 时不含时间块', () {
      final sys = ChatPrompts.system(personaName: '小桃', personaProfile: '{}');
      expect(sys, isNot(contains('现在的时间')));
    });

    test('不同时段给不同时段词', () {
      String period(int hour) => ChatPrompts.system(
            personaName: 'x',
            personaProfile: '{}',
            now: DateTime(2026, 6, 17, hour),
          );
      expect(period(8), contains('上午'));
      expect(period(12), contains('中午'));
      expect(period(15), contains('下午'));
      expect(period(20), contains('晚上'));
      expect(period(2), contains('凌晨'));
    });
  });

  group('微信时间显示规则', () {
    test('今天只显示时:分', () {
      final now = DateTime.now();
      final t = DateTime(now.year, now.month, now.day, 9, 5);
      expect(formatWeChatTime(t), '09:05');
    });

    test('shouldShowTime：首条总显示，间隔够久才显示', () {
      expect(shouldShowTime(0, 1000), isTrue); // 首条
      final base = DateTime(2026, 6, 17, 10).millisecondsSinceEpoch;
      expect(shouldShowTime(base, base + 60 * 1000), isFalse); // 1 分钟，不显示
      expect(shouldShowTime(base, base + 6 * 60 * 1000), isTrue); // 6 分钟，显示
    });
  });
}
