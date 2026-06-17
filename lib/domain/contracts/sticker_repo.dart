/// 表情库契约（手册 StickerRepo）。
///
/// 关键：可用清单**每次对话动态注入**给 LLM——新传即时可用，删掉的不再出现，
/// 不写死在人格画像里（方案 §16）。
abstract class StickerRepo {
  /// 列出某人格当前可用表情的语义标签（含全局可用的）。
  Future<List<String>> listLabels(int personaId);

  /// 按标签取图片路径；找不到返回 null（渲染层兜底）。
  Future<String?> pathByLabel(int personaId, String label);
}
