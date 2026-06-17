import '../models/rendered_message.dart';

/// 输出后处理契约（手册 CHAT-03）。
///
/// 纯函数式：输入模型原始文本流，输出带类型/延迟的渲染消息列表。
/// 职责：按 `‹SEP›` 分条（失败兜底整段一条，R5）、解析 `[表情:label]`、
/// 估算每条“正在输入”延迟。**不依赖任何 LLM，完全可独立单测。**
///
/// 表情标签→图片路径的解析需要 [StickerRepo]，故 [process] 带 `personaId`；
/// 该依赖通过实现类构造注入，本接口仍不触碰 LLM。
abstract class OutputPostProcessor {
  Future<List<RenderedMessage>> process(
    Stream<String> rawStream, {
    required int personaId,
  });
}
