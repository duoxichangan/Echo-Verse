import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/sticker_repo.dart';

/// 表情库 drift 实现（手册 StickerRepo / 说明书 §16）。
///
/// 表情存 stickers 表（personaId=null 为全局可用）；图片文件本身存在设备文件系统，
/// 这里只存路径 + 用户命名的语义标签。可用清单每次对话动态注入（方案 §16）。
class DriftStickerRepo implements StickerRepo {
  final AppDatabase db;

  const DriftStickerRepo(this.db);

  /// 该 persona 可见的表情（专属 + 全局）。
  Future<List<Sticker>> _visible(int personaId) {
    return (db.select(db.stickers)
          ..where((s) => s.personaId.equals(personaId) | s.personaId.isNull()))
        .get();
  }

  @override
  Future<List<String>> listLabels(int personaId) async {
    final rows = await _visible(personaId);
    return rows.map((r) => r.label).toSet().toList()..sort();
  }

  @override
  Future<String?> pathByLabel(int personaId, String label) async {
    final rows = await _visible(personaId);
    for (final r in rows) {
      if (r.label == label) return r.filePath;
    }
    return null;
  }

  @override
  Future<List<StickerItem>> listStickers(int personaId) async {
    final rows = await _visible(personaId);
    return rows
        .map((r) => StickerItem(
              id: r.id,
              personaId: r.personaId,
              filePath: r.filePath,
              label: r.label,
            ))
        .toList();
  }

  @override
  Future<int> addSticker(
      {int? personaId, required String filePath, required String label}) {
    return db.into(db.stickers).insert(StickersCompanion.insert(
          personaId: Value(personaId),
          filePath: filePath,
          label: label,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ));
  }

  @override
  Future<void> deleteSticker(int id) async {
    await (db.delete(db.stickers)..where((s) => s.id.equals(id))).go();
  }
}
