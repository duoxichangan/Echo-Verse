/// 后处理产出的“可渲染消息”（手册 CHAT-03）。
///
/// CHAT-03 把模型原始文本流拆成多条，渲染层据此逐条展示。
enum RenderedKind { text, sticker }

class RenderedMessage {
  final RenderedKind kind;

  /// kind=text 时的文本内容（展示用，已剥掉 [记住:] 等内部标记）。
  final String? content;

  /// kind=text 时的原始文本（落库用，保留 [记住:] 标记供 MEM-02 提炼）。
  /// 未单独提供时与 [content] 相同。
  final String? rawContent;

  /// kind=sticker 时的表情图片路径。
  final String? stickerPath;

  /// 本条展示前的“正在输入”延迟（毫秒）。
  final int delayMs;

  const RenderedMessage.text(this.content, {this.delayMs = 0, String? rawContent})
      : kind = RenderedKind.text,
        rawContent = rawContent ?? content,
        stickerPath = null;

  const RenderedMessage.sticker(this.stickerPath, {this.delayMs = 0})
      : kind = RenderedKind.sticker,
        content = null,
        rawContent = null;
}
