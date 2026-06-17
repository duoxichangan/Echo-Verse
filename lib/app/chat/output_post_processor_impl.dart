import '../../domain/contracts/output_post_processor.dart';
import '../../domain/contracts/sticker_repo.dart';
import '../../domain/models/rendered_message.dart';

/// CHAT-03 输出后处理实现（手册 §3.5 / 说明书 §7.5）。
///
/// 把模型原始文本流 → 多条带类型/延迟的 [RenderedMessage]：
///  1. 收齐整段文本，按私有分隔符 [sep]（`‹SEP›`）切条；
///  2. 整条恰为 `[表情:label]` 时解析为表情消息（命中 StickerRepo 才渲染，
///     未命中则当普通文本保留，避免丢语义，R5 兜底思路一致）；
///  3. 每条按字数估算“正在输入”延迟，首条额外加“思考”延迟，
///     全程受 [maxTotalDelay] 压缩，避免等待焦虑（说明书 §7.5）。
///
/// **纯逻辑、无 LLM 依赖**：只通过 [StickerRepo] 查路径，可完全离线单测。
class OutputPostProcessorImpl implements OutputPostProcessor {
  final StickerRepo stickerRepo;

  /// 私有分条分隔符（说明书 §8.2，选不易与正文冲突的标记，R5）。
  final String sep;

  /// 每字“正在输入”毫秒数（拟真打字速度）。
  final int msPerChar;

  /// 单条延迟下/上限（毫秒）。
  final int minDelayMs;
  final int maxDelayMs;

  /// 首条额外“思考”延迟（毫秒），保证非 0 秒弹出（§7.5）。
  final int thinkingDelayMs;

  /// 所有消息延迟之和的压缩上限（毫秒）：真人 20 分钟 → App 里几十秒。
  final int maxTotalDelay;

  const OutputPostProcessorImpl(
    this.stickerRepo, {
    this.sep = '‹SEP›',
    this.msPerChar = 80,
    this.minDelayMs = 400,
    this.maxDelayMs = 4000,
    this.thinkingDelayMs = 600,
    this.maxTotalDelay = 30000,
  });

  /// 匹配整条恰为 `[表情:label]`（允许前后空白）。
  static final _stickerExp = RegExp(r'^\s*\[表情[:：]\s*(.+?)\s*\]\s*$');

  /// 匹配句中任意位置的 `[表情:label]`（用于把表情从文本里拆出来单独成条）。
  static final _stickerInline = RegExp(r'\[表情[:：]\s*([^\]]+?)\s*\]');

  /// 匹配 `[记住:xxx]` 内联标记（展示时剥掉，不显示给用户看）。
  static final _rememberExp = RegExp(r'\[记住[:：][^\]]*\]');

  @override
  Future<List<RenderedMessage>> process(
    Stream<String> rawStream, {
    required int personaId,
  }) async {
    // 1) 收齐整段（流式打字机由 UI 负责，后处理需要完整文本才能可靠分条）。
    final buf = StringBuffer();
    await for (final chunk in rawStream) {
      buf.write(chunk);
    }
    final raw = buf.toString();

    // 2) 切条：优先按私有分隔符；模型没用分隔符时，按换行兜底分条（鲁棒）。
    var parts = raw
        .split(sep)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.length <= 1) {
      // 没出现 sep（或只有一条）：尝试按换行分条，更贴近真人连发。
      final byLine = raw
          .replaceAll(sep, '\n')
          .split(RegExp(r'\n+'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (byLine.length > 1) parts = byLine;
    }
    if (parts.isEmpty) {
      final whole = raw.replaceAll(sep, '').trim();
      if (whole.isEmpty) return const [];
      parts = [whole];
    }

    // 2.5) 句中表情拆分：把含 [表情:x] 的条拆成 文本 / 表情 / 文本 多条。
    parts = _splitInlineStickers(parts);

    // 3) 逐条转 RenderedMessage（解析表情 + 估算延迟）。
    final out = <RenderedMessage>[];
    var accumulated = 0;
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];

      // 表情：整条恰为 [表情:label] 且命中库才渲染，否则不穿帮地处理。
      final m = _stickerExp.firstMatch(part);
      if (m != null) {
        final label = m.group(1)!;
        final path = await stickerRepo.pathByLabel(personaId, label);
        if (path != null) {
          final delay = _capDelay(_delayFor('表情', isFirst: i == 0), accumulated);
          accumulated += delay;
          out.add(RenderedMessage.sticker(path, delayMs: delay));
          continue;
        }
        // 未命中库：不能把 [表情:xxx] 原文/路径丢给用户看（会穿帮）。
        // 若标签是个干净的短词，降级成纯文字（如“[表情:害羞]”→“害羞”）；
        // 若像文件路径/含奇怪符号，直接丢弃这一条。
        final clean = _degradeLabel(label);
        if (clean == null) continue; // 丢弃
        final delay = _capDelay(_delayFor(clean, isFirst: i == 0), accumulated);
        accumulated += delay;
        out.add(RenderedMessage.text(clean, delayMs: delay));
        continue;
      }

      // 文本：剥掉 [记住:xxx] 内部标记（不展示给用户），剥后为空则跳过。
      // rawContent 保留原始（含标记）供落库→MEM-02 提炼。
      final shown = part.replaceAll(_rememberExp, '').trim();
      if (shown.isEmpty) continue;
      final delay = _capDelay(_delayFor(shown, isFirst: i == 0), accumulated);
      accumulated += delay;
      out.add(RenderedMessage.text(shown, delayMs: delay, rawContent: part));
    }
    return out;
  }

  /// 把每条里嵌在句中的 `[表情:x]` 拆出来：前文本、表情、后文本各成独立条。
  /// 例："好呀[表情:开心]那走吧" → ["好呀", "[表情:开心]", "那走吧"]。
  List<String> _splitInlineStickers(List<String> parts) {
    final out = <String>[];
    for (final part in parts) {
      // 整条本就是表情，或不含表情：原样保留。
      if (_stickerExp.hasMatch(part) || !_stickerInline.hasMatch(part)) {
        out.add(part);
        continue;
      }
      var last = 0;
      for (final m in _stickerInline.allMatches(part)) {
        final before = part.substring(last, m.start).trim();
        if (before.isNotEmpty) out.add(before);
        out.add('[表情:${m.group(1)!.trim()}]'); // 规范成整条表情格式
        last = m.end;
      }
      final after = part.substring(last).trim();
      if (after.isNotEmpty) out.add(after);
    }
    return out;
  }

  /// 未命中库的表情标签降级：
  /// - 像文件路径 / 含奇怪符号 / 太长 → 返回 null（丢弃，绝不显示给用户）；
  /// - 是个干净短词（情绪词）→ 返回该词本身，当普通文字显示。
  String? _degradeLabel(String label) {
    final l = label.trim();
    if (l.isEmpty) return null;
    // 含路径分隔符、点扩展名、空格过多、明显非情绪词的，丢弃。
    if (l.contains('/') || l.contains('\\') || l.contains('.') || l.length > 8) {
      return null;
    }
    return l;
  }

  /// 单条延迟：字数 × 速度，夹在 [minDelayMs, maxDelayMs]；首条加思考延迟。
  int _delayFor(String text, {required bool isFirst}) {
    var d = text.runes.length * msPerChar;
    if (d < minDelayMs) d = minDelayMs;
    if (d > maxDelayMs) d = maxDelayMs;
    if (isFirst) d += thinkingDelayMs;
    return d;
  }

  /// 全程压缩：累计达到 [maxTotalDelay] 后，后续条瞬发（延迟 0），
  /// 避免一长串消息把用户拖在等待里（说明书 §7.5）。
  int _capDelay(int delay, int accumulated) {
    if (accumulated >= maxTotalDelay) return 0;
    final remaining = maxTotalDelay - accumulated;
    return delay > remaining ? remaining : delay;
  }
}
