import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/domain/models/proactive_tier.dart';

void main() {
  group('ProactiveTier', () {
    test('off 档不主动，其余主动', () {
      expect(ProactiveTier.off.isOn, isFalse);
      expect(ProactiveTier.occasional.isOn, isTrue);
      expect(ProactiveTier.normal.isOn, isTrue);
      expect(ProactiveTier.frequent.isOn, isTrue);
      expect(ProactiveTier.chatty.isOn, isTrue);
      expect(ProactiveTier.superChatty.isOn, isTrue);
    });

    test('间隔随档位递减（越频繁间隔越短）', () {
      expect(ProactiveTier.off.avgGapHours, 0);
      expect(ProactiveTier.occasional.avgGapHours,
          greaterThan(ProactiveTier.normal.avgGapHours));
      expect(ProactiveTier.normal.avgGapHours,
          greaterThan(ProactiveTier.frequent.avgGapHours));
      expect(ProactiveTier.frequent.avgGapHours,
          greaterThan(ProactiveTier.chatty.avgGapHours));
      expect(ProactiveTier.chatty.avgGapHours,
          greaterThan(ProactiveTier.superChatty.avgGapHours));
      expect(ProactiveTier.superChatty.avgGapHours, greaterThan(0));
    });

    test('fromIndex 往返一致，越界回退 off', () {
      for (final t in ProactiveTier.values) {
        expect(ProactiveTier.fromIndex(t.index), t);
      }
      expect(ProactiveTier.fromIndex(null), ProactiveTier.off);
      expect(ProactiveTier.fromIndex(-1), ProactiveTier.off);
      expect(ProactiveTier.fromIndex(999), ProactiveTier.off);
    });
  });
}
