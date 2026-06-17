import 'package:drift/drift.dart';

/// drift 表定义（说明书 §6 的 9 张表）。
/// 敏感的 api_key 不在任何表里——只走 SecretStore。

/// §6.1 人格画像 / L4 永久核心
class Personas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get avatarPath => text().nullable()();
  TextColumn get personaJson => text()();
  TextColumn get personaJsonInitial => text()();
  TextColumn get outwardPersonaJson => text().nullable()();
  TextColumn get userAlias => text().nullable()();
  TextColumn get relationship => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
}

/// §6.2 对话历史 / L0 源 + L5 检索源
class Messages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get sender => text()(); // user / persona
  TextColumn get content => text()(); // 原始文本，含 [表情:x]
  TextColumn get type => text().withDefault(const Constant('text'))(); // text/sticker/placeholder
  IntColumn get createdAt => integer()();
  BoolColumn get isProactive => boolean().withDefault(const Constant(false))();
}

/// §6.3 L1 滚动会话摘要
class SessionSummaries extends Table {
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get summary => text().withDefault(const Constant(''))();
  IntColumn get coveredUntilMsgId => integer().nullable()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {personaId};
}

/// §6.4 L2 长程事实
class Facts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get content => text()();
  RealColumn get importance => real().withDefault(const Constant(0.5))();
  IntColumn get lastReferencedAt => integer()();
  BoolColumn get pinned => boolean().withDefault(const Constant(false))();
  IntColumn get supersededBy => integer().nullable()();
  BoolColumn get valid => boolean().withDefault(const Constant(true))();
  IntColumn get createdAt => integer()();
}

/// §6.5 L3 关系状态
class RelationshipStates extends Table {
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get mood => text().withDefault(const Constant(''))();
  RealColumn get closeness => real().withDefault(const Constant(0.5))();
  TextColumn get unresolved => text().withDefault(const Constant('[]'))(); // JSON list
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {personaId};
}

/// §6.6 开放回路 / 待回访
class OpenLoops extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get event => text()();
  TextColumn get plannedAction => text()();
  TextColumn get triggerType => text()(); // clock / event / recurring
  IntColumn get triggerAt => integer().nullable()();
  RealColumn get importance => real().withDefault(const Constant(0.5))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get notificationId => integer().nullable()();
  IntColumn get createdAt => integer()();
}

/// §6.7 表情包
class Stickers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personaId => integer().nullable().references(Personas, #id)(); // null=全局
  TextColumn get filePath => text()();
  TextColumn get label => text()();
  IntColumn get createdAt => integer()();
}

/// §6.8 朋友圈（P3，先建表不用）
class Moments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get personaId => integer().references(Personas, #id)();
  TextColumn get content => text()();
  IntColumn get postedAt => integer()();
  BoolColumn get likedByUser => boolean().withDefault(const Constant(false))();
  TextColumn get userComment => text().nullable()();
  IntColumn get interactionLoopId => integer().nullable()();
}

/// §6.9 配置（api_key 不在此，走 SecretStore）
class SettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))(); // 单行
  TextColumn get provider => text()();
  TextColumn get baseUrl => text()();
  TextColumn get model => text()();
  TextColumn get activeHours => text().withDefault(const Constant('{}'))();
  IntColumn get dailyProactiveQuota => integer().withDefault(const Constant(5))();
  IntColumn get tokenBudget => integer().withDefault(const Constant(4000))();

  /// 全局“我”——用户昵称与头像（所有数字人共用一个用户身份）。
  TextColumn get userName => text().withDefault(const Constant('我'))();
  TextColumn get userAvatarPath => text().nullable()();

  /// 朋友圈自发活跃度 0–100（0=从不自发，越高越常发）。
  IntColumn get momentFrequency => integer().withDefault(const Constant(30))();

  @override
  Set<Column> get primaryKey => {id};
}
