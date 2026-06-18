// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PersonasTable extends Personas with TableInfo<$PersonasTable, Persona> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personaJsonMeta =
      const VerificationMeta('personaJson');
  @override
  late final GeneratedColumn<String> personaJson = GeneratedColumn<String>(
      'persona_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personaJsonInitialMeta =
      const VerificationMeta('personaJsonInitial');
  @override
  late final GeneratedColumn<String> personaJsonInitial =
      GeneratedColumn<String>('persona_json_initial', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _outwardPersonaJsonMeta =
      const VerificationMeta('outwardPersonaJson');
  @override
  late final GeneratedColumn<String> outwardPersonaJson =
      GeneratedColumn<String>('outward_persona_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _userAliasMeta =
      const VerificationMeta('userAlias');
  @override
  late final GeneratedColumn<String> userAlias = GeneratedColumn<String>(
      'user_alias', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _relationshipMeta =
      const VerificationMeta('relationship');
  @override
  late final GeneratedColumn<String> relationship = GeneratedColumn<String>(
      'relationship', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _proactiveTierMeta =
      const VerificationMeta('proactiveTier');
  @override
  late final GeneratedColumn<int> proactiveTier = GeneratedColumn<int>(
      'proactive_tier', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatarPath,
        personaJson,
        personaJsonInitial,
        outwardPersonaJson,
        userAlias,
        relationship,
        proactiveTier,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personas';
  @override
  VerificationContext validateIntegrity(Insertable<Persona> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('persona_json')) {
      context.handle(
          _personaJsonMeta,
          personaJson.isAcceptableOrUnknown(
              data['persona_json']!, _personaJsonMeta));
    } else if (isInserting) {
      context.missing(_personaJsonMeta);
    }
    if (data.containsKey('persona_json_initial')) {
      context.handle(
          _personaJsonInitialMeta,
          personaJsonInitial.isAcceptableOrUnknown(
              data['persona_json_initial']!, _personaJsonInitialMeta));
    } else if (isInserting) {
      context.missing(_personaJsonInitialMeta);
    }
    if (data.containsKey('outward_persona_json')) {
      context.handle(
          _outwardPersonaJsonMeta,
          outwardPersonaJson.isAcceptableOrUnknown(
              data['outward_persona_json']!, _outwardPersonaJsonMeta));
    }
    if (data.containsKey('user_alias')) {
      context.handle(_userAliasMeta,
          userAlias.isAcceptableOrUnknown(data['user_alias']!, _userAliasMeta));
    }
    if (data.containsKey('relationship')) {
      context.handle(
          _relationshipMeta,
          relationship.isAcceptableOrUnknown(
              data['relationship']!, _relationshipMeta));
    }
    if (data.containsKey('proactive_tier')) {
      context.handle(
          _proactiveTierMeta,
          proactiveTier.isAcceptableOrUnknown(
              data['proactive_tier']!, _proactiveTierMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Persona map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Persona(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      personaJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}persona_json'])!,
      personaJsonInitial: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}persona_json_initial'])!,
      outwardPersonaJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}outward_persona_json']),
      userAlias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_alias']),
      relationship: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}relationship']),
      proactiveTier: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}proactive_tier'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PersonasTable createAlias(String alias) {
    return $PersonasTable(attachedDatabase, alias);
  }
}

class Persona extends DataClass implements Insertable<Persona> {
  final int id;
  final String name;
  final String? avatarPath;
  final String personaJson;
  final String personaJsonInitial;
  final String? outwardPersonaJson;
  final String? userAlias;
  final String? relationship;

  /// 主动找用户的频率档位（0=关闭，见 ProactiveTier）。
  final int proactiveTier;
  final int createdAt;
  final int updatedAt;
  const Persona(
      {required this.id,
      required this.name,
      this.avatarPath,
      required this.personaJson,
      required this.personaJsonInitial,
      this.outwardPersonaJson,
      this.userAlias,
      this.relationship,
      required this.proactiveTier,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['persona_json'] = Variable<String>(personaJson);
    map['persona_json_initial'] = Variable<String>(personaJsonInitial);
    if (!nullToAbsent || outwardPersonaJson != null) {
      map['outward_persona_json'] = Variable<String>(outwardPersonaJson);
    }
    if (!nullToAbsent || userAlias != null) {
      map['user_alias'] = Variable<String>(userAlias);
    }
    if (!nullToAbsent || relationship != null) {
      map['relationship'] = Variable<String>(relationship);
    }
    map['proactive_tier'] = Variable<int>(proactiveTier);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  PersonasCompanion toCompanion(bool nullToAbsent) {
    return PersonasCompanion(
      id: Value(id),
      name: Value(name),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      personaJson: Value(personaJson),
      personaJsonInitial: Value(personaJsonInitial),
      outwardPersonaJson: outwardPersonaJson == null && nullToAbsent
          ? const Value.absent()
          : Value(outwardPersonaJson),
      userAlias: userAlias == null && nullToAbsent
          ? const Value.absent()
          : Value(userAlias),
      relationship: relationship == null && nullToAbsent
          ? const Value.absent()
          : Value(relationship),
      proactiveTier: Value(proactiveTier),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Persona.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Persona(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      personaJson: serializer.fromJson<String>(json['personaJson']),
      personaJsonInitial:
          serializer.fromJson<String>(json['personaJsonInitial']),
      outwardPersonaJson:
          serializer.fromJson<String?>(json['outwardPersonaJson']),
      userAlias: serializer.fromJson<String?>(json['userAlias']),
      relationship: serializer.fromJson<String?>(json['relationship']),
      proactiveTier: serializer.fromJson<int>(json['proactiveTier']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'personaJson': serializer.toJson<String>(personaJson),
      'personaJsonInitial': serializer.toJson<String>(personaJsonInitial),
      'outwardPersonaJson': serializer.toJson<String?>(outwardPersonaJson),
      'userAlias': serializer.toJson<String?>(userAlias),
      'relationship': serializer.toJson<String?>(relationship),
      'proactiveTier': serializer.toJson<int>(proactiveTier),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  Persona copyWith(
          {int? id,
          String? name,
          Value<String?> avatarPath = const Value.absent(),
          String? personaJson,
          String? personaJsonInitial,
          Value<String?> outwardPersonaJson = const Value.absent(),
          Value<String?> userAlias = const Value.absent(),
          Value<String?> relationship = const Value.absent(),
          int? proactiveTier,
          int? createdAt,
          int? updatedAt}) =>
      Persona(
        id: id ?? this.id,
        name: name ?? this.name,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        personaJson: personaJson ?? this.personaJson,
        personaJsonInitial: personaJsonInitial ?? this.personaJsonInitial,
        outwardPersonaJson: outwardPersonaJson.present
            ? outwardPersonaJson.value
            : this.outwardPersonaJson,
        userAlias: userAlias.present ? userAlias.value : this.userAlias,
        relationship:
            relationship.present ? relationship.value : this.relationship,
        proactiveTier: proactiveTier ?? this.proactiveTier,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Persona copyWithCompanion(PersonasCompanion data) {
    return Persona(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      personaJson:
          data.personaJson.present ? data.personaJson.value : this.personaJson,
      personaJsonInitial: data.personaJsonInitial.present
          ? data.personaJsonInitial.value
          : this.personaJsonInitial,
      outwardPersonaJson: data.outwardPersonaJson.present
          ? data.outwardPersonaJson.value
          : this.outwardPersonaJson,
      userAlias: data.userAlias.present ? data.userAlias.value : this.userAlias,
      relationship: data.relationship.present
          ? data.relationship.value
          : this.relationship,
      proactiveTier: data.proactiveTier.present
          ? data.proactiveTier.value
          : this.proactiveTier,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Persona(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('personaJson: $personaJson, ')
          ..write('personaJsonInitial: $personaJsonInitial, ')
          ..write('outwardPersonaJson: $outwardPersonaJson, ')
          ..write('userAlias: $userAlias, ')
          ..write('relationship: $relationship, ')
          ..write('proactiveTier: $proactiveTier, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      avatarPath,
      personaJson,
      personaJsonInitial,
      outwardPersonaJson,
      userAlias,
      relationship,
      proactiveTier,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Persona &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarPath == this.avatarPath &&
          other.personaJson == this.personaJson &&
          other.personaJsonInitial == this.personaJsonInitial &&
          other.outwardPersonaJson == this.outwardPersonaJson &&
          other.userAlias == this.userAlias &&
          other.relationship == this.relationship &&
          other.proactiveTier == this.proactiveTier &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonasCompanion extends UpdateCompanion<Persona> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> avatarPath;
  final Value<String> personaJson;
  final Value<String> personaJsonInitial;
  final Value<String?> outwardPersonaJson;
  final Value<String?> userAlias;
  final Value<String?> relationship;
  final Value<int> proactiveTier;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const PersonasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.personaJson = const Value.absent(),
    this.personaJsonInitial = const Value.absent(),
    this.outwardPersonaJson = const Value.absent(),
    this.userAlias = const Value.absent(),
    this.relationship = const Value.absent(),
    this.proactiveTier = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonasCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatarPath = const Value.absent(),
    required String personaJson,
    required String personaJsonInitial,
    this.outwardPersonaJson = const Value.absent(),
    this.userAlias = const Value.absent(),
    this.relationship = const Value.absent(),
    this.proactiveTier = const Value.absent(),
    required int createdAt,
    required int updatedAt,
  })  : name = Value(name),
        personaJson = Value(personaJson),
        personaJsonInitial = Value(personaJsonInitial),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Persona> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatarPath,
    Expression<String>? personaJson,
    Expression<String>? personaJsonInitial,
    Expression<String>? outwardPersonaJson,
    Expression<String>? userAlias,
    Expression<String>? relationship,
    Expression<int>? proactiveTier,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (personaJson != null) 'persona_json': personaJson,
      if (personaJsonInitial != null)
        'persona_json_initial': personaJsonInitial,
      if (outwardPersonaJson != null)
        'outward_persona_json': outwardPersonaJson,
      if (userAlias != null) 'user_alias': userAlias,
      if (relationship != null) 'relationship': relationship,
      if (proactiveTier != null) 'proactive_tier': proactiveTier,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonasCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? avatarPath,
      Value<String>? personaJson,
      Value<String>? personaJsonInitial,
      Value<String?>? outwardPersonaJson,
      Value<String?>? userAlias,
      Value<String?>? relationship,
      Value<int>? proactiveTier,
      Value<int>? createdAt,
      Value<int>? updatedAt}) {
    return PersonasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      personaJson: personaJson ?? this.personaJson,
      personaJsonInitial: personaJsonInitial ?? this.personaJsonInitial,
      outwardPersonaJson: outwardPersonaJson ?? this.outwardPersonaJson,
      userAlias: userAlias ?? this.userAlias,
      relationship: relationship ?? this.relationship,
      proactiveTier: proactiveTier ?? this.proactiveTier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (personaJson.present) {
      map['persona_json'] = Variable<String>(personaJson.value);
    }
    if (personaJsonInitial.present) {
      map['persona_json_initial'] = Variable<String>(personaJsonInitial.value);
    }
    if (outwardPersonaJson.present) {
      map['outward_persona_json'] = Variable<String>(outwardPersonaJson.value);
    }
    if (userAlias.present) {
      map['user_alias'] = Variable<String>(userAlias.value);
    }
    if (relationship.present) {
      map['relationship'] = Variable<String>(relationship.value);
    }
    if (proactiveTier.present) {
      map['proactive_tier'] = Variable<int>(proactiveTier.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('personaJson: $personaJson, ')
          ..write('personaJsonInitial: $personaJsonInitial, ')
          ..write('outwardPersonaJson: $outwardPersonaJson, ')
          ..write('userAlias: $userAlias, ')
          ..write('relationship: $relationship, ')
          ..write('proactiveTier: $proactiveTier, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages with TableInfo<$MessagesTable, Message> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedColumn<String> sender = GeneratedColumn<String>(
      'sender', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('text'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isProactiveMeta =
      const VerificationMeta('isProactive');
  @override
  late final GeneratedColumn<bool> isProactive = GeneratedColumn<bool>(
      'is_proactive', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_proactive" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, personaId, sender, content, type, createdAt, isProactive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<Message> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('sender')) {
      context.handle(_senderMeta,
          sender.isAcceptableOrUnknown(data['sender']!, _senderMeta));
    } else if (isInserting) {
      context.missing(_senderMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_proactive')) {
      context.handle(
          _isProactiveMeta,
          isProactive.isAcceptableOrUnknown(
              data['is_proactive']!, _isProactiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Message map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Message(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      sender: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      isProactive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_proactive'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class Message extends DataClass implements Insertable<Message> {
  final int id;
  final int personaId;
  final String sender;
  final String content;
  final String type;
  final int createdAt;
  final bool isProactive;
  const Message(
      {required this.id,
      required this.personaId,
      required this.sender,
      required this.content,
      required this.type,
      required this.createdAt,
      required this.isProactive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['sender'] = Variable<String>(sender);
    map['content'] = Variable<String>(content);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<int>(createdAt);
    map['is_proactive'] = Variable<bool>(isProactive);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      personaId: Value(personaId),
      sender: Value(sender),
      content: Value(content),
      type: Value(type),
      createdAt: Value(createdAt),
      isProactive: Value(isProactive),
    );
  }

  factory Message.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Message(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      sender: serializer.fromJson<String>(json['sender']),
      content: serializer.fromJson<String>(json['content']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      isProactive: serializer.fromJson<bool>(json['isProactive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'sender': serializer.toJson<String>(sender),
      'content': serializer.toJson<String>(content),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<int>(createdAt),
      'isProactive': serializer.toJson<bool>(isProactive),
    };
  }

  Message copyWith(
          {int? id,
          int? personaId,
          String? sender,
          String? content,
          String? type,
          int? createdAt,
          bool? isProactive}) =>
      Message(
        id: id ?? this.id,
        personaId: personaId ?? this.personaId,
        sender: sender ?? this.sender,
        content: content ?? this.content,
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        isProactive: isProactive ?? this.isProactive,
      );
  Message copyWithCompanion(MessagesCompanion data) {
    return Message(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      sender: data.sender.present ? data.sender.value : this.sender,
      content: data.content.present ? data.content.value : this.content,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isProactive:
          data.isProactive.present ? data.isProactive.value : this.isProactive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Message(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('isProactive: $isProactive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personaId, sender, content, type, createdAt, isProactive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Message &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.sender == this.sender &&
          other.content == this.content &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.isProactive == this.isProactive);
}

class MessagesCompanion extends UpdateCompanion<Message> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<String> sender;
  final Value<String> content;
  final Value<String> type;
  final Value<int> createdAt;
  final Value<bool> isProactive;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.sender = const Value.absent(),
    this.content = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isProactive = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required String sender,
    required String content,
    this.type = const Value.absent(),
    required int createdAt,
    this.isProactive = const Value.absent(),
  })  : personaId = Value(personaId),
        sender = Value(sender),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<Message> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? sender,
    Expression<String>? content,
    Expression<String>? type,
    Expression<int>? createdAt,
    Expression<bool>? isProactive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (sender != null) 'sender': sender,
      if (content != null) 'content': content,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (isProactive != null) 'is_proactive': isProactive,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? personaId,
      Value<String>? sender,
      Value<String>? content,
      Value<String>? type,
      Value<int>? createdAt,
      Value<bool>? isProactive}) {
    return MessagesCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      sender: sender ?? this.sender,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isProactive: isProactive ?? this.isProactive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (sender.present) {
      map['sender'] = Variable<String>(sender.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (isProactive.present) {
      map['is_proactive'] = Variable<bool>(isProactive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('sender: $sender, ')
          ..write('content: $content, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('isProactive: $isProactive')
          ..write(')'))
        .toString();
  }
}

class $SessionSummariesTable extends SessionSummaries
    with TableInfo<$SessionSummariesTable, SessionSummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionSummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coveredUntilMsgIdMeta =
      const VerificationMeta('coveredUntilMsgId');
  @override
  late final GeneratedColumn<int> coveredUntilMsgId = GeneratedColumn<int>(
      'covered_until_msg_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [personaId, summary, coveredUntilMsgId, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<SessionSummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('covered_until_msg_id')) {
      context.handle(
          _coveredUntilMsgIdMeta,
          coveredUntilMsgId.isAcceptableOrUnknown(
              data['covered_until_msg_id']!, _coveredUntilMsgIdMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {personaId};
  @override
  SessionSummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionSummary(
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary'])!,
      coveredUntilMsgId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}covered_until_msg_id']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SessionSummariesTable createAlias(String alias) {
    return $SessionSummariesTable(attachedDatabase, alias);
  }
}

class SessionSummary extends DataClass implements Insertable<SessionSummary> {
  final int personaId;
  final String summary;
  final int? coveredUntilMsgId;
  final int updatedAt;
  const SessionSummary(
      {required this.personaId,
      required this.summary,
      this.coveredUntilMsgId,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['persona_id'] = Variable<int>(personaId);
    map['summary'] = Variable<String>(summary);
    if (!nullToAbsent || coveredUntilMsgId != null) {
      map['covered_until_msg_id'] = Variable<int>(coveredUntilMsgId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SessionSummariesCompanion toCompanion(bool nullToAbsent) {
    return SessionSummariesCompanion(
      personaId: Value(personaId),
      summary: Value(summary),
      coveredUntilMsgId: coveredUntilMsgId == null && nullToAbsent
          ? const Value.absent()
          : Value(coveredUntilMsgId),
      updatedAt: Value(updatedAt),
    );
  }

  factory SessionSummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionSummary(
      personaId: serializer.fromJson<int>(json['personaId']),
      summary: serializer.fromJson<String>(json['summary']),
      coveredUntilMsgId: serializer.fromJson<int?>(json['coveredUntilMsgId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'personaId': serializer.toJson<int>(personaId),
      'summary': serializer.toJson<String>(summary),
      'coveredUntilMsgId': serializer.toJson<int?>(coveredUntilMsgId),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SessionSummary copyWith(
          {int? personaId,
          String? summary,
          Value<int?> coveredUntilMsgId = const Value.absent(),
          int? updatedAt}) =>
      SessionSummary(
        personaId: personaId ?? this.personaId,
        summary: summary ?? this.summary,
        coveredUntilMsgId: coveredUntilMsgId.present
            ? coveredUntilMsgId.value
            : this.coveredUntilMsgId,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SessionSummary copyWithCompanion(SessionSummariesCompanion data) {
    return SessionSummary(
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      summary: data.summary.present ? data.summary.value : this.summary,
      coveredUntilMsgId: data.coveredUntilMsgId.present
          ? data.coveredUntilMsgId.value
          : this.coveredUntilMsgId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionSummary(')
          ..write('personaId: $personaId, ')
          ..write('summary: $summary, ')
          ..write('coveredUntilMsgId: $coveredUntilMsgId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(personaId, summary, coveredUntilMsgId, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionSummary &&
          other.personaId == this.personaId &&
          other.summary == this.summary &&
          other.coveredUntilMsgId == this.coveredUntilMsgId &&
          other.updatedAt == this.updatedAt);
}

class SessionSummariesCompanion extends UpdateCompanion<SessionSummary> {
  final Value<int> personaId;
  final Value<String> summary;
  final Value<int?> coveredUntilMsgId;
  final Value<int> updatedAt;
  const SessionSummariesCompanion({
    this.personaId = const Value.absent(),
    this.summary = const Value.absent(),
    this.coveredUntilMsgId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SessionSummariesCompanion.insert({
    this.personaId = const Value.absent(),
    this.summary = const Value.absent(),
    this.coveredUntilMsgId = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<SessionSummary> custom({
    Expression<int>? personaId,
    Expression<String>? summary,
    Expression<int>? coveredUntilMsgId,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (personaId != null) 'persona_id': personaId,
      if (summary != null) 'summary': summary,
      if (coveredUntilMsgId != null) 'covered_until_msg_id': coveredUntilMsgId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SessionSummariesCompanion copyWith(
      {Value<int>? personaId,
      Value<String>? summary,
      Value<int?>? coveredUntilMsgId,
      Value<int>? updatedAt}) {
    return SessionSummariesCompanion(
      personaId: personaId ?? this.personaId,
      summary: summary ?? this.summary,
      coveredUntilMsgId: coveredUntilMsgId ?? this.coveredUntilMsgId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (coveredUntilMsgId.present) {
      map['covered_until_msg_id'] = Variable<int>(coveredUntilMsgId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionSummariesCompanion(')
          ..write('personaId: $personaId, ')
          ..write('summary: $summary, ')
          ..write('coveredUntilMsgId: $coveredUntilMsgId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FactsTable extends Facts with TableInfo<$FactsTable, Fact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _importanceMeta =
      const VerificationMeta('importance');
  @override
  late final GeneratedColumn<double> importance = GeneratedColumn<double>(
      'importance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.5));
  static const VerificationMeta _lastReferencedAtMeta =
      const VerificationMeta('lastReferencedAt');
  @override
  late final GeneratedColumn<int> lastReferencedAt = GeneratedColumn<int>(
      'last_referenced_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _pinnedMeta = const VerificationMeta('pinned');
  @override
  late final GeneratedColumn<bool> pinned = GeneratedColumn<bool>(
      'pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _supersededByMeta =
      const VerificationMeta('supersededBy');
  @override
  late final GeneratedColumn<int> supersededBy = GeneratedColumn<int>(
      'superseded_by', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _validMeta = const VerificationMeta('valid');
  @override
  late final GeneratedColumn<bool> valid = GeneratedColumn<bool>(
      'valid', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("valid" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personaId,
        content,
        importance,
        lastReferencedAt,
        pinned,
        supersededBy,
        valid,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'facts';
  @override
  VerificationContext validateIntegrity(Insertable<Fact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('importance')) {
      context.handle(
          _importanceMeta,
          importance.isAcceptableOrUnknown(
              data['importance']!, _importanceMeta));
    }
    if (data.containsKey('last_referenced_at')) {
      context.handle(
          _lastReferencedAtMeta,
          lastReferencedAt.isAcceptableOrUnknown(
              data['last_referenced_at']!, _lastReferencedAtMeta));
    } else if (isInserting) {
      context.missing(_lastReferencedAtMeta);
    }
    if (data.containsKey('pinned')) {
      context.handle(_pinnedMeta,
          pinned.isAcceptableOrUnknown(data['pinned']!, _pinnedMeta));
    }
    if (data.containsKey('superseded_by')) {
      context.handle(
          _supersededByMeta,
          supersededBy.isAcceptableOrUnknown(
              data['superseded_by']!, _supersededByMeta));
    }
    if (data.containsKey('valid')) {
      context.handle(
          _validMeta, valid.isAcceptableOrUnknown(data['valid']!, _validMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Fact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Fact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      importance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}importance'])!,
      lastReferencedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_referenced_at'])!,
      pinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}pinned'])!,
      supersededBy: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}superseded_by']),
      valid: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}valid'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FactsTable createAlias(String alias) {
    return $FactsTable(attachedDatabase, alias);
  }
}

class Fact extends DataClass implements Insertable<Fact> {
  final int id;
  final int personaId;
  final String content;
  final double importance;
  final int lastReferencedAt;
  final bool pinned;
  final int? supersededBy;
  final bool valid;
  final int createdAt;
  const Fact(
      {required this.id,
      required this.personaId,
      required this.content,
      required this.importance,
      required this.lastReferencedAt,
      required this.pinned,
      this.supersededBy,
      required this.valid,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['content'] = Variable<String>(content);
    map['importance'] = Variable<double>(importance);
    map['last_referenced_at'] = Variable<int>(lastReferencedAt);
    map['pinned'] = Variable<bool>(pinned);
    if (!nullToAbsent || supersededBy != null) {
      map['superseded_by'] = Variable<int>(supersededBy);
    }
    map['valid'] = Variable<bool>(valid);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  FactsCompanion toCompanion(bool nullToAbsent) {
    return FactsCompanion(
      id: Value(id),
      personaId: Value(personaId),
      content: Value(content),
      importance: Value(importance),
      lastReferencedAt: Value(lastReferencedAt),
      pinned: Value(pinned),
      supersededBy: supersededBy == null && nullToAbsent
          ? const Value.absent()
          : Value(supersededBy),
      valid: Value(valid),
      createdAt: Value(createdAt),
    );
  }

  factory Fact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Fact(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      content: serializer.fromJson<String>(json['content']),
      importance: serializer.fromJson<double>(json['importance']),
      lastReferencedAt: serializer.fromJson<int>(json['lastReferencedAt']),
      pinned: serializer.fromJson<bool>(json['pinned']),
      supersededBy: serializer.fromJson<int?>(json['supersededBy']),
      valid: serializer.fromJson<bool>(json['valid']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'content': serializer.toJson<String>(content),
      'importance': serializer.toJson<double>(importance),
      'lastReferencedAt': serializer.toJson<int>(lastReferencedAt),
      'pinned': serializer.toJson<bool>(pinned),
      'supersededBy': serializer.toJson<int?>(supersededBy),
      'valid': serializer.toJson<bool>(valid),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Fact copyWith(
          {int? id,
          int? personaId,
          String? content,
          double? importance,
          int? lastReferencedAt,
          bool? pinned,
          Value<int?> supersededBy = const Value.absent(),
          bool? valid,
          int? createdAt}) =>
      Fact(
        id: id ?? this.id,
        personaId: personaId ?? this.personaId,
        content: content ?? this.content,
        importance: importance ?? this.importance,
        lastReferencedAt: lastReferencedAt ?? this.lastReferencedAt,
        pinned: pinned ?? this.pinned,
        supersededBy:
            supersededBy.present ? supersededBy.value : this.supersededBy,
        valid: valid ?? this.valid,
        createdAt: createdAt ?? this.createdAt,
      );
  Fact copyWithCompanion(FactsCompanion data) {
    return Fact(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      content: data.content.present ? data.content.value : this.content,
      importance:
          data.importance.present ? data.importance.value : this.importance,
      lastReferencedAt: data.lastReferencedAt.present
          ? data.lastReferencedAt.value
          : this.lastReferencedAt,
      pinned: data.pinned.present ? data.pinned.value : this.pinned,
      supersededBy: data.supersededBy.present
          ? data.supersededBy.value
          : this.supersededBy,
      valid: data.valid.present ? data.valid.value : this.valid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Fact(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('importance: $importance, ')
          ..write('lastReferencedAt: $lastReferencedAt, ')
          ..write('pinned: $pinned, ')
          ..write('supersededBy: $supersededBy, ')
          ..write('valid: $valid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personaId, content, importance,
      lastReferencedAt, pinned, supersededBy, valid, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Fact &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.content == this.content &&
          other.importance == this.importance &&
          other.lastReferencedAt == this.lastReferencedAt &&
          other.pinned == this.pinned &&
          other.supersededBy == this.supersededBy &&
          other.valid == this.valid &&
          other.createdAt == this.createdAt);
}

class FactsCompanion extends UpdateCompanion<Fact> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<String> content;
  final Value<double> importance;
  final Value<int> lastReferencedAt;
  final Value<bool> pinned;
  final Value<int?> supersededBy;
  final Value<bool> valid;
  final Value<int> createdAt;
  const FactsCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.content = const Value.absent(),
    this.importance = const Value.absent(),
    this.lastReferencedAt = const Value.absent(),
    this.pinned = const Value.absent(),
    this.supersededBy = const Value.absent(),
    this.valid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FactsCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required String content,
    this.importance = const Value.absent(),
    required int lastReferencedAt,
    this.pinned = const Value.absent(),
    this.supersededBy = const Value.absent(),
    this.valid = const Value.absent(),
    required int createdAt,
  })  : personaId = Value(personaId),
        content = Value(content),
        lastReferencedAt = Value(lastReferencedAt),
        createdAt = Value(createdAt);
  static Insertable<Fact> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? content,
    Expression<double>? importance,
    Expression<int>? lastReferencedAt,
    Expression<bool>? pinned,
    Expression<int>? supersededBy,
    Expression<bool>? valid,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (content != null) 'content': content,
      if (importance != null) 'importance': importance,
      if (lastReferencedAt != null) 'last_referenced_at': lastReferencedAt,
      if (pinned != null) 'pinned': pinned,
      if (supersededBy != null) 'superseded_by': supersededBy,
      if (valid != null) 'valid': valid,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FactsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personaId,
      Value<String>? content,
      Value<double>? importance,
      Value<int>? lastReferencedAt,
      Value<bool>? pinned,
      Value<int?>? supersededBy,
      Value<bool>? valid,
      Value<int>? createdAt}) {
    return FactsCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      content: content ?? this.content,
      importance: importance ?? this.importance,
      lastReferencedAt: lastReferencedAt ?? this.lastReferencedAt,
      pinned: pinned ?? this.pinned,
      supersededBy: supersededBy ?? this.supersededBy,
      valid: valid ?? this.valid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (importance.present) {
      map['importance'] = Variable<double>(importance.value);
    }
    if (lastReferencedAt.present) {
      map['last_referenced_at'] = Variable<int>(lastReferencedAt.value);
    }
    if (pinned.present) {
      map['pinned'] = Variable<bool>(pinned.value);
    }
    if (supersededBy.present) {
      map['superseded_by'] = Variable<int>(supersededBy.value);
    }
    if (valid.present) {
      map['valid'] = Variable<bool>(valid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FactsCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('importance: $importance, ')
          ..write('lastReferencedAt: $lastReferencedAt, ')
          ..write('pinned: $pinned, ')
          ..write('supersededBy: $supersededBy, ')
          ..write('valid: $valid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RelationshipStatesTable extends RelationshipStates
    with TableInfo<$RelationshipStatesTable, RelationshipState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
      'mood', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _closenessMeta =
      const VerificationMeta('closeness');
  @override
  late final GeneratedColumn<double> closeness = GeneratedColumn<double>(
      'closeness', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.5));
  static const VerificationMeta _unresolvedMeta =
      const VerificationMeta('unresolved');
  @override
  late final GeneratedColumn<String> unresolved = GeneratedColumn<String>(
      'unresolved', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [personaId, mood, closeness, unresolved, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationship_states';
  @override
  VerificationContext validateIntegrity(Insertable<RelationshipState> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    }
    if (data.containsKey('mood')) {
      context.handle(
          _moodMeta, mood.isAcceptableOrUnknown(data['mood']!, _moodMeta));
    }
    if (data.containsKey('closeness')) {
      context.handle(_closenessMeta,
          closeness.isAcceptableOrUnknown(data['closeness']!, _closenessMeta));
    }
    if (data.containsKey('unresolved')) {
      context.handle(
          _unresolvedMeta,
          unresolved.isAcceptableOrUnknown(
              data['unresolved']!, _unresolvedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {personaId};
  @override
  RelationshipState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationshipState(
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      mood: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mood'])!,
      closeness: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}closeness'])!,
      unresolved: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unresolved'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RelationshipStatesTable createAlias(String alias) {
    return $RelationshipStatesTable(attachedDatabase, alias);
  }
}

class RelationshipState extends DataClass
    implements Insertable<RelationshipState> {
  final int personaId;
  final String mood;
  final double closeness;
  final String unresolved;
  final int updatedAt;
  const RelationshipState(
      {required this.personaId,
      required this.mood,
      required this.closeness,
      required this.unresolved,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['persona_id'] = Variable<int>(personaId);
    map['mood'] = Variable<String>(mood);
    map['closeness'] = Variable<double>(closeness);
    map['unresolved'] = Variable<String>(unresolved);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  RelationshipStatesCompanion toCompanion(bool nullToAbsent) {
    return RelationshipStatesCompanion(
      personaId: Value(personaId),
      mood: Value(mood),
      closeness: Value(closeness),
      unresolved: Value(unresolved),
      updatedAt: Value(updatedAt),
    );
  }

  factory RelationshipState.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationshipState(
      personaId: serializer.fromJson<int>(json['personaId']),
      mood: serializer.fromJson<String>(json['mood']),
      closeness: serializer.fromJson<double>(json['closeness']),
      unresolved: serializer.fromJson<String>(json['unresolved']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'personaId': serializer.toJson<int>(personaId),
      'mood': serializer.toJson<String>(mood),
      'closeness': serializer.toJson<double>(closeness),
      'unresolved': serializer.toJson<String>(unresolved),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  RelationshipState copyWith(
          {int? personaId,
          String? mood,
          double? closeness,
          String? unresolved,
          int? updatedAt}) =>
      RelationshipState(
        personaId: personaId ?? this.personaId,
        mood: mood ?? this.mood,
        closeness: closeness ?? this.closeness,
        unresolved: unresolved ?? this.unresolved,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RelationshipState copyWithCompanion(RelationshipStatesCompanion data) {
    return RelationshipState(
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      mood: data.mood.present ? data.mood.value : this.mood,
      closeness: data.closeness.present ? data.closeness.value : this.closeness,
      unresolved:
          data.unresolved.present ? data.unresolved.value : this.unresolved,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipState(')
          ..write('personaId: $personaId, ')
          ..write('mood: $mood, ')
          ..write('closeness: $closeness, ')
          ..write('unresolved: $unresolved, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(personaId, mood, closeness, unresolved, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationshipState &&
          other.personaId == this.personaId &&
          other.mood == this.mood &&
          other.closeness == this.closeness &&
          other.unresolved == this.unresolved &&
          other.updatedAt == this.updatedAt);
}

class RelationshipStatesCompanion extends UpdateCompanion<RelationshipState> {
  final Value<int> personaId;
  final Value<String> mood;
  final Value<double> closeness;
  final Value<String> unresolved;
  final Value<int> updatedAt;
  const RelationshipStatesCompanion({
    this.personaId = const Value.absent(),
    this.mood = const Value.absent(),
    this.closeness = const Value.absent(),
    this.unresolved = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  RelationshipStatesCompanion.insert({
    this.personaId = const Value.absent(),
    this.mood = const Value.absent(),
    this.closeness = const Value.absent(),
    this.unresolved = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<RelationshipState> custom({
    Expression<int>? personaId,
    Expression<String>? mood,
    Expression<double>? closeness,
    Expression<String>? unresolved,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (personaId != null) 'persona_id': personaId,
      if (mood != null) 'mood': mood,
      if (closeness != null) 'closeness': closeness,
      if (unresolved != null) 'unresolved': unresolved,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  RelationshipStatesCompanion copyWith(
      {Value<int>? personaId,
      Value<String>? mood,
      Value<double>? closeness,
      Value<String>? unresolved,
      Value<int>? updatedAt}) {
    return RelationshipStatesCompanion(
      personaId: personaId ?? this.personaId,
      mood: mood ?? this.mood,
      closeness: closeness ?? this.closeness,
      unresolved: unresolved ?? this.unresolved,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (closeness.present) {
      map['closeness'] = Variable<double>(closeness.value);
    }
    if (unresolved.present) {
      map['unresolved'] = Variable<String>(unresolved.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipStatesCompanion(')
          ..write('personaId: $personaId, ')
          ..write('mood: $mood, ')
          ..write('closeness: $closeness, ')
          ..write('unresolved: $unresolved, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $OpenLoopsTable extends OpenLoops
    with TableInfo<$OpenLoopsTable, OpenLoop> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpenLoopsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _eventMeta = const VerificationMeta('event');
  @override
  late final GeneratedColumn<String> event = GeneratedColumn<String>(
      'event', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _plannedActionMeta =
      const VerificationMeta('plannedAction');
  @override
  late final GeneratedColumn<String> plannedAction = GeneratedColumn<String>(
      'planned_action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerTypeMeta =
      const VerificationMeta('triggerType');
  @override
  late final GeneratedColumn<String> triggerType = GeneratedColumn<String>(
      'trigger_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _triggerAtMeta =
      const VerificationMeta('triggerAt');
  @override
  late final GeneratedColumn<int> triggerAt = GeneratedColumn<int>(
      'trigger_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _importanceMeta =
      const VerificationMeta('importance');
  @override
  late final GeneratedColumn<double> importance = GeneratedColumn<double>(
      'importance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.5));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personaId,
        event,
        plannedAction,
        triggerType,
        triggerAt,
        importance,
        status,
        notificationId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'open_loops';
  @override
  VerificationContext validateIntegrity(Insertable<OpenLoop> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('event')) {
      context.handle(
          _eventMeta, event.isAcceptableOrUnknown(data['event']!, _eventMeta));
    } else if (isInserting) {
      context.missing(_eventMeta);
    }
    if (data.containsKey('planned_action')) {
      context.handle(
          _plannedActionMeta,
          plannedAction.isAcceptableOrUnknown(
              data['planned_action']!, _plannedActionMeta));
    } else if (isInserting) {
      context.missing(_plannedActionMeta);
    }
    if (data.containsKey('trigger_type')) {
      context.handle(
          _triggerTypeMeta,
          triggerType.isAcceptableOrUnknown(
              data['trigger_type']!, _triggerTypeMeta));
    } else if (isInserting) {
      context.missing(_triggerTypeMeta);
    }
    if (data.containsKey('trigger_at')) {
      context.handle(_triggerAtMeta,
          triggerAt.isAcceptableOrUnknown(data['trigger_at']!, _triggerAtMeta));
    }
    if (data.containsKey('importance')) {
      context.handle(
          _importanceMeta,
          importance.isAcceptableOrUnknown(
              data['importance']!, _importanceMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpenLoop map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpenLoop(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      event: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event'])!,
      plannedAction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}planned_action'])!,
      triggerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}trigger_type'])!,
      triggerAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}trigger_at']),
      importance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}importance'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OpenLoopsTable createAlias(String alias) {
    return $OpenLoopsTable(attachedDatabase, alias);
  }
}

class OpenLoop extends DataClass implements Insertable<OpenLoop> {
  final int id;
  final int personaId;
  final String event;
  final String plannedAction;
  final String triggerType;
  final int? triggerAt;
  final double importance;
  final String status;
  final int? notificationId;
  final int createdAt;
  const OpenLoop(
      {required this.id,
      required this.personaId,
      required this.event,
      required this.plannedAction,
      required this.triggerType,
      this.triggerAt,
      required this.importance,
      required this.status,
      this.notificationId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['event'] = Variable<String>(event);
    map['planned_action'] = Variable<String>(plannedAction);
    map['trigger_type'] = Variable<String>(triggerType);
    if (!nullToAbsent || triggerAt != null) {
      map['trigger_at'] = Variable<int>(triggerAt);
    }
    map['importance'] = Variable<double>(importance);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  OpenLoopsCompanion toCompanion(bool nullToAbsent) {
    return OpenLoopsCompanion(
      id: Value(id),
      personaId: Value(personaId),
      event: Value(event),
      plannedAction: Value(plannedAction),
      triggerType: Value(triggerType),
      triggerAt: triggerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(triggerAt),
      importance: Value(importance),
      status: Value(status),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      createdAt: Value(createdAt),
    );
  }

  factory OpenLoop.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpenLoop(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      event: serializer.fromJson<String>(json['event']),
      plannedAction: serializer.fromJson<String>(json['plannedAction']),
      triggerType: serializer.fromJson<String>(json['triggerType']),
      triggerAt: serializer.fromJson<int?>(json['triggerAt']),
      importance: serializer.fromJson<double>(json['importance']),
      status: serializer.fromJson<String>(json['status']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'event': serializer.toJson<String>(event),
      'plannedAction': serializer.toJson<String>(plannedAction),
      'triggerType': serializer.toJson<String>(triggerType),
      'triggerAt': serializer.toJson<int?>(triggerAt),
      'importance': serializer.toJson<double>(importance),
      'status': serializer.toJson<String>(status),
      'notificationId': serializer.toJson<int?>(notificationId),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  OpenLoop copyWith(
          {int? id,
          int? personaId,
          String? event,
          String? plannedAction,
          String? triggerType,
          Value<int?> triggerAt = const Value.absent(),
          double? importance,
          String? status,
          Value<int?> notificationId = const Value.absent(),
          int? createdAt}) =>
      OpenLoop(
        id: id ?? this.id,
        personaId: personaId ?? this.personaId,
        event: event ?? this.event,
        plannedAction: plannedAction ?? this.plannedAction,
        triggerType: triggerType ?? this.triggerType,
        triggerAt: triggerAt.present ? triggerAt.value : this.triggerAt,
        importance: importance ?? this.importance,
        status: status ?? this.status,
        notificationId:
            notificationId.present ? notificationId.value : this.notificationId,
        createdAt: createdAt ?? this.createdAt,
      );
  OpenLoop copyWithCompanion(OpenLoopsCompanion data) {
    return OpenLoop(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      event: data.event.present ? data.event.value : this.event,
      plannedAction: data.plannedAction.present
          ? data.plannedAction.value
          : this.plannedAction,
      triggerType:
          data.triggerType.present ? data.triggerType.value : this.triggerType,
      triggerAt: data.triggerAt.present ? data.triggerAt.value : this.triggerAt,
      importance:
          data.importance.present ? data.importance.value : this.importance,
      status: data.status.present ? data.status.value : this.status,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpenLoop(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('event: $event, ')
          ..write('plannedAction: $plannedAction, ')
          ..write('triggerType: $triggerType, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('importance: $importance, ')
          ..write('status: $status, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personaId, event, plannedAction,
      triggerType, triggerAt, importance, status, notificationId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpenLoop &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.event == this.event &&
          other.plannedAction == this.plannedAction &&
          other.triggerType == this.triggerType &&
          other.triggerAt == this.triggerAt &&
          other.importance == this.importance &&
          other.status == this.status &&
          other.notificationId == this.notificationId &&
          other.createdAt == this.createdAt);
}

class OpenLoopsCompanion extends UpdateCompanion<OpenLoop> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<String> event;
  final Value<String> plannedAction;
  final Value<String> triggerType;
  final Value<int?> triggerAt;
  final Value<double> importance;
  final Value<String> status;
  final Value<int?> notificationId;
  final Value<int> createdAt;
  const OpenLoopsCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.event = const Value.absent(),
    this.plannedAction = const Value.absent(),
    this.triggerType = const Value.absent(),
    this.triggerAt = const Value.absent(),
    this.importance = const Value.absent(),
    this.status = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OpenLoopsCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required String event,
    required String plannedAction,
    required String triggerType,
    this.triggerAt = const Value.absent(),
    this.importance = const Value.absent(),
    this.status = const Value.absent(),
    this.notificationId = const Value.absent(),
    required int createdAt,
  })  : personaId = Value(personaId),
        event = Value(event),
        plannedAction = Value(plannedAction),
        triggerType = Value(triggerType),
        createdAt = Value(createdAt);
  static Insertable<OpenLoop> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? event,
    Expression<String>? plannedAction,
    Expression<String>? triggerType,
    Expression<int>? triggerAt,
    Expression<double>? importance,
    Expression<String>? status,
    Expression<int>? notificationId,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (event != null) 'event': event,
      if (plannedAction != null) 'planned_action': plannedAction,
      if (triggerType != null) 'trigger_type': triggerType,
      if (triggerAt != null) 'trigger_at': triggerAt,
      if (importance != null) 'importance': importance,
      if (status != null) 'status': status,
      if (notificationId != null) 'notification_id': notificationId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OpenLoopsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personaId,
      Value<String>? event,
      Value<String>? plannedAction,
      Value<String>? triggerType,
      Value<int?>? triggerAt,
      Value<double>? importance,
      Value<String>? status,
      Value<int?>? notificationId,
      Value<int>? createdAt}) {
    return OpenLoopsCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      event: event ?? this.event,
      plannedAction: plannedAction ?? this.plannedAction,
      triggerType: triggerType ?? this.triggerType,
      triggerAt: triggerAt ?? this.triggerAt,
      importance: importance ?? this.importance,
      status: status ?? this.status,
      notificationId: notificationId ?? this.notificationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (event.present) {
      map['event'] = Variable<String>(event.value);
    }
    if (plannedAction.present) {
      map['planned_action'] = Variable<String>(plannedAction.value);
    }
    if (triggerType.present) {
      map['trigger_type'] = Variable<String>(triggerType.value);
    }
    if (triggerAt.present) {
      map['trigger_at'] = Variable<int>(triggerAt.value);
    }
    if (importance.present) {
      map['importance'] = Variable<double>(importance.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpenLoopsCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('event: $event, ')
          ..write('plannedAction: $plannedAction, ')
          ..write('triggerType: $triggerType, ')
          ..write('triggerAt: $triggerAt, ')
          ..write('importance: $importance, ')
          ..write('status: $status, ')
          ..write('notificationId: $notificationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $StickersTable extends Stickers with TableInfo<$StickersTable, Sticker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StickersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _filePathMeta =
      const VerificationMeta('filePath');
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
      'file_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, personaId, filePath, label, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stickers';
  @override
  VerificationContext validateIntegrity(Insertable<Sticker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    }
    if (data.containsKey('file_path')) {
      context.handle(_filePathMeta,
          filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta));
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sticker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sticker(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id']),
      filePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_path'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StickersTable createAlias(String alias) {
    return $StickersTable(attachedDatabase, alias);
  }
}

class Sticker extends DataClass implements Insertable<Sticker> {
  final int id;
  final int? personaId;
  final String filePath;
  final String label;
  final int createdAt;
  const Sticker(
      {required this.id,
      this.personaId,
      required this.filePath,
      required this.label,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || personaId != null) {
      map['persona_id'] = Variable<int>(personaId);
    }
    map['file_path'] = Variable<String>(filePath);
    map['label'] = Variable<String>(label);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  StickersCompanion toCompanion(bool nullToAbsent) {
    return StickersCompanion(
      id: Value(id),
      personaId: personaId == null && nullToAbsent
          ? const Value.absent()
          : Value(personaId),
      filePath: Value(filePath),
      label: Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory Sticker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sticker(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int?>(json['personaId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      label: serializer.fromJson<String>(json['label']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int?>(personaId),
      'filePath': serializer.toJson<String>(filePath),
      'label': serializer.toJson<String>(label),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Sticker copyWith(
          {int? id,
          Value<int?> personaId = const Value.absent(),
          String? filePath,
          String? label,
          int? createdAt}) =>
      Sticker(
        id: id ?? this.id,
        personaId: personaId.present ? personaId.value : this.personaId,
        filePath: filePath ?? this.filePath,
        label: label ?? this.label,
        createdAt: createdAt ?? this.createdAt,
      );
  Sticker copyWithCompanion(StickersCompanion data) {
    return Sticker(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sticker(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('filePath: $filePath, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personaId, filePath, label, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sticker &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.filePath == this.filePath &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class StickersCompanion extends UpdateCompanion<Sticker> {
  final Value<int> id;
  final Value<int?> personaId;
  final Value<String> filePath;
  final Value<String> label;
  final Value<int> createdAt;
  const StickersCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  StickersCompanion.insert({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    required String filePath,
    required String label,
    required int createdAt,
  })  : filePath = Value(filePath),
        label = Value(label),
        createdAt = Value(createdAt);
  static Insertable<Sticker> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? filePath,
    Expression<String>? label,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (filePath != null) 'file_path': filePath,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  StickersCompanion copyWith(
      {Value<int>? id,
      Value<int?>? personaId,
      Value<String>? filePath,
      Value<String>? label,
      Value<int>? createdAt}) {
    return StickersCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      filePath: filePath ?? this.filePath,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StickersCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('filePath: $filePath, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MomentsTable extends Moments with TableInfo<$MomentsTable, Moment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MomentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _postedAtMeta =
      const VerificationMeta('postedAt');
  @override
  late final GeneratedColumn<int> postedAt = GeneratedColumn<int>(
      'posted_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _likedByUserMeta =
      const VerificationMeta('likedByUser');
  @override
  late final GeneratedColumn<bool> likedByUser = GeneratedColumn<bool>(
      'liked_by_user', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("liked_by_user" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _userCommentMeta =
      const VerificationMeta('userComment');
  @override
  late final GeneratedColumn<String> userComment = GeneratedColumn<String>(
      'user_comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _interactionLoopIdMeta =
      const VerificationMeta('interactionLoopId');
  @override
  late final GeneratedColumn<int> interactionLoopId = GeneratedColumn<int>(
      'interaction_loop_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        personaId,
        content,
        postedAt,
        likedByUser,
        userComment,
        interactionLoopId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'moments';
  @override
  VerificationContext validateIntegrity(Insertable<Moment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('posted_at')) {
      context.handle(_postedAtMeta,
          postedAt.isAcceptableOrUnknown(data['posted_at']!, _postedAtMeta));
    } else if (isInserting) {
      context.missing(_postedAtMeta);
    }
    if (data.containsKey('liked_by_user')) {
      context.handle(
          _likedByUserMeta,
          likedByUser.isAcceptableOrUnknown(
              data['liked_by_user']!, _likedByUserMeta));
    }
    if (data.containsKey('user_comment')) {
      context.handle(
          _userCommentMeta,
          userComment.isAcceptableOrUnknown(
              data['user_comment']!, _userCommentMeta));
    }
    if (data.containsKey('interaction_loop_id')) {
      context.handle(
          _interactionLoopIdMeta,
          interactionLoopId.isAcceptableOrUnknown(
              data['interaction_loop_id']!, _interactionLoopIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Moment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Moment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      postedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}posted_at'])!,
      likedByUser: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}liked_by_user'])!,
      userComment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_comment']),
      interactionLoopId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}interaction_loop_id']),
    );
  }

  @override
  $MomentsTable createAlias(String alias) {
    return $MomentsTable(attachedDatabase, alias);
  }
}

class Moment extends DataClass implements Insertable<Moment> {
  final int id;
  final int personaId;
  final String content;
  final int postedAt;
  final bool likedByUser;
  final String? userComment;
  final int? interactionLoopId;
  const Moment(
      {required this.id,
      required this.personaId,
      required this.content,
      required this.postedAt,
      required this.likedByUser,
      this.userComment,
      this.interactionLoopId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['content'] = Variable<String>(content);
    map['posted_at'] = Variable<int>(postedAt);
    map['liked_by_user'] = Variable<bool>(likedByUser);
    if (!nullToAbsent || userComment != null) {
      map['user_comment'] = Variable<String>(userComment);
    }
    if (!nullToAbsent || interactionLoopId != null) {
      map['interaction_loop_id'] = Variable<int>(interactionLoopId);
    }
    return map;
  }

  MomentsCompanion toCompanion(bool nullToAbsent) {
    return MomentsCompanion(
      id: Value(id),
      personaId: Value(personaId),
      content: Value(content),
      postedAt: Value(postedAt),
      likedByUser: Value(likedByUser),
      userComment: userComment == null && nullToAbsent
          ? const Value.absent()
          : Value(userComment),
      interactionLoopId: interactionLoopId == null && nullToAbsent
          ? const Value.absent()
          : Value(interactionLoopId),
    );
  }

  factory Moment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Moment(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      content: serializer.fromJson<String>(json['content']),
      postedAt: serializer.fromJson<int>(json['postedAt']),
      likedByUser: serializer.fromJson<bool>(json['likedByUser']),
      userComment: serializer.fromJson<String?>(json['userComment']),
      interactionLoopId: serializer.fromJson<int?>(json['interactionLoopId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'content': serializer.toJson<String>(content),
      'postedAt': serializer.toJson<int>(postedAt),
      'likedByUser': serializer.toJson<bool>(likedByUser),
      'userComment': serializer.toJson<String?>(userComment),
      'interactionLoopId': serializer.toJson<int?>(interactionLoopId),
    };
  }

  Moment copyWith(
          {int? id,
          int? personaId,
          String? content,
          int? postedAt,
          bool? likedByUser,
          Value<String?> userComment = const Value.absent(),
          Value<int?> interactionLoopId = const Value.absent()}) =>
      Moment(
        id: id ?? this.id,
        personaId: personaId ?? this.personaId,
        content: content ?? this.content,
        postedAt: postedAt ?? this.postedAt,
        likedByUser: likedByUser ?? this.likedByUser,
        userComment: userComment.present ? userComment.value : this.userComment,
        interactionLoopId: interactionLoopId.present
            ? interactionLoopId.value
            : this.interactionLoopId,
      );
  Moment copyWithCompanion(MomentsCompanion data) {
    return Moment(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      content: data.content.present ? data.content.value : this.content,
      postedAt: data.postedAt.present ? data.postedAt.value : this.postedAt,
      likedByUser:
          data.likedByUser.present ? data.likedByUser.value : this.likedByUser,
      userComment:
          data.userComment.present ? data.userComment.value : this.userComment,
      interactionLoopId: data.interactionLoopId.present
          ? data.interactionLoopId.value
          : this.interactionLoopId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Moment(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('postedAt: $postedAt, ')
          ..write('likedByUser: $likedByUser, ')
          ..write('userComment: $userComment, ')
          ..write('interactionLoopId: $interactionLoopId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, personaId, content, postedAt, likedByUser,
      userComment, interactionLoopId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Moment &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.content == this.content &&
          other.postedAt == this.postedAt &&
          other.likedByUser == this.likedByUser &&
          other.userComment == this.userComment &&
          other.interactionLoopId == this.interactionLoopId);
}

class MomentsCompanion extends UpdateCompanion<Moment> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<String> content;
  final Value<int> postedAt;
  final Value<bool> likedByUser;
  final Value<String?> userComment;
  final Value<int?> interactionLoopId;
  const MomentsCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.content = const Value.absent(),
    this.postedAt = const Value.absent(),
    this.likedByUser = const Value.absent(),
    this.userComment = const Value.absent(),
    this.interactionLoopId = const Value.absent(),
  });
  MomentsCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required String content,
    required int postedAt,
    this.likedByUser = const Value.absent(),
    this.userComment = const Value.absent(),
    this.interactionLoopId = const Value.absent(),
  })  : personaId = Value(personaId),
        content = Value(content),
        postedAt = Value(postedAt);
  static Insertable<Moment> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? content,
    Expression<int>? postedAt,
    Expression<bool>? likedByUser,
    Expression<String>? userComment,
    Expression<int>? interactionLoopId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (content != null) 'content': content,
      if (postedAt != null) 'posted_at': postedAt,
      if (likedByUser != null) 'liked_by_user': likedByUser,
      if (userComment != null) 'user_comment': userComment,
      if (interactionLoopId != null) 'interaction_loop_id': interactionLoopId,
    });
  }

  MomentsCompanion copyWith(
      {Value<int>? id,
      Value<int>? personaId,
      Value<String>? content,
      Value<int>? postedAt,
      Value<bool>? likedByUser,
      Value<String?>? userComment,
      Value<int?>? interactionLoopId}) {
    return MomentsCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      content: content ?? this.content,
      postedAt: postedAt ?? this.postedAt,
      likedByUser: likedByUser ?? this.likedByUser,
      userComment: userComment ?? this.userComment,
      interactionLoopId: interactionLoopId ?? this.interactionLoopId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (postedAt.present) {
      map['posted_at'] = Variable<int>(postedAt.value);
    }
    if (likedByUser.present) {
      map['liked_by_user'] = Variable<bool>(likedByUser.value);
    }
    if (userComment.present) {
      map['user_comment'] = Variable<String>(userComment.value);
    }
    if (interactionLoopId.present) {
      map['interaction_loop_id'] = Variable<int>(interactionLoopId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MomentsCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('postedAt: $postedAt, ')
          ..write('likedByUser: $likedByUser, ')
          ..write('userComment: $userComment, ')
          ..write('interactionLoopId: $interactionLoopId')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUrlMeta =
      const VerificationMeta('baseUrl');
  @override
  late final GeneratedColumn<String> baseUrl = GeneratedColumn<String>(
      'base_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeHoursMeta =
      const VerificationMeta('activeHours');
  @override
  late final GeneratedColumn<String> activeHours = GeneratedColumn<String>(
      'active_hours', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _dailyProactiveQuotaMeta =
      const VerificationMeta('dailyProactiveQuota');
  @override
  late final GeneratedColumn<int> dailyProactiveQuota = GeneratedColumn<int>(
      'daily_proactive_quota', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _tokenBudgetMeta =
      const VerificationMeta('tokenBudget');
  @override
  late final GeneratedColumn<int> tokenBudget = GeneratedColumn<int>(
      'token_budget', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4000));
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('我'));
  static const VerificationMeta _userAvatarPathMeta =
      const VerificationMeta('userAvatarPath');
  @override
  late final GeneratedColumn<String> userAvatarPath = GeneratedColumn<String>(
      'user_avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _momentFrequencyMeta =
      const VerificationMeta('momentFrequency');
  @override
  late final GeneratedColumn<int> momentFrequency = GeneratedColumn<int>(
      'moment_frequency', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(30));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        provider,
        baseUrl,
        model,
        activeHours,
        dailyProactiveQuota,
        tokenBudget,
        userName,
        userAvatarPath,
        momentFrequency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('base_url')) {
      context.handle(_baseUrlMeta,
          baseUrl.isAcceptableOrUnknown(data['base_url']!, _baseUrlMeta));
    } else if (isInserting) {
      context.missing(_baseUrlMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('active_hours')) {
      context.handle(
          _activeHoursMeta,
          activeHours.isAcceptableOrUnknown(
              data['active_hours']!, _activeHoursMeta));
    }
    if (data.containsKey('daily_proactive_quota')) {
      context.handle(
          _dailyProactiveQuotaMeta,
          dailyProactiveQuota.isAcceptableOrUnknown(
              data['daily_proactive_quota']!, _dailyProactiveQuotaMeta));
    }
    if (data.containsKey('token_budget')) {
      context.handle(
          _tokenBudgetMeta,
          tokenBudget.isAcceptableOrUnknown(
              data['token_budget']!, _tokenBudgetMeta));
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    }
    if (data.containsKey('user_avatar_path')) {
      context.handle(
          _userAvatarPathMeta,
          userAvatarPath.isAcceptableOrUnknown(
              data['user_avatar_path']!, _userAvatarPathMeta));
    }
    if (data.containsKey('moment_frequency')) {
      context.handle(
          _momentFrequencyMeta,
          momentFrequency.isAcceptableOrUnknown(
              data['moment_frequency']!, _momentFrequencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
      baseUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_url'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      activeHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}active_hours'])!,
      dailyProactiveQuota: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}daily_proactive_quota'])!,
      tokenBudget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}token_budget'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name'])!,
      userAvatarPath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}user_avatar_path']),
      momentFrequency: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}moment_frequency'])!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final int id;
  final String provider;
  final String baseUrl;
  final String model;
  final String activeHours;
  final int dailyProactiveQuota;
  final int tokenBudget;

  /// 全局“我”——用户昵称与头像（所有数字人共用一个用户身份）。
  final String userName;
  final String? userAvatarPath;

  /// 朋友圈自发活跃度 0–100（0=从不自发，越高越常发）。
  final int momentFrequency;
  const SettingsTableData(
      {required this.id,
      required this.provider,
      required this.baseUrl,
      required this.model,
      required this.activeHours,
      required this.dailyProactiveQuota,
      required this.tokenBudget,
      required this.userName,
      this.userAvatarPath,
      required this.momentFrequency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['provider'] = Variable<String>(provider);
    map['base_url'] = Variable<String>(baseUrl);
    map['model'] = Variable<String>(model);
    map['active_hours'] = Variable<String>(activeHours);
    map['daily_proactive_quota'] = Variable<int>(dailyProactiveQuota);
    map['token_budget'] = Variable<int>(tokenBudget);
    map['user_name'] = Variable<String>(userName);
    if (!nullToAbsent || userAvatarPath != null) {
      map['user_avatar_path'] = Variable<String>(userAvatarPath);
    }
    map['moment_frequency'] = Variable<int>(momentFrequency);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      provider: Value(provider),
      baseUrl: Value(baseUrl),
      model: Value(model),
      activeHours: Value(activeHours),
      dailyProactiveQuota: Value(dailyProactiveQuota),
      tokenBudget: Value(tokenBudget),
      userName: Value(userName),
      userAvatarPath: userAvatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(userAvatarPath),
      momentFrequency: Value(momentFrequency),
    );
  }

  factory SettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      provider: serializer.fromJson<String>(json['provider']),
      baseUrl: serializer.fromJson<String>(json['baseUrl']),
      model: serializer.fromJson<String>(json['model']),
      activeHours: serializer.fromJson<String>(json['activeHours']),
      dailyProactiveQuota:
          serializer.fromJson<int>(json['dailyProactiveQuota']),
      tokenBudget: serializer.fromJson<int>(json['tokenBudget']),
      userName: serializer.fromJson<String>(json['userName']),
      userAvatarPath: serializer.fromJson<String?>(json['userAvatarPath']),
      momentFrequency: serializer.fromJson<int>(json['momentFrequency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'provider': serializer.toJson<String>(provider),
      'baseUrl': serializer.toJson<String>(baseUrl),
      'model': serializer.toJson<String>(model),
      'activeHours': serializer.toJson<String>(activeHours),
      'dailyProactiveQuota': serializer.toJson<int>(dailyProactiveQuota),
      'tokenBudget': serializer.toJson<int>(tokenBudget),
      'userName': serializer.toJson<String>(userName),
      'userAvatarPath': serializer.toJson<String?>(userAvatarPath),
      'momentFrequency': serializer.toJson<int>(momentFrequency),
    };
  }

  SettingsTableData copyWith(
          {int? id,
          String? provider,
          String? baseUrl,
          String? model,
          String? activeHours,
          int? dailyProactiveQuota,
          int? tokenBudget,
          String? userName,
          Value<String?> userAvatarPath = const Value.absent(),
          int? momentFrequency}) =>
      SettingsTableData(
        id: id ?? this.id,
        provider: provider ?? this.provider,
        baseUrl: baseUrl ?? this.baseUrl,
        model: model ?? this.model,
        activeHours: activeHours ?? this.activeHours,
        dailyProactiveQuota: dailyProactiveQuota ?? this.dailyProactiveQuota,
        tokenBudget: tokenBudget ?? this.tokenBudget,
        userName: userName ?? this.userName,
        userAvatarPath:
            userAvatarPath.present ? userAvatarPath.value : this.userAvatarPath,
        momentFrequency: momentFrequency ?? this.momentFrequency,
      );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      baseUrl: data.baseUrl.present ? data.baseUrl.value : this.baseUrl,
      model: data.model.present ? data.model.value : this.model,
      activeHours:
          data.activeHours.present ? data.activeHours.value : this.activeHours,
      dailyProactiveQuota: data.dailyProactiveQuota.present
          ? data.dailyProactiveQuota.value
          : this.dailyProactiveQuota,
      tokenBudget:
          data.tokenBudget.present ? data.tokenBudget.value : this.tokenBudget,
      userName: data.userName.present ? data.userName.value : this.userName,
      userAvatarPath: data.userAvatarPath.present
          ? data.userAvatarPath.value
          : this.userAvatarPath,
      momentFrequency: data.momentFrequency.present
          ? data.momentFrequency.value
          : this.momentFrequency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('model: $model, ')
          ..write('activeHours: $activeHours, ')
          ..write('dailyProactiveQuota: $dailyProactiveQuota, ')
          ..write('tokenBudget: $tokenBudget, ')
          ..write('userName: $userName, ')
          ..write('userAvatarPath: $userAvatarPath, ')
          ..write('momentFrequency: $momentFrequency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      provider,
      baseUrl,
      model,
      activeHours,
      dailyProactiveQuota,
      tokenBudget,
      userName,
      userAvatarPath,
      momentFrequency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.baseUrl == this.baseUrl &&
          other.model == this.model &&
          other.activeHours == this.activeHours &&
          other.dailyProactiveQuota == this.dailyProactiveQuota &&
          other.tokenBudget == this.tokenBudget &&
          other.userName == this.userName &&
          other.userAvatarPath == this.userAvatarPath &&
          other.momentFrequency == this.momentFrequency);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<int> id;
  final Value<String> provider;
  final Value<String> baseUrl;
  final Value<String> model;
  final Value<String> activeHours;
  final Value<int> dailyProactiveQuota;
  final Value<int> tokenBudget;
  final Value<String> userName;
  final Value<String?> userAvatarPath;
  final Value<int> momentFrequency;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.baseUrl = const Value.absent(),
    this.model = const Value.absent(),
    this.activeHours = const Value.absent(),
    this.dailyProactiveQuota = const Value.absent(),
    this.tokenBudget = const Value.absent(),
    this.userName = const Value.absent(),
    this.userAvatarPath = const Value.absent(),
    this.momentFrequency = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String provider,
    required String baseUrl,
    required String model,
    this.activeHours = const Value.absent(),
    this.dailyProactiveQuota = const Value.absent(),
    this.tokenBudget = const Value.absent(),
    this.userName = const Value.absent(),
    this.userAvatarPath = const Value.absent(),
    this.momentFrequency = const Value.absent(),
  })  : provider = Value(provider),
        baseUrl = Value(baseUrl),
        model = Value(model);
  static Insertable<SettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? provider,
    Expression<String>? baseUrl,
    Expression<String>? model,
    Expression<String>? activeHours,
    Expression<int>? dailyProactiveQuota,
    Expression<int>? tokenBudget,
    Expression<String>? userName,
    Expression<String>? userAvatarPath,
    Expression<int>? momentFrequency,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (baseUrl != null) 'base_url': baseUrl,
      if (model != null) 'model': model,
      if (activeHours != null) 'active_hours': activeHours,
      if (dailyProactiveQuota != null)
        'daily_proactive_quota': dailyProactiveQuota,
      if (tokenBudget != null) 'token_budget': tokenBudget,
      if (userName != null) 'user_name': userName,
      if (userAvatarPath != null) 'user_avatar_path': userAvatarPath,
      if (momentFrequency != null) 'moment_frequency': momentFrequency,
    });
  }

  SettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? provider,
      Value<String>? baseUrl,
      Value<String>? model,
      Value<String>? activeHours,
      Value<int>? dailyProactiveQuota,
      Value<int>? tokenBudget,
      Value<String>? userName,
      Value<String?>? userAvatarPath,
      Value<int>? momentFrequency}) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      baseUrl: baseUrl ?? this.baseUrl,
      model: model ?? this.model,
      activeHours: activeHours ?? this.activeHours,
      dailyProactiveQuota: dailyProactiveQuota ?? this.dailyProactiveQuota,
      tokenBudget: tokenBudget ?? this.tokenBudget,
      userName: userName ?? this.userName,
      userAvatarPath: userAvatarPath ?? this.userAvatarPath,
      momentFrequency: momentFrequency ?? this.momentFrequency,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (baseUrl.present) {
      map['base_url'] = Variable<String>(baseUrl.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (activeHours.present) {
      map['active_hours'] = Variable<String>(activeHours.value);
    }
    if (dailyProactiveQuota.present) {
      map['daily_proactive_quota'] = Variable<int>(dailyProactiveQuota.value);
    }
    if (tokenBudget.present) {
      map['token_budget'] = Variable<int>(tokenBudget.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (userAvatarPath.present) {
      map['user_avatar_path'] = Variable<String>(userAvatarPath.value);
    }
    if (momentFrequency.present) {
      map['moment_frequency'] = Variable<int>(momentFrequency.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('baseUrl: $baseUrl, ')
          ..write('model: $model, ')
          ..write('activeHours: $activeHours, ')
          ..write('dailyProactiveQuota: $dailyProactiveQuota, ')
          ..write('tokenBudget: $tokenBudget, ')
          ..write('userName: $userName, ')
          ..write('userAvatarPath: $userAvatarPath, ')
          ..write('momentFrequency: $momentFrequency')
          ..write(')'))
        .toString();
  }
}

class $ScheduledProactivesTable extends ScheduledProactives
    with TableInfo<$ScheduledProactivesTable, ScheduledProactive> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduledProactivesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _personaIdMeta =
      const VerificationMeta('personaId');
  @override
  late final GeneratedColumn<int> personaId = GeneratedColumn<int>(
      'persona_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES personas (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scheduledAtMeta =
      const VerificationMeta('scheduledAt');
  @override
  late final GeneratedColumn<int> scheduledAt = GeneratedColumn<int>(
      'scheduled_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notificationIdMeta =
      const VerificationMeta('notificationId');
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
      'notification_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, personaId, content, scheduledAt, notificationId, status, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scheduled_proactives';
  @override
  VerificationContext validateIntegrity(Insertable<ScheduledProactive> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('persona_id')) {
      context.handle(_personaIdMeta,
          personaId.isAcceptableOrUnknown(data['persona_id']!, _personaIdMeta));
    } else if (isInserting) {
      context.missing(_personaIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
          _scheduledAtMeta,
          scheduledAt.isAcceptableOrUnknown(
              data['scheduled_at']!, _scheduledAtMeta));
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('notification_id')) {
      context.handle(
          _notificationIdMeta,
          notificationId.isAcceptableOrUnknown(
              data['notification_id']!, _notificationIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduledProactive map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduledProactive(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      personaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}persona_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      scheduledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}scheduled_at'])!,
      notificationId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notification_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ScheduledProactivesTable createAlias(String alias) {
    return $ScheduledProactivesTable(attachedDatabase, alias);
  }
}

class ScheduledProactive extends DataClass
    implements Insertable<ScheduledProactive> {
  final int id;
  final int personaId;

  /// 预生成的主动消息正文（可能含 ‹SEP› 分条标记，投递时按聊天规则处理）。
  final String content;

  /// 计划触发时间戳（毫秒）。
  final int scheduledAt;

  /// 关联的本地通知 ID（便于取消）。
  final int? notificationId;

  /// scheduled / delivered / cancelled。
  final String status;
  final int createdAt;
  const ScheduledProactive(
      {required this.id,
      required this.personaId,
      required this.content,
      required this.scheduledAt,
      this.notificationId,
      required this.status,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['persona_id'] = Variable<int>(personaId);
    map['content'] = Variable<String>(content);
    map['scheduled_at'] = Variable<int>(scheduledAt);
    if (!nullToAbsent || notificationId != null) {
      map['notification_id'] = Variable<int>(notificationId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ScheduledProactivesCompanion toCompanion(bool nullToAbsent) {
    return ScheduledProactivesCompanion(
      id: Value(id),
      personaId: Value(personaId),
      content: Value(content),
      scheduledAt: Value(scheduledAt),
      notificationId: notificationId == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationId),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ScheduledProactive.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduledProactive(
      id: serializer.fromJson<int>(json['id']),
      personaId: serializer.fromJson<int>(json['personaId']),
      content: serializer.fromJson<String>(json['content']),
      scheduledAt: serializer.fromJson<int>(json['scheduledAt']),
      notificationId: serializer.fromJson<int?>(json['notificationId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personaId': serializer.toJson<int>(personaId),
      'content': serializer.toJson<String>(content),
      'scheduledAt': serializer.toJson<int>(scheduledAt),
      'notificationId': serializer.toJson<int?>(notificationId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  ScheduledProactive copyWith(
          {int? id,
          int? personaId,
          String? content,
          int? scheduledAt,
          Value<int?> notificationId = const Value.absent(),
          String? status,
          int? createdAt}) =>
      ScheduledProactive(
        id: id ?? this.id,
        personaId: personaId ?? this.personaId,
        content: content ?? this.content,
        scheduledAt: scheduledAt ?? this.scheduledAt,
        notificationId:
            notificationId.present ? notificationId.value : this.notificationId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );
  ScheduledProactive copyWithCompanion(ScheduledProactivesCompanion data) {
    return ScheduledProactive(
      id: data.id.present ? data.id.value : this.id,
      personaId: data.personaId.present ? data.personaId.value : this.personaId,
      content: data.content.present ? data.content.value : this.content,
      scheduledAt:
          data.scheduledAt.present ? data.scheduledAt.value : this.scheduledAt,
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledProactive(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('notificationId: $notificationId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, personaId, content, scheduledAt, notificationId, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduledProactive &&
          other.id == this.id &&
          other.personaId == this.personaId &&
          other.content == this.content &&
          other.scheduledAt == this.scheduledAt &&
          other.notificationId == this.notificationId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ScheduledProactivesCompanion extends UpdateCompanion<ScheduledProactive> {
  final Value<int> id;
  final Value<int> personaId;
  final Value<String> content;
  final Value<int> scheduledAt;
  final Value<int?> notificationId;
  final Value<String> status;
  final Value<int> createdAt;
  const ScheduledProactivesCompanion({
    this.id = const Value.absent(),
    this.personaId = const Value.absent(),
    this.content = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.notificationId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ScheduledProactivesCompanion.insert({
    this.id = const Value.absent(),
    required int personaId,
    required String content,
    required int scheduledAt,
    this.notificationId = const Value.absent(),
    this.status = const Value.absent(),
    required int createdAt,
  })  : personaId = Value(personaId),
        content = Value(content),
        scheduledAt = Value(scheduledAt),
        createdAt = Value(createdAt);
  static Insertable<ScheduledProactive> custom({
    Expression<int>? id,
    Expression<int>? personaId,
    Expression<String>? content,
    Expression<int>? scheduledAt,
    Expression<int>? notificationId,
    Expression<String>? status,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personaId != null) 'persona_id': personaId,
      if (content != null) 'content': content,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (notificationId != null) 'notification_id': notificationId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ScheduledProactivesCompanion copyWith(
      {Value<int>? id,
      Value<int>? personaId,
      Value<String>? content,
      Value<int>? scheduledAt,
      Value<int?>? notificationId,
      Value<String>? status,
      Value<int>? createdAt}) {
    return ScheduledProactivesCompanion(
      id: id ?? this.id,
      personaId: personaId ?? this.personaId,
      content: content ?? this.content,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      notificationId: notificationId ?? this.notificationId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personaId.present) {
      map['persona_id'] = Variable<int>(personaId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<int>(scheduledAt.value);
    }
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduledProactivesCompanion(')
          ..write('id: $id, ')
          ..write('personaId: $personaId, ')
          ..write('content: $content, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('notificationId: $notificationId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonasTable personas = $PersonasTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SessionSummariesTable sessionSummaries =
      $SessionSummariesTable(this);
  late final $FactsTable facts = $FactsTable(this);
  late final $RelationshipStatesTable relationshipStates =
      $RelationshipStatesTable(this);
  late final $OpenLoopsTable openLoops = $OpenLoopsTable(this);
  late final $StickersTable stickers = $StickersTable(this);
  late final $MomentsTable moments = $MomentsTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  late final $ScheduledProactivesTable scheduledProactives =
      $ScheduledProactivesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        personas,
        messages,
        sessionSummaries,
        facts,
        relationshipStates,
        openLoops,
        stickers,
        moments,
        settingsTable,
        scheduledProactives
      ];
}

typedef $$PersonasTableCreateCompanionBuilder = PersonasCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> avatarPath,
  required String personaJson,
  required String personaJsonInitial,
  Value<String?> outwardPersonaJson,
  Value<String?> userAlias,
  Value<String?> relationship,
  Value<int> proactiveTier,
  required int createdAt,
  required int updatedAt,
});
typedef $$PersonasTableUpdateCompanionBuilder = PersonasCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> avatarPath,
  Value<String> personaJson,
  Value<String> personaJsonInitial,
  Value<String?> outwardPersonaJson,
  Value<String?> userAlias,
  Value<String?> relationship,
  Value<int> proactiveTier,
  Value<int> createdAt,
  Value<int> updatedAt,
});

final class $$PersonasTableReferences
    extends BaseReferences<_$AppDatabase, $PersonasTable, Persona> {
  $$PersonasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MessagesTable, List<Message>> _messagesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.messages,
          aliasName:
              $_aliasNameGenerator(db.personas.id, db.messages.personaId));

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager($_db, $_db.messages)
        .filter((f) => f.personaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SessionSummariesTable, List<SessionSummary>>
      _sessionSummariesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.sessionSummaries,
              aliasName: $_aliasNameGenerator(
                  db.personas.id, db.sessionSummaries.personaId));

  $$SessionSummariesTableProcessedTableManager get sessionSummariesRefs {
    final manager =
        $$SessionSummariesTableTableManager($_db, $_db.sessionSummaries)
            .filter((f) => f.personaId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_sessionSummariesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$FactsTable, List<Fact>> _factsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.facts,
          aliasName: $_aliasNameGenerator(db.personas.id, db.facts.personaId));

  $$FactsTableProcessedTableManager get factsRefs {
    final manager = $$FactsTableTableManager($_db, $_db.facts)
        .filter((f) => f.personaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_factsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RelationshipStatesTable, List<RelationshipState>>
      _relationshipStatesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationshipStates,
              aliasName: $_aliasNameGenerator(
                  db.personas.id, db.relationshipStates.personaId));

  $$RelationshipStatesTableProcessedTableManager get relationshipStatesRefs {
    final manager =
        $$RelationshipStatesTableTableManager($_db, $_db.relationshipStates)
            .filter((f) => f.personaId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_relationshipStatesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OpenLoopsTable, List<OpenLoop>>
      _openLoopsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.openLoops,
              aliasName:
                  $_aliasNameGenerator(db.personas.id, db.openLoops.personaId));

  $$OpenLoopsTableProcessedTableManager get openLoopsRefs {
    final manager = $$OpenLoopsTableTableManager($_db, $_db.openLoops)
        .filter((f) => f.personaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_openLoopsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StickersTable, List<Sticker>> _stickersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.stickers,
          aliasName:
              $_aliasNameGenerator(db.personas.id, db.stickers.personaId));

  $$StickersTableProcessedTableManager get stickersRefs {
    final manager = $$StickersTableTableManager($_db, $_db.stickers)
        .filter((f) => f.personaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_stickersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MomentsTable, List<Moment>> _momentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.moments,
          aliasName:
              $_aliasNameGenerator(db.personas.id, db.moments.personaId));

  $$MomentsTableProcessedTableManager get momentsRefs {
    final manager = $$MomentsTableTableManager($_db, $_db.moments)
        .filter((f) => f.personaId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_momentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ScheduledProactivesTable,
      List<ScheduledProactive>> _scheduledProactivesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.scheduledProactives,
          aliasName: $_aliasNameGenerator(
              db.personas.id, db.scheduledProactives.personaId));

  $$ScheduledProactivesTableProcessedTableManager get scheduledProactivesRefs {
    final manager =
        $$ScheduledProactivesTableTableManager($_db, $_db.scheduledProactives)
            .filter((f) => f.personaId.id($_item.id));

    final cache =
        $_typedResult.readTableOrNull(_scheduledProactivesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PersonasTableFilterComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personaJson => $composableBuilder(
      column: $table.personaJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personaJsonInitial => $composableBuilder(
      column: $table.personaJsonInitial,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outwardPersonaJson => $composableBuilder(
      column: $table.outwardPersonaJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userAlias => $composableBuilder(
      column: $table.userAlias, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get proactiveTier => $composableBuilder(
      column: $table.proactiveTier, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> messagesRefs(
      Expression<bool> Function($$MessagesTableFilterComposer f) f) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableFilterComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> sessionSummariesRefs(
      Expression<bool> Function($$SessionSummariesTableFilterComposer f) f) {
    final $$SessionSummariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionSummaries,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionSummariesTableFilterComposer(
              $db: $db,
              $table: $db.sessionSummaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> factsRefs(
      Expression<bool> Function($$FactsTableFilterComposer f) f) {
    final $$FactsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.facts,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FactsTableFilterComposer(
              $db: $db,
              $table: $db.facts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> relationshipStatesRefs(
      Expression<bool> Function($$RelationshipStatesTableFilterComposer f) f) {
    final $$RelationshipStatesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationshipStates,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipStatesTableFilterComposer(
              $db: $db,
              $table: $db.relationshipStates,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> openLoopsRefs(
      Expression<bool> Function($$OpenLoopsTableFilterComposer f) f) {
    final $$OpenLoopsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.openLoops,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OpenLoopsTableFilterComposer(
              $db: $db,
              $table: $db.openLoops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stickersRefs(
      Expression<bool> Function($$StickersTableFilterComposer f) f) {
    final $$StickersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stickers,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StickersTableFilterComposer(
              $db: $db,
              $table: $db.stickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> momentsRefs(
      Expression<bool> Function($$MomentsTableFilterComposer f) f) {
    final $$MomentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.moments,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentsTableFilterComposer(
              $db: $db,
              $table: $db.moments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> scheduledProactivesRefs(
      Expression<bool> Function($$ScheduledProactivesTableFilterComposer f) f) {
    final $$ScheduledProactivesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.scheduledProactives,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ScheduledProactivesTableFilterComposer(
              $db: $db,
              $table: $db.scheduledProactives,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonasTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personaJson => $composableBuilder(
      column: $table.personaJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personaJsonInitial => $composableBuilder(
      column: $table.personaJsonInitial,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outwardPersonaJson => $composableBuilder(
      column: $table.outwardPersonaJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userAlias => $composableBuilder(
      column: $table.userAlias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relationship => $composableBuilder(
      column: $table.relationship,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get proactiveTier => $composableBuilder(
      column: $table.proactiveTier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PersonasTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonasTable> {
  $$PersonasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<String> get personaJson => $composableBuilder(
      column: $table.personaJson, builder: (column) => column);

  GeneratedColumn<String> get personaJsonInitial => $composableBuilder(
      column: $table.personaJsonInitial, builder: (column) => column);

  GeneratedColumn<String> get outwardPersonaJson => $composableBuilder(
      column: $table.outwardPersonaJson, builder: (column) => column);

  GeneratedColumn<String> get userAlias =>
      $composableBuilder(column: $table.userAlias, builder: (column) => column);

  GeneratedColumn<String> get relationship => $composableBuilder(
      column: $table.relationship, builder: (column) => column);

  GeneratedColumn<int> get proactiveTier => $composableBuilder(
      column: $table.proactiveTier, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> messagesRefs<T extends Object>(
      Expression<T> Function($$MessagesTableAnnotationComposer a) f) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.messages,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MessagesTableAnnotationComposer(
              $db: $db,
              $table: $db.messages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> sessionSummariesRefs<T extends Object>(
      Expression<T> Function($$SessionSummariesTableAnnotationComposer a) f) {
    final $$SessionSummariesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sessionSummaries,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionSummariesTableAnnotationComposer(
              $db: $db,
              $table: $db.sessionSummaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> factsRefs<T extends Object>(
      Expression<T> Function($$FactsTableAnnotationComposer a) f) {
    final $$FactsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.facts,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FactsTableAnnotationComposer(
              $db: $db,
              $table: $db.facts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> relationshipStatesRefs<T extends Object>(
      Expression<T> Function($$RelationshipStatesTableAnnotationComposer a) f) {
    final $$RelationshipStatesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.relationshipStates,
            getReferencedColumn: (t) => t.personaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$RelationshipStatesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.relationshipStates,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> openLoopsRefs<T extends Object>(
      Expression<T> Function($$OpenLoopsTableAnnotationComposer a) f) {
    final $$OpenLoopsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.openLoops,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OpenLoopsTableAnnotationComposer(
              $db: $db,
              $table: $db.openLoops,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stickersRefs<T extends Object>(
      Expression<T> Function($$StickersTableAnnotationComposer a) f) {
    final $$StickersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stickers,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StickersTableAnnotationComposer(
              $db: $db,
              $table: $db.stickers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> momentsRefs<T extends Object>(
      Expression<T> Function($$MomentsTableAnnotationComposer a) f) {
    final $$MomentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.moments,
        getReferencedColumn: (t) => t.personaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MomentsTableAnnotationComposer(
              $db: $db,
              $table: $db.moments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> scheduledProactivesRefs<T extends Object>(
      Expression<T> Function($$ScheduledProactivesTableAnnotationComposer a)
          f) {
    final $$ScheduledProactivesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.scheduledProactives,
            getReferencedColumn: (t) => t.personaId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ScheduledProactivesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.scheduledProactives,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PersonasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonasTable,
    Persona,
    $$PersonasTableFilterComposer,
    $$PersonasTableOrderingComposer,
    $$PersonasTableAnnotationComposer,
    $$PersonasTableCreateCompanionBuilder,
    $$PersonasTableUpdateCompanionBuilder,
    (Persona, $$PersonasTableReferences),
    Persona,
    PrefetchHooks Function(
        {bool messagesRefs,
        bool sessionSummariesRefs,
        bool factsRefs,
        bool relationshipStatesRefs,
        bool openLoopsRefs,
        bool stickersRefs,
        bool momentsRefs,
        bool scheduledProactivesRefs})> {
  $$PersonasTableTableManager(_$AppDatabase db, $PersonasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<String> personaJson = const Value.absent(),
            Value<String> personaJsonInitial = const Value.absent(),
            Value<String?> outwardPersonaJson = const Value.absent(),
            Value<String?> userAlias = const Value.absent(),
            Value<String?> relationship = const Value.absent(),
            Value<int> proactiveTier = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
          }) =>
              PersonasCompanion(
            id: id,
            name: name,
            avatarPath: avatarPath,
            personaJson: personaJson,
            personaJsonInitial: personaJsonInitial,
            outwardPersonaJson: outwardPersonaJson,
            userAlias: userAlias,
            relationship: relationship,
            proactiveTier: proactiveTier,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> avatarPath = const Value.absent(),
            required String personaJson,
            required String personaJsonInitial,
            Value<String?> outwardPersonaJson = const Value.absent(),
            Value<String?> userAlias = const Value.absent(),
            Value<String?> relationship = const Value.absent(),
            Value<int> proactiveTier = const Value.absent(),
            required int createdAt,
            required int updatedAt,
          }) =>
              PersonasCompanion.insert(
            id: id,
            name: name,
            avatarPath: avatarPath,
            personaJson: personaJson,
            personaJsonInitial: personaJsonInitial,
            outwardPersonaJson: outwardPersonaJson,
            userAlias: userAlias,
            relationship: relationship,
            proactiveTier: proactiveTier,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PersonasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {messagesRefs = false,
              sessionSummariesRefs = false,
              factsRefs = false,
              relationshipStatesRefs = false,
              openLoopsRefs = false,
              stickersRefs = false,
              momentsRefs = false,
              scheduledProactivesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (messagesRefs) db.messages,
                if (sessionSummariesRefs) db.sessionSummaries,
                if (factsRefs) db.facts,
                if (relationshipStatesRefs) db.relationshipStates,
                if (openLoopsRefs) db.openLoops,
                if (stickersRefs) db.stickers,
                if (momentsRefs) db.moments,
                if (scheduledProactivesRefs) db.scheduledProactives
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (messagesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PersonasTableReferences._messagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .messagesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (sessionSummariesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PersonasTableReferences
                            ._sessionSummariesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .sessionSummariesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (factsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PersonasTableReferences._factsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0).factsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (relationshipStatesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PersonasTableReferences
                            ._relationshipStatesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .relationshipStatesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (openLoopsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PersonasTableReferences._openLoopsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .openLoopsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (stickersRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PersonasTableReferences._stickersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .stickersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (momentsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$PersonasTableReferences._momentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .momentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items),
                  if (scheduledProactivesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable: $$PersonasTableReferences
                            ._scheduledProactivesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonasTableReferences(db, table, p0)
                                .scheduledProactivesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.personaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PersonasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonasTable,
    Persona,
    $$PersonasTableFilterComposer,
    $$PersonasTableOrderingComposer,
    $$PersonasTableAnnotationComposer,
    $$PersonasTableCreateCompanionBuilder,
    $$PersonasTableUpdateCompanionBuilder,
    (Persona, $$PersonasTableReferences),
    Persona,
    PrefetchHooks Function(
        {bool messagesRefs,
        bool sessionSummariesRefs,
        bool factsRefs,
        bool relationshipStatesRefs,
        bool openLoopsRefs,
        bool stickersRefs,
        bool momentsRefs,
        bool scheduledProactivesRefs})>;
typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  required int personaId,
  required String sender,
  required String content,
  Value<String> type,
  required int createdAt,
  Value<bool> isProactive,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<int> id,
  Value<int> personaId,
  Value<String> sender,
  Value<String> content,
  Value<String> type,
  Value<int> createdAt,
  Value<bool> isProactive,
});

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, Message> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) => db.personas
      .createAlias($_aliasNameGenerator(db.messages.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isProactive => $composableBuilder(
      column: $table.isProactive, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sender => $composableBuilder(
      column: $table.sender, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isProactive => $composableBuilder(
      column: $table.isProactive, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sender =>
      $composableBuilder(column: $table.sender, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isProactive => $composableBuilder(
      column: $table.isProactive, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MessagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool personaId})> {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personaId = const Value.absent(),
            Value<String> sender = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<bool> isProactive = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            personaId: personaId,
            sender: sender,
            content: content,
            type: type,
            createdAt: createdAt,
            isProactive: isProactive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personaId,
            required String sender,
            required String content,
            Value<String> type = const Value.absent(),
            required int createdAt,
            Value<bool> isProactive = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            personaId: personaId,
            sender: sender,
            content: content,
            type: type,
            createdAt: createdAt,
            isProactive: isProactive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MessagesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$MessagesTableReferences._personaIdTable(db),
                    referencedColumn:
                        $$MessagesTableReferences._personaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MessagesTable,
    Message,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (Message, $$MessagesTableReferences),
    Message,
    PrefetchHooks Function({bool personaId})>;
typedef $$SessionSummariesTableCreateCompanionBuilder
    = SessionSummariesCompanion Function({
  Value<int> personaId,
  Value<String> summary,
  Value<int?> coveredUntilMsgId,
  required int updatedAt,
});
typedef $$SessionSummariesTableUpdateCompanionBuilder
    = SessionSummariesCompanion Function({
  Value<int> personaId,
  Value<String> summary,
  Value<int?> coveredUntilMsgId,
  Value<int> updatedAt,
});

final class $$SessionSummariesTableReferences extends BaseReferences<
    _$AppDatabase, $SessionSummariesTable, SessionSummary> {
  $$SessionSummariesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) =>
      db.personas.createAlias(
          $_aliasNameGenerator(db.sessionSummaries.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SessionSummariesTableFilterComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get coveredUntilMsgId => $composableBuilder(
      column: $table.coveredUntilMsgId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionSummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get coveredUntilMsgId => $composableBuilder(
      column: $table.coveredUntilMsgId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionSummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionSummariesTable> {
  $$SessionSummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<int> get coveredUntilMsgId => $composableBuilder(
      column: $table.coveredUntilMsgId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SessionSummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionSummariesTable,
    SessionSummary,
    $$SessionSummariesTableFilterComposer,
    $$SessionSummariesTableOrderingComposer,
    $$SessionSummariesTableAnnotationComposer,
    $$SessionSummariesTableCreateCompanionBuilder,
    $$SessionSummariesTableUpdateCompanionBuilder,
    (SessionSummary, $$SessionSummariesTableReferences),
    SessionSummary,
    PrefetchHooks Function({bool personaId})> {
  $$SessionSummariesTableTableManager(
      _$AppDatabase db, $SessionSummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionSummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionSummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionSummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> personaId = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<int?> coveredUntilMsgId = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
          }) =>
              SessionSummariesCompanion(
            personaId: personaId,
            summary: summary,
            coveredUntilMsgId: coveredUntilMsgId,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> personaId = const Value.absent(),
            Value<String> summary = const Value.absent(),
            Value<int?> coveredUntilMsgId = const Value.absent(),
            required int updatedAt,
          }) =>
              SessionSummariesCompanion.insert(
            personaId: personaId,
            summary: summary,
            coveredUntilMsgId: coveredUntilMsgId,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessionSummariesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$SessionSummariesTableReferences._personaIdTable(db),
                    referencedColumn: $$SessionSummariesTableReferences
                        ._personaIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SessionSummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionSummariesTable,
    SessionSummary,
    $$SessionSummariesTableFilterComposer,
    $$SessionSummariesTableOrderingComposer,
    $$SessionSummariesTableAnnotationComposer,
    $$SessionSummariesTableCreateCompanionBuilder,
    $$SessionSummariesTableUpdateCompanionBuilder,
    (SessionSummary, $$SessionSummariesTableReferences),
    SessionSummary,
    PrefetchHooks Function({bool personaId})>;
typedef $$FactsTableCreateCompanionBuilder = FactsCompanion Function({
  Value<int> id,
  required int personaId,
  required String content,
  Value<double> importance,
  required int lastReferencedAt,
  Value<bool> pinned,
  Value<int?> supersededBy,
  Value<bool> valid,
  required int createdAt,
});
typedef $$FactsTableUpdateCompanionBuilder = FactsCompanion Function({
  Value<int> id,
  Value<int> personaId,
  Value<String> content,
  Value<double> importance,
  Value<int> lastReferencedAt,
  Value<bool> pinned,
  Value<int?> supersededBy,
  Value<bool> valid,
  Value<int> createdAt,
});

final class $$FactsTableReferences
    extends BaseReferences<_$AppDatabase, $FactsTable, Fact> {
  $$FactsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) => db.personas
      .createAlias($_aliasNameGenerator(db.facts.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$FactsTableFilterComposer extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastReferencedAt => $composableBuilder(
      column: $table.lastReferencedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get supersededBy => $composableBuilder(
      column: $table.supersededBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get valid => $composableBuilder(
      column: $table.valid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactsTableOrderingComposer
    extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastReferencedAt => $composableBuilder(
      column: $table.lastReferencedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get pinned => $composableBuilder(
      column: $table.pinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get supersededBy => $composableBuilder(
      column: $table.supersededBy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get valid => $composableBuilder(
      column: $table.valid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FactsTable> {
  $$FactsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => column);

  GeneratedColumn<int> get lastReferencedAt => $composableBuilder(
      column: $table.lastReferencedAt, builder: (column) => column);

  GeneratedColumn<bool> get pinned =>
      $composableBuilder(column: $table.pinned, builder: (column) => column);

  GeneratedColumn<int> get supersededBy => $composableBuilder(
      column: $table.supersededBy, builder: (column) => column);

  GeneratedColumn<bool> get valid =>
      $composableBuilder(column: $table.valid, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FactsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FactsTable,
    Fact,
    $$FactsTableFilterComposer,
    $$FactsTableOrderingComposer,
    $$FactsTableAnnotationComposer,
    $$FactsTableCreateCompanionBuilder,
    $$FactsTableUpdateCompanionBuilder,
    (Fact, $$FactsTableReferences),
    Fact,
    PrefetchHooks Function({bool personaId})> {
  $$FactsTableTableManager(_$AppDatabase db, $FactsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FactsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FactsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FactsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personaId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<double> importance = const Value.absent(),
            Value<int> lastReferencedAt = const Value.absent(),
            Value<bool> pinned = const Value.absent(),
            Value<int?> supersededBy = const Value.absent(),
            Value<bool> valid = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              FactsCompanion(
            id: id,
            personaId: personaId,
            content: content,
            importance: importance,
            lastReferencedAt: lastReferencedAt,
            pinned: pinned,
            supersededBy: supersededBy,
            valid: valid,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personaId,
            required String content,
            Value<double> importance = const Value.absent(),
            required int lastReferencedAt,
            Value<bool> pinned = const Value.absent(),
            Value<int?> supersededBy = const Value.absent(),
            Value<bool> valid = const Value.absent(),
            required int createdAt,
          }) =>
              FactsCompanion.insert(
            id: id,
            personaId: personaId,
            content: content,
            importance: importance,
            lastReferencedAt: lastReferencedAt,
            pinned: pinned,
            supersededBy: supersededBy,
            valid: valid,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FactsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable: $$FactsTableReferences._personaIdTable(db),
                    referencedColumn:
                        $$FactsTableReferences._personaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$FactsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FactsTable,
    Fact,
    $$FactsTableFilterComposer,
    $$FactsTableOrderingComposer,
    $$FactsTableAnnotationComposer,
    $$FactsTableCreateCompanionBuilder,
    $$FactsTableUpdateCompanionBuilder,
    (Fact, $$FactsTableReferences),
    Fact,
    PrefetchHooks Function({bool personaId})>;
typedef $$RelationshipStatesTableCreateCompanionBuilder
    = RelationshipStatesCompanion Function({
  Value<int> personaId,
  Value<String> mood,
  Value<double> closeness,
  Value<String> unresolved,
  required int updatedAt,
});
typedef $$RelationshipStatesTableUpdateCompanionBuilder
    = RelationshipStatesCompanion Function({
  Value<int> personaId,
  Value<String> mood,
  Value<double> closeness,
  Value<String> unresolved,
  Value<int> updatedAt,
});

final class $$RelationshipStatesTableReferences extends BaseReferences<
    _$AppDatabase, $RelationshipStatesTable, RelationshipState> {
  $$RelationshipStatesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) =>
      db.personas.createAlias($_aliasNameGenerator(
          db.relationshipStates.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RelationshipStatesTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipStatesTable> {
  $$RelationshipStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get closeness => $composableBuilder(
      column: $table.closeness, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unresolved => $composableBuilder(
      column: $table.unresolved, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipStatesTable> {
  $$RelationshipStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mood => $composableBuilder(
      column: $table.mood, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get closeness => $composableBuilder(
      column: $table.closeness, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unresolved => $composableBuilder(
      column: $table.unresolved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipStatesTable> {
  $$RelationshipStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<double> get closeness =>
      $composableBuilder(column: $table.closeness, builder: (column) => column);

  GeneratedColumn<String> get unresolved => $composableBuilder(
      column: $table.unresolved, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipStatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationshipStatesTable,
    RelationshipState,
    $$RelationshipStatesTableFilterComposer,
    $$RelationshipStatesTableOrderingComposer,
    $$RelationshipStatesTableAnnotationComposer,
    $$RelationshipStatesTableCreateCompanionBuilder,
    $$RelationshipStatesTableUpdateCompanionBuilder,
    (RelationshipState, $$RelationshipStatesTableReferences),
    RelationshipState,
    PrefetchHooks Function({bool personaId})> {
  $$RelationshipStatesTableTableManager(
      _$AppDatabase db, $RelationshipStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationshipStatesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> personaId = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<double> closeness = const Value.absent(),
            Value<String> unresolved = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
          }) =>
              RelationshipStatesCompanion(
            personaId: personaId,
            mood: mood,
            closeness: closeness,
            unresolved: unresolved,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> personaId = const Value.absent(),
            Value<String> mood = const Value.absent(),
            Value<double> closeness = const Value.absent(),
            Value<String> unresolved = const Value.absent(),
            required int updatedAt,
          }) =>
              RelationshipStatesCompanion.insert(
            personaId: personaId,
            mood: mood,
            closeness: closeness,
            unresolved: unresolved,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RelationshipStatesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$RelationshipStatesTableReferences._personaIdTable(db),
                    referencedColumn: $$RelationshipStatesTableReferences
                        ._personaIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RelationshipStatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationshipStatesTable,
    RelationshipState,
    $$RelationshipStatesTableFilterComposer,
    $$RelationshipStatesTableOrderingComposer,
    $$RelationshipStatesTableAnnotationComposer,
    $$RelationshipStatesTableCreateCompanionBuilder,
    $$RelationshipStatesTableUpdateCompanionBuilder,
    (RelationshipState, $$RelationshipStatesTableReferences),
    RelationshipState,
    PrefetchHooks Function({bool personaId})>;
typedef $$OpenLoopsTableCreateCompanionBuilder = OpenLoopsCompanion Function({
  Value<int> id,
  required int personaId,
  required String event,
  required String plannedAction,
  required String triggerType,
  Value<int?> triggerAt,
  Value<double> importance,
  Value<String> status,
  Value<int?> notificationId,
  required int createdAt,
});
typedef $$OpenLoopsTableUpdateCompanionBuilder = OpenLoopsCompanion Function({
  Value<int> id,
  Value<int> personaId,
  Value<String> event,
  Value<String> plannedAction,
  Value<String> triggerType,
  Value<int?> triggerAt,
  Value<double> importance,
  Value<String> status,
  Value<int?> notificationId,
  Value<int> createdAt,
});

final class $$OpenLoopsTableReferences
    extends BaseReferences<_$AppDatabase, $OpenLoopsTable, OpenLoop> {
  $$OpenLoopsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) =>
      db.personas.createAlias(
          $_aliasNameGenerator(db.openLoops.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OpenLoopsTableFilterComposer
    extends Composer<_$AppDatabase, $OpenLoopsTable> {
  $$OpenLoopsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get event => $composableBuilder(
      column: $table.event, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get plannedAction => $composableBuilder(
      column: $table.plannedAction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get triggerAt => $composableBuilder(
      column: $table.triggerAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpenLoopsTableOrderingComposer
    extends Composer<_$AppDatabase, $OpenLoopsTable> {
  $$OpenLoopsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get event => $composableBuilder(
      column: $table.event, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get plannedAction => $composableBuilder(
      column: $table.plannedAction,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get triggerAt => $composableBuilder(
      column: $table.triggerAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpenLoopsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpenLoopsTable> {
  $$OpenLoopsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get event =>
      $composableBuilder(column: $table.event, builder: (column) => column);

  GeneratedColumn<String> get plannedAction => $composableBuilder(
      column: $table.plannedAction, builder: (column) => column);

  GeneratedColumn<String> get triggerType => $composableBuilder(
      column: $table.triggerType, builder: (column) => column);

  GeneratedColumn<int> get triggerAt =>
      $composableBuilder(column: $table.triggerAt, builder: (column) => column);

  GeneratedColumn<double> get importance => $composableBuilder(
      column: $table.importance, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OpenLoopsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OpenLoopsTable,
    OpenLoop,
    $$OpenLoopsTableFilterComposer,
    $$OpenLoopsTableOrderingComposer,
    $$OpenLoopsTableAnnotationComposer,
    $$OpenLoopsTableCreateCompanionBuilder,
    $$OpenLoopsTableUpdateCompanionBuilder,
    (OpenLoop, $$OpenLoopsTableReferences),
    OpenLoop,
    PrefetchHooks Function({bool personaId})> {
  $$OpenLoopsTableTableManager(_$AppDatabase db, $OpenLoopsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpenLoopsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OpenLoopsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpenLoopsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personaId = const Value.absent(),
            Value<String> event = const Value.absent(),
            Value<String> plannedAction = const Value.absent(),
            Value<String> triggerType = const Value.absent(),
            Value<int?> triggerAt = const Value.absent(),
            Value<double> importance = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> notificationId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              OpenLoopsCompanion(
            id: id,
            personaId: personaId,
            event: event,
            plannedAction: plannedAction,
            triggerType: triggerType,
            triggerAt: triggerAt,
            importance: importance,
            status: status,
            notificationId: notificationId,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personaId,
            required String event,
            required String plannedAction,
            required String triggerType,
            Value<int?> triggerAt = const Value.absent(),
            Value<double> importance = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int?> notificationId = const Value.absent(),
            required int createdAt,
          }) =>
              OpenLoopsCompanion.insert(
            id: id,
            personaId: personaId,
            event: event,
            plannedAction: plannedAction,
            triggerType: triggerType,
            triggerAt: triggerAt,
            importance: importance,
            status: status,
            notificationId: notificationId,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OpenLoopsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$OpenLoopsTableReferences._personaIdTable(db),
                    referencedColumn:
                        $$OpenLoopsTableReferences._personaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OpenLoopsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OpenLoopsTable,
    OpenLoop,
    $$OpenLoopsTableFilterComposer,
    $$OpenLoopsTableOrderingComposer,
    $$OpenLoopsTableAnnotationComposer,
    $$OpenLoopsTableCreateCompanionBuilder,
    $$OpenLoopsTableUpdateCompanionBuilder,
    (OpenLoop, $$OpenLoopsTableReferences),
    OpenLoop,
    PrefetchHooks Function({bool personaId})>;
typedef $$StickersTableCreateCompanionBuilder = StickersCompanion Function({
  Value<int> id,
  Value<int?> personaId,
  required String filePath,
  required String label,
  required int createdAt,
});
typedef $$StickersTableUpdateCompanionBuilder = StickersCompanion Function({
  Value<int> id,
  Value<int?> personaId,
  Value<String> filePath,
  Value<String> label,
  Value<int> createdAt,
});

final class $$StickersTableReferences
    extends BaseReferences<_$AppDatabase, $StickersTable, Sticker> {
  $$StickersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) => db.personas
      .createAlias($_aliasNameGenerator(db.stickers.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StickersTableFilterComposer
    extends Composer<_$AppDatabase, $StickersTable> {
  $$StickersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StickersTableOrderingComposer
    extends Composer<_$AppDatabase, $StickersTable> {
  $$StickersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get filePath => $composableBuilder(
      column: $table.filePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StickersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StickersTable> {
  $$StickersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StickersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StickersTable,
    Sticker,
    $$StickersTableFilterComposer,
    $$StickersTableOrderingComposer,
    $$StickersTableAnnotationComposer,
    $$StickersTableCreateCompanionBuilder,
    $$StickersTableUpdateCompanionBuilder,
    (Sticker, $$StickersTableReferences),
    Sticker,
    PrefetchHooks Function({bool personaId})> {
  $$StickersTableTableManager(_$AppDatabase db, $StickersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StickersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StickersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StickersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> personaId = const Value.absent(),
            Value<String> filePath = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              StickersCompanion(
            id: id,
            personaId: personaId,
            filePath: filePath,
            label: label,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> personaId = const Value.absent(),
            required String filePath,
            required String label,
            required int createdAt,
          }) =>
              StickersCompanion.insert(
            id: id,
            personaId: personaId,
            filePath: filePath,
            label: label,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$StickersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$StickersTableReferences._personaIdTable(db),
                    referencedColumn:
                        $$StickersTableReferences._personaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StickersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StickersTable,
    Sticker,
    $$StickersTableFilterComposer,
    $$StickersTableOrderingComposer,
    $$StickersTableAnnotationComposer,
    $$StickersTableCreateCompanionBuilder,
    $$StickersTableUpdateCompanionBuilder,
    (Sticker, $$StickersTableReferences),
    Sticker,
    PrefetchHooks Function({bool personaId})>;
typedef $$MomentsTableCreateCompanionBuilder = MomentsCompanion Function({
  Value<int> id,
  required int personaId,
  required String content,
  required int postedAt,
  Value<bool> likedByUser,
  Value<String?> userComment,
  Value<int?> interactionLoopId,
});
typedef $$MomentsTableUpdateCompanionBuilder = MomentsCompanion Function({
  Value<int> id,
  Value<int> personaId,
  Value<String> content,
  Value<int> postedAt,
  Value<bool> likedByUser,
  Value<String?> userComment,
  Value<int?> interactionLoopId,
});

final class $$MomentsTableReferences
    extends BaseReferences<_$AppDatabase, $MomentsTable, Moment> {
  $$MomentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) => db.personas
      .createAlias($_aliasNameGenerator(db.moments.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MomentsTableFilterComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get postedAt => $composableBuilder(
      column: $table.postedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get likedByUser => $composableBuilder(
      column: $table.likedByUser, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userComment => $composableBuilder(
      column: $table.userComment, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interactionLoopId => $composableBuilder(
      column: $table.interactionLoopId,
      builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MomentsTableOrderingComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postedAt => $composableBuilder(
      column: $table.postedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get likedByUser => $composableBuilder(
      column: $table.likedByUser, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userComment => $composableBuilder(
      column: $table.userComment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interactionLoopId => $composableBuilder(
      column: $table.interactionLoopId,
      builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MomentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MomentsTable> {
  $$MomentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get postedAt =>
      $composableBuilder(column: $table.postedAt, builder: (column) => column);

  GeneratedColumn<bool> get likedByUser => $composableBuilder(
      column: $table.likedByUser, builder: (column) => column);

  GeneratedColumn<String> get userComment => $composableBuilder(
      column: $table.userComment, builder: (column) => column);

  GeneratedColumn<int> get interactionLoopId => $composableBuilder(
      column: $table.interactionLoopId, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MomentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MomentsTable,
    Moment,
    $$MomentsTableFilterComposer,
    $$MomentsTableOrderingComposer,
    $$MomentsTableAnnotationComposer,
    $$MomentsTableCreateCompanionBuilder,
    $$MomentsTableUpdateCompanionBuilder,
    (Moment, $$MomentsTableReferences),
    Moment,
    PrefetchHooks Function({bool personaId})> {
  $$MomentsTableTableManager(_$AppDatabase db, $MomentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MomentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MomentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MomentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personaId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> postedAt = const Value.absent(),
            Value<bool> likedByUser = const Value.absent(),
            Value<String?> userComment = const Value.absent(),
            Value<int?> interactionLoopId = const Value.absent(),
          }) =>
              MomentsCompanion(
            id: id,
            personaId: personaId,
            content: content,
            postedAt: postedAt,
            likedByUser: likedByUser,
            userComment: userComment,
            interactionLoopId: interactionLoopId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personaId,
            required String content,
            required int postedAt,
            Value<bool> likedByUser = const Value.absent(),
            Value<String?> userComment = const Value.absent(),
            Value<int?> interactionLoopId = const Value.absent(),
          }) =>
              MomentsCompanion.insert(
            id: id,
            personaId: personaId,
            content: content,
            postedAt: postedAt,
            likedByUser: likedByUser,
            userComment: userComment,
            interactionLoopId: interactionLoopId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MomentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable:
                        $$MomentsTableReferences._personaIdTable(db),
                    referencedColumn:
                        $$MomentsTableReferences._personaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MomentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MomentsTable,
    Moment,
    $$MomentsTableFilterComposer,
    $$MomentsTableOrderingComposer,
    $$MomentsTableAnnotationComposer,
    $$MomentsTableCreateCompanionBuilder,
    $$MomentsTableUpdateCompanionBuilder,
    (Moment, $$MomentsTableReferences),
    Moment,
    PrefetchHooks Function({bool personaId})>;
typedef $$SettingsTableTableCreateCompanionBuilder = SettingsTableCompanion
    Function({
  Value<int> id,
  required String provider,
  required String baseUrl,
  required String model,
  Value<String> activeHours,
  Value<int> dailyProactiveQuota,
  Value<int> tokenBudget,
  Value<String> userName,
  Value<String?> userAvatarPath,
  Value<int> momentFrequency,
});
typedef $$SettingsTableTableUpdateCompanionBuilder = SettingsTableCompanion
    Function({
  Value<int> id,
  Value<String> provider,
  Value<String> baseUrl,
  Value<String> model,
  Value<String> activeHours,
  Value<int> dailyProactiveQuota,
  Value<int> tokenBudget,
  Value<String> userName,
  Value<String?> userAvatarPath,
  Value<int> momentFrequency,
});

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyProactiveQuota => $composableBuilder(
      column: $table.dailyProactiveQuota,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokenBudget => $composableBuilder(
      column: $table.tokenBudget, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userAvatarPath => $composableBuilder(
      column: $table.userAvatarPath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get momentFrequency => $composableBuilder(
      column: $table.momentFrequency,
      builder: (column) => ColumnFilters(column));
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get provider => $composableBuilder(
      column: $table.provider, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUrl => $composableBuilder(
      column: $table.baseUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyProactiveQuota => $composableBuilder(
      column: $table.dailyProactiveQuota,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokenBudget => $composableBuilder(
      column: $table.tokenBudget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userAvatarPath => $composableBuilder(
      column: $table.userAvatarPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get momentFrequency => $composableBuilder(
      column: $table.momentFrequency,
      builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get baseUrl =>
      $composableBuilder(column: $table.baseUrl, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get activeHours => $composableBuilder(
      column: $table.activeHours, builder: (column) => column);

  GeneratedColumn<int> get dailyProactiveQuota => $composableBuilder(
      column: $table.dailyProactiveQuota, builder: (column) => column);

  GeneratedColumn<int> get tokenBudget => $composableBuilder(
      column: $table.tokenBudget, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get userAvatarPath => $composableBuilder(
      column: $table.userAvatarPath, builder: (column) => column);

  GeneratedColumn<int> get momentFrequency => $composableBuilder(
      column: $table.momentFrequency, builder: (column) => column);
}

class $$SettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()> {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> provider = const Value.absent(),
            Value<String> baseUrl = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<String> activeHours = const Value.absent(),
            Value<int> dailyProactiveQuota = const Value.absent(),
            Value<int> tokenBudget = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<String?> userAvatarPath = const Value.absent(),
            Value<int> momentFrequency = const Value.absent(),
          }) =>
              SettingsTableCompanion(
            id: id,
            provider: provider,
            baseUrl: baseUrl,
            model: model,
            activeHours: activeHours,
            dailyProactiveQuota: dailyProactiveQuota,
            tokenBudget: tokenBudget,
            userName: userName,
            userAvatarPath: userAvatarPath,
            momentFrequency: momentFrequency,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String provider,
            required String baseUrl,
            required String model,
            Value<String> activeHours = const Value.absent(),
            Value<int> dailyProactiveQuota = const Value.absent(),
            Value<int> tokenBudget = const Value.absent(),
            Value<String> userName = const Value.absent(),
            Value<String?> userAvatarPath = const Value.absent(),
            Value<int> momentFrequency = const Value.absent(),
          }) =>
              SettingsTableCompanion.insert(
            id: id,
            provider: provider,
            baseUrl: baseUrl,
            model: model,
            activeHours: activeHours,
            dailyProactiveQuota: dailyProactiveQuota,
            tokenBudget: tokenBudget,
            userName: userName,
            userAvatarPath: userAvatarPath,
            momentFrequency: momentFrequency,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTableTable,
    SettingsTableData,
    $$SettingsTableTableFilterComposer,
    $$SettingsTableTableOrderingComposer,
    $$SettingsTableTableAnnotationComposer,
    $$SettingsTableTableCreateCompanionBuilder,
    $$SettingsTableTableUpdateCompanionBuilder,
    (
      SettingsTableData,
      BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>
    ),
    SettingsTableData,
    PrefetchHooks Function()>;
typedef $$ScheduledProactivesTableCreateCompanionBuilder
    = ScheduledProactivesCompanion Function({
  Value<int> id,
  required int personaId,
  required String content,
  required int scheduledAt,
  Value<int?> notificationId,
  Value<String> status,
  required int createdAt,
});
typedef $$ScheduledProactivesTableUpdateCompanionBuilder
    = ScheduledProactivesCompanion Function({
  Value<int> id,
  Value<int> personaId,
  Value<String> content,
  Value<int> scheduledAt,
  Value<int?> notificationId,
  Value<String> status,
  Value<int> createdAt,
});

final class $$ScheduledProactivesTableReferences extends BaseReferences<
    _$AppDatabase, $ScheduledProactivesTable, ScheduledProactive> {
  $$ScheduledProactivesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PersonasTable _personaIdTable(_$AppDatabase db) =>
      db.personas.createAlias($_aliasNameGenerator(
          db.scheduledProactives.personaId, db.personas.id));

  $$PersonasTableProcessedTableManager? get personaId {
    if ($_item.personaId == null) return null;
    final manager = $$PersonasTableTableManager($_db, $_db.personas)
        .filter((f) => f.id($_item.personaId!));
    final item = $_typedResult.readTableOrNull(_personaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ScheduledProactivesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduledProactivesTable> {
  $$ScheduledProactivesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$PersonasTableFilterComposer get personaId {
    final $$PersonasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableFilterComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduledProactivesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduledProactivesTable> {
  $$ScheduledProactivesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notificationId => $composableBuilder(
      column: $table.notificationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$PersonasTableOrderingComposer get personaId {
    final $$PersonasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableOrderingComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduledProactivesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduledProactivesTable> {
  $$ScheduledProactivesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get scheduledAt => $composableBuilder(
      column: $table.scheduledAt, builder: (column) => column);

  GeneratedColumn<int> get notificationId => $composableBuilder(
      column: $table.notificationId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PersonasTableAnnotationComposer get personaId {
    final $$PersonasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personaId,
        referencedTable: $db.personas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonasTableAnnotationComposer(
              $db: $db,
              $table: $db.personas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ScheduledProactivesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ScheduledProactivesTable,
    ScheduledProactive,
    $$ScheduledProactivesTableFilterComposer,
    $$ScheduledProactivesTableOrderingComposer,
    $$ScheduledProactivesTableAnnotationComposer,
    $$ScheduledProactivesTableCreateCompanionBuilder,
    $$ScheduledProactivesTableUpdateCompanionBuilder,
    (ScheduledProactive, $$ScheduledProactivesTableReferences),
    ScheduledProactive,
    PrefetchHooks Function({bool personaId})> {
  $$ScheduledProactivesTableTableManager(
      _$AppDatabase db, $ScheduledProactivesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduledProactivesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduledProactivesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduledProactivesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> personaId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> scheduledAt = const Value.absent(),
            Value<int?> notificationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
          }) =>
              ScheduledProactivesCompanion(
            id: id,
            personaId: personaId,
            content: content,
            scheduledAt: scheduledAt,
            notificationId: notificationId,
            status: status,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int personaId,
            required String content,
            required int scheduledAt,
            Value<int?> notificationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            required int createdAt,
          }) =>
              ScheduledProactivesCompanion.insert(
            id: id,
            personaId: personaId,
            content: content,
            scheduledAt: scheduledAt,
            notificationId: notificationId,
            status: status,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ScheduledProactivesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({personaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personaId,
                    referencedTable: $$ScheduledProactivesTableReferences
                        ._personaIdTable(db),
                    referencedColumn: $$ScheduledProactivesTableReferences
                        ._personaIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ScheduledProactivesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ScheduledProactivesTable,
    ScheduledProactive,
    $$ScheduledProactivesTableFilterComposer,
    $$ScheduledProactivesTableOrderingComposer,
    $$ScheduledProactivesTableAnnotationComposer,
    $$ScheduledProactivesTableCreateCompanionBuilder,
    $$ScheduledProactivesTableUpdateCompanionBuilder,
    (ScheduledProactive, $$ScheduledProactivesTableReferences),
    ScheduledProactive,
    PrefetchHooks Function({bool personaId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonasTableTableManager get personas =>
      $$PersonasTableTableManager(_db, _db.personas);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$SessionSummariesTableTableManager get sessionSummaries =>
      $$SessionSummariesTableTableManager(_db, _db.sessionSummaries);
  $$FactsTableTableManager get facts =>
      $$FactsTableTableManager(_db, _db.facts);
  $$RelationshipStatesTableTableManager get relationshipStates =>
      $$RelationshipStatesTableTableManager(_db, _db.relationshipStates);
  $$OpenLoopsTableTableManager get openLoops =>
      $$OpenLoopsTableTableManager(_db, _db.openLoops);
  $$StickersTableTableManager get stickers =>
      $$StickersTableTableManager(_db, _db.stickers);
  $$MomentsTableTableManager get moments =>
      $$MomentsTableTableManager(_db, _db.moments);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
  $$ScheduledProactivesTableTableManager get scheduledProactives =>
      $$ScheduledProactivesTableTableManager(_db, _db.scheduledProactives);
}
