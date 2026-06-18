import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/ui/common/wechat_emoji.dart';

void main() {
  group('convertWeChatEmoji', () {
    test('把已知微信内置表情名还原成 emoji', () {
      expect(convertWeChatEmoji('哈哈[捂脸]'), '哈哈🤦');
      expect(convertWeChatEmoji('[爱心]'), '❤️');
      expect(convertWeChatEmoji('好呀[旺柴]走吧'), '好呀🐶走吧');
    });

    test('一句里多个表情都替换', () {
      expect(convertWeChatEmoji('[偷笑][流泪]'), '🤭😭');
    });

    test('未知占位符原样保留（不穿帮、不误删）', () {
      expect(convertWeChatEmoji('[图片]'), '[图片]');
      expect(convertWeChatEmoji('收到[某个不认识的]'), '收到[某个不认识的]');
    });

    test('不含方括号的文本原样返回', () {
      expect(convertWeChatEmoji('今天天气不错'), '今天天气不错');
    });

    test('兼容全角方括号', () {
      expect(convertWeChatEmoji('【爱心】'), '❤️');
    });
  });
}
