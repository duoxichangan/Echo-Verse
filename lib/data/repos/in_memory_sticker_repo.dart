import '../../domain/contracts/sticker_repo.dart';

/// 内存版表情库（手册 StickerRepo 契约的最简实现）。
///
/// 作用：在 PERSONA-03 / 真正的 drift 表情仓储就绪前，
/// 让 CHAT-01/CHAT-03 能离线联调与单测。语义同契约：
/// label → path 的查表，personaId 专属优先于全局（personaId=null）。
class InMemoryStickerRepo implements StickerRepo {
  /// 全局可用：label → path。
  final Map<String, String> global;

  /// 人格专属：personaId → (label → path)，优先于全局。
  final Map<int, Map<String, String>> perPersona;

  InMemoryStickerRepo({
    Map<String, String>? global,
    Map<int, Map<String, String>>? perPersona,
  })  : global = global ?? <String, String>{},
        perPersona = perPersona ?? <int, Map<String, String>>{};

  @override
  Future<List<String>> listLabels(int personaId) async {
    final labels = <String>{...global.keys};
    labels.addAll(perPersona[personaId]?.keys ?? const []);
    return labels.toList()..sort();
  }

  @override
  Future<String?> pathByLabel(int personaId, String label) async {
    return perPersona[personaId]?[label] ?? global[label];
  }
}
