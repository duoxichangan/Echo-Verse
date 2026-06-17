import '../models/persona.dart';

/// 画像存储契约（手册 PERSONA-03）。
abstract class PersonaRepo {
  Future<Persona?> getPersona(int id);
  Future<void> update(Persona persona);

  /// 恢复到初始生成版本（R6）。
  Future<void> restoreInitial(int id);
}
