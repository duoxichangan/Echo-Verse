import 'dart:convert';

/// 从 LLM 输出文本里稳健地抠出一个 JSON 对象。
///
/// LLM 常把 JSON 包在 ```json ... ``` 里、或前后带解释文字。这里：
///  1. 优先剥 markdown 代码块；
///  2. 再退而求其次取第一个 `{` 到最后一个 `}` 的子串；
///  3. 解析失败返回 null（调用方兜底）。
Map<String, dynamic>? extractJsonObject(String raw) {
  final candidates = <String>[];

  // 1) ```json ... ``` 或 ``` ... ```
  final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)```', multiLine: true);
  for (final m in fence.allMatches(raw)) {
    final inner = m.group(1);
    if (inner != null) candidates.add(inner.trim());
  }

  // 2) 第一个 { 到最后一个 }
  final start = raw.indexOf('{');
  final end = raw.lastIndexOf('}');
  if (start != -1 && end > start) {
    candidates.add(raw.substring(start, end + 1));
  }

  // 3) 原文整体兜底
  candidates.add(raw.trim());

  for (final c in candidates) {
    try {
      final decoded = jsonDecode(c);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {/* 试下一个候选 */}
  }
  return null;
}
