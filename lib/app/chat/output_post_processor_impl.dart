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

    // 2) 切条：按 sep 分割并去空白；全空则兜底为整段一条（R5）。
    final parts = raw
        .split(sep)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      // 去掉所有分隔符后仍有内容才兜底成一条，否则视为空输出。
      final whole = raw.replaceAll(sep, '').trim();
      if (whole.isEmpty) return const [];
      parts.add(whole);
    }

    // 3) 逐条转 RenderedMessage（解析表情 + 估算延迟）。
    final out = <RenderedMessage>[];
    var accumulated = 0;
    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];

      // 表情：整条恰为 [表情:label] 且命中库才渲染，否则当文本。
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
        // 未命中：落到下方按文本处理（保留 [表情:xxx] 原文）。
      }

      final delay = _capDelay(_delayFor(part, isFirst: i == 0), accumulated);
      accumulated += delay;
      out.add(RenderedMessage.text(part, delayMs: delay));
    }
    return out;
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
