import '../models/persona.dart';

/// 画像存储契约（手册 PERSONA-03）。
abstract class PersonaRepo {
  Future<Persona?> getPersona(int id);
  Future<void> update(Persona persona);

  /// 恢复到初始生成版本（R6）。
  Future<void> restoreInitial(int id);

  /// 新建一个人格（建号流水线产出画像后调用），返回自增 id。
  Future<int> create({
    required String name,
    required String personaJson,
    String? avatarPath,
    String? userAlias,
    String? relationship,
  });
}
