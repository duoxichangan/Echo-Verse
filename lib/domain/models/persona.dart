/// 人格画像（说明书 §6.1）。L0–L5 结构存于 [personaJson] 字符串中，
/// 具体字段在 PERSONA-02 里程碑展开；这里只冻结仓储需要的外形。
class Persona {
  final int id;
  final String name;
  final String? avatarPath;

  /// L0–L5 结构化画像（JSON 字符串）。
  final String personaJson;

  /// 初始生成版本，用于“恢复”（R6）。
  final String personaJsonInitial;

  /// 对外人格（P3，朋友圈用）。
  final String? outwardPersonaJson;

  /// TA 对用户的称呼。
  final String? userAlias;

  /// 关系（女友/好友/家人…）。
  final String? relationship;

  const Persona({
    required this.id,
    required this.name,
    required this.personaJson,
    required this.personaJsonInitial,
    this.avatarPath,
    this.outwardPersonaJson,
    this.userAlias,
    this.relationship,
  });
}
