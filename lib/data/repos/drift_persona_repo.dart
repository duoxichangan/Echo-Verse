import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/persona_repo.dart';
import '../../domain/models/persona.dart' as domain;

/// 画像存储 drift 实现（手册 PERSONA-03 存储部分）。
///
/// personas 表 CRUD + R6「恢复到初始生成版本」。编辑器 UI（UI-03）后续接入，
/// 本类只负责持久化，CHAT-01 借它取画像。
class DriftPersonaRepo implements PersonaRepo {
  final AppDatabase db;

  /// 取当前时间戳（毫秒）；注入便于测试。
  final int Function() nowMs;

  DriftPersonaRepo(this.db, {int Function()? nowMs})
      : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  @override
  Future<domain.Persona?> getPersona(int id) async {
    final row = await (db.select(db.personas)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> update(domain.Persona persona) async {
    await (db.update(db.personas)..where((p) => p.id.equals(persona.id)))
        .write(PersonasCompanion(
      name: Value(persona.name),
      avatarPath: Value(persona.avatarPath),
      personaJson: Value(persona.personaJson),
      personaJsonInitial: Value(persona.personaJsonInitial),
      outwardPersonaJson: Value(persona.outwardPersonaJson),
      userAlias: Value(persona.userAlias),
      relationship: Value(persona.relationship),
      updatedAt: Value(nowMs()),
    ));
  }

  @override
  Future<void> restoreInitial(int id) async {
    final row = await (db.select(db.personas)..where((p) => p.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return;
    // 把当前画像覆盖回初始生成版本（R6）。
    await (db.update(db.personas)..where((p) => p.id.equals(id)))
        .write(PersonasCompanion(
      personaJson: Value(row.personaJsonInitial),
      updatedAt: Value(nowMs()),
    ));
  }

  /// 新建一个人格，返回自增 id。建号流水线（PERSONA-02）产出画像后调用。
  Future<int> create({
    required String name,
    required String personaJson,
    String? avatarPath,
    String? userAlias,
    String? relationship,
  }) {
    final now = nowMs();
    return db.into(db.personas).insert(PersonasCompanion.insert(
          name: name,
          personaJson: personaJson,
          // 初始版本 = 首次生成版本，供 R6 恢复。
          personaJsonInitial: personaJson,
          avatarPath: Value(avatarPath),
          userAlias: Value(userAlias),
          relationship: Value(relationship),
          createdAt: now,
          updatedAt: now,
        ));
  }

  domain.Persona _toDomain(Persona row) => domain.Persona(
        id: row.id,
        name: row.name,
        avatarPath: row.avatarPath,
        personaJson: row.personaJson,
        personaJsonInitial: row.personaJsonInitial,
        outwardPersonaJson: row.outwardPersonaJson,
        userAlias: row.userAlias,
        relationship: row.relationship,
      );
}
