import 'dart:convert';

import 'package:drift/drift.dart';

import '../../data/db/database.dart';

/// 本地导出 / 导入（手册 OPS-01 / R8：全本地换机即丢失的兜底）。
///
/// 把整库序列化成一个 JSON 字符串；导入时清空各表再写回。
/// 注意：api_key 不在库里（走 SecretStore），故备份**不含密钥**，安全。
/// 表情图片文件（stickers.file_path 指向的图片）需用户另行迁移，备份只含其路径记录。
class BackupService {
  final AppDatabase db;

  const BackupService(this.db);

  static const _version = 1;

  /// 导出整库为 JSON 字符串。
  Future<String> exportToJson() async {
    final data = <String, dynamic>{
      '_version': _version,
      'personas': await _rows(db.select(db.personas)),
      'messages': await _rows(db.select(db.messages)),
      'session_summaries': await _rows(db.select(db.sessionSummaries)),
      'facts': await _rows(db.select(db.facts)),
      'relationship_states': await _rows(db.select(db.relationshipStates)),
      'open_loops': await _rows(db.select(db.openLoops)),
      'stickers': await _rows(db.select(db.stickers)),
      'moments': await _rows(db.select(db.moments)),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  /// 从 JSON 字符串导入：先清空业务表，再按内容写回。settings 不动（保留本机配置）。
  Future<void> importFromJson(String jsonStr) async {
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;

    await db.transaction(() async {
      // 清空（注意外键顺序：先子后父）。
      await db.delete(db.moments).go();
      await db.delete(db.openLoops).go();
      await db.delete(db.facts).go();
      await db.delete(db.relationshipStates).go();
      await db.delete(db.sessionSummaries).go();
      await db.delete(db.stickers).go();
      await db.delete(db.messages).go();
      await db.delete(db.personas).go();

      // 父表先插。DataClass.fromJson 与 toJson 配套，往返一致；DataClass 本身是 Insertable。
      for (final r in _list(data['personas'])) {
        await db.into(db.personas).insert(Persona.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['messages'])) {
        await db.into(db.messages).insert(Message.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['session_summaries'])) {
        await db.into(db.sessionSummaries).insert(SessionSummary.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['facts'])) {
        await db.into(db.facts).insert(Fact.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['relationship_states'])) {
        await db.into(db.relationshipStates).insert(RelationshipState.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['open_loops'])) {
        await db.into(db.openLoops).insert(OpenLoop.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['stickers'])) {
        await db.into(db.stickers).insert(Sticker.fromJson(r), mode: InsertMode.insertOrReplace);
      }
      for (final r in _list(data['moments'])) {
        await db.into(db.moments).insert(Moment.fromJson(r), mode: InsertMode.insertOrReplace);
      }
    });
  }

  List<Map<String, dynamic>> _list(dynamic v) => v is List
      ? v.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList()
      : const [];

  Future<List<Map<String, dynamic>>> _rows<D>(Selectable<D> sel) async {
    final rows = await sel.get();
    return rows.map((r) => (r as dynamic).toJson() as Map<String, dynamic>).toList();
  }
}
