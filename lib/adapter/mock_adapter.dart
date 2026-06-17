import 'dart:async';

import '../domain/contracts/model_adapter.dart';
import '../domain/models/chat_message.dart';

/// 离线开发用的假适配器（手册 MODEL-01）。
///
/// 全项目并行开发的关键解耦点：任何依赖 LLM 的模块都能用它跑通，无需真 key。
/// 默认按字符流式吐出脚本文本，模拟打字机效果。
class MockAdapter implements ModelAdapter {
  /// 固定返回的脚本文本。可被 [scriptFor] 覆盖为按输入动态生成。
  final String script;

  /// 每个 chunk 之间的间隔，模拟流式。
  final Duration chunkDelay;

  /// 可选：根据最后一条 user 消息动态决定返回文本。
  final String Function(List<Msg> messages)? scriptFor;

  const MockAdapter({
    this.script = '嗯嗯‹SEP›我在的‹SEP›[表情:微笑]',
    this.chunkDelay = const Duration(milliseconds: 15),
    this.scriptFor,
  });

  @override
  Stream<String> chat({
    required String system,
    required List<Msg> messages,
    ChatOpts opts = const ChatOpts(),
  }) async* {
    final text = scriptFor?.call(messages) ?? script;
    for (final rune in text.runes) {
      if (chunkDelay > Duration.zero) {
        await Future<void>.delayed(chunkDelay);
      }
      yield String.fromCharCode(rune);
    }
  }
}
