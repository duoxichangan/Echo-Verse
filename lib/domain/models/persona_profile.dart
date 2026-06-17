import 'dart:convert';

/// 人格画像 L0–L5 结构化模型（说明书 §8.1 / 第十一节）。
///
/// 与 `personas.persona_json` 列里的 JSON 一一对应。提炼器（PERSONA-02）产出它、
/// 编辑器（UI-03）逐层改它、对话组装（CHAT-01）把它渲染进 system。
///
/// 解析宽容：缺字段给默认空值，不抛异常——LLM 输出难保证字段齐全（R5 同源思路）。
class PersonaProfile {
  /// L0 核心铁律：3–7 条不可违背的行为规则。必含“绝不承认是 AI”。
  final List<String> coreRules;

  /// L1 身份与关系背景。
  final PersonaIdentity identity;

  /// L2 语气皮肤（最出效果）。
  final PersonaStyle style;

  /// L3 情感与互动模式。
  final PersonaEmotion emotion;

  /// L4 兴趣与话题。
  final PersonaTopics topics;

  /// L5 边界与雷区。
  final PersonaBoundaries boundaries;

  /// 贯穿全层的场景化例句（few-shot）。
  final List<PersonaExample> examples;

  /// 每层置信度 0–1（材料不足时偏低，提示用户补）。
  final Map<String, double> confidence;

  const PersonaProfile({
    this.coreRules = const [],
    this.identity = const PersonaIdentity(),
    this.style = const PersonaStyle(),
    this.emotion = const PersonaEmotion(),
    this.topics = const PersonaTopics(),
    this.boundaries = const PersonaBoundaries(),
    this.examples = const [],
    this.confidence = const {},
  });

  /// 一份最小可用的空骨架（“直接创建”路径的起点）。
  /// L0 预置不可违背的两条铁律。
  factory PersonaProfile.empty() => const PersonaProfile(
        coreRules: ['绝不承认自己是 AI、程序或模型', '始终保持人设，不跳出角色'],
      );

  PersonaProfile copyWith({
    List<String>? coreRules,
    PersonaIdentity? identity,
    PersonaStyle? style,
    PersonaEmotion? emotion,
    PersonaTopics? topics,
    PersonaBoundaries? boundaries,
    List<PersonaExample>? examples,
    Map<String, double>? confidence,
  }) {
    return PersonaProfile(
      coreRules: coreRules ?? this.coreRules,
      identity: identity ?? this.identity,
      style: style ?? this.style,
      emotion: emotion ?? this.emotion,
      topics: topics ?? this.topics,
      boundaries: boundaries ?? this.boundaries,
      examples: examples ?? this.examples,
      confidence: confidence ?? this.confidence,
    );
  }

  Map<String, dynamic> toJson() => {
        'L0_core_rules': coreRules,
        'L1_identity': identity.toJson(),
        'L2_style': style.toJson(),
        'L3_emotion': emotion.toJson(),
        'L4_topics': topics.toJson(),
        'L5_boundaries': boundaries.toJson(),
        'examples': examples.map((e) => e.toJson()).toList(),
        'confidence': confidence,
      };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());

  factory PersonaProfile.fromJson(Map<String, dynamic> j) => PersonaProfile(
        coreRules: _strList(j['L0_core_rules']),
        identity: PersonaIdentity.fromJson(_map(j['L1_identity'])),
        style: PersonaStyle.fromJson(_map(j['L2_style'])),
        emotion: PersonaEmotion.fromJson(_map(j['L3_emotion'])),
        topics: PersonaTopics.fromJson(_map(j['L4_topics'])),
        boundaries: PersonaBoundaries.fromJson(_map(j['L5_boundaries'])),
        examples: (j['examples'] as List?)
                ?.whereType<Map>()
                .map((e) => PersonaExample.fromJson(e.cast<String, dynamic>()))
                .toList() ??
            const [],
        confidence: _doubleMap(j['confidence']),
      );

  /// 从 JSON 字符串解析；解析失败回退空骨架（不抛，保证建号不中断）。
  factory PersonaProfile.fromJsonString(String s) {
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map<String, dynamic>) return PersonaProfile.fromJson(decoded);
    } catch (_) {/* 落到空骨架 */}
    return PersonaProfile.empty();
  }
}

/// L1 身份与关系背景。
class PersonaIdentity {
  final String who; // TA 是谁
  final String relationship; // 和用户什么关系
  final String userAlias; // 怎么称呼用户
  final List<String> anchors; // 重大共同记忆锚点

  const PersonaIdentity({
    this.who = '',
    this.relationship = '',
    this.userAlias = '',
    this.anchors = const [],
  });

  Map<String, dynamic> toJson() => {
        'who': who,
        'relationship': relationship,
        'user_alias': userAlias,
        'anchors': anchors,
      };

  factory PersonaIdentity.fromJson(Map<String, dynamic> j) => PersonaIdentity(
        who: _str(j['who']),
        relationship: _str(j['relationship']),
        userAlias: _str(j['user_alias']),
        anchors: _strList(j['anchors']),
      );
}

/// L2 语气皮肤。
class PersonaStyle {
  final List<String> catchphrases; // 口头禅
  final List<String> highFreq; // 高频词
  final String sentence; // 句长/句式描述
  final String punctuation; // 标点习惯
  final String typos; // 错别字习惯
  final String emoji; // emoji 习惯
  final bool multiMsg; // 爱不爱连发短消息
  final int formality; // 正式度 1–5

  const PersonaStyle({
    this.catchphrases = const [],
    this.highFreq = const [],
    this.sentence = '',
    this.punctuation = '',
    this.typos = '',
    this.emoji = '',
    this.multiMsg = true,
    this.formality = 2,
  });

  Map<String, dynamic> toJson() => {
        'catchphrases': catchphrases,
        'high_freq': highFreq,
        'sentence': sentence,
        'punctuation': punctuation,
        'typos': typos,
        'emoji': emoji,
        'multi_msg': multiMsg,
        'formality': formality,
      };

  PersonaStyle copyWith({
    List<String>? catchphrases,
    List<String>? highFreq,
    String? sentence,
    String? punctuation,
    String? typos,
    String? emoji,
    bool? multiMsg,
    int? formality,
  }) {
    return PersonaStyle(
      catchphrases: catchphrases ?? this.catchphrases,
      highFreq: highFreq ?? this.highFreq,
      sentence: sentence ?? this.sentence,
      punctuation: punctuation ?? this.punctuation,
      typos: typos ?? this.typos,
      emoji: emoji ?? this.emoji,
      multiMsg: multiMsg ?? this.multiMsg,
      formality: formality ?? this.formality,
    );
  }

  factory PersonaStyle.fromJson(Map<String, dynamic> j) => PersonaStyle(
        catchphrases: _strList(j['catchphrases']),
        highFreq: _strList(j['high_freq']),
        sentence: _str(j['sentence']),
        punctuation: _str(j['punctuation']),
        typos: _str(j['typos']),
        emoji: _str(j['emoji']),
        multiMsg: j['multi_msg'] is bool ? j['multi_msg'] as bool : true,
        formality: _int(j['formality'], fallback: 2),
      );
}

/// L3 情感与互动模式。
class PersonaEmotion {
  final String happy;
  final String angry;
  final String comfort;
  final String joke;

  const PersonaEmotion({
    this.happy = '',
    this.angry = '',
    this.comfort = '',
    this.joke = '',
  });

  Map<String, dynamic> toJson() =>
      {'happy': happy, 'angry': angry, 'comfort': comfort, 'joke': joke};

  factory PersonaEmotion.fromJson(Map<String, dynamic> j) => PersonaEmotion(
        happy: _str(j['happy']),
        angry: _str(j['angry']),
        comfort: _str(j['comfort']),
        joke: _str(j['joke']),
      );
}

/// L4 兴趣与话题。
class PersonaTopics {
  final List<String> loves;
  final List<String> cold;
  final List<String> knows;
  final List<String> notKnows;

  const PersonaTopics({
    this.loves = const [],
    this.cold = const [],
    this.knows = const [],
    this.notKnows = const [],
  });

  Map<String, dynamic> toJson() => {
        'loves': loves,
        'cold': cold,
        'knows': knows,
        'not_knows': notKnows,
      };

  factory PersonaTopics.fromJson(Map<String, dynamic> j) => PersonaTopics(
        loves: _strList(j['loves']),
        cold: _strList(j['cold']),
        knows: _strList(j['knows']),
        notKnows: _strList(j['not_knows']),
      );
}

/// L5 边界与雷区。
class PersonaBoundaries {
  final List<String> dislikes;
  final List<String> avoid;
  final List<String> triggers;

  const PersonaBoundaries({
    this.dislikes = const [],
    this.avoid = const [],
    this.triggers = const [],
  });

  Map<String, dynamic> toJson() =>
      {'dislikes': dislikes, 'avoid': avoid, 'triggers': triggers};

  factory PersonaBoundaries.fromJson(Map<String, dynamic> j) =>
      PersonaBoundaries(
        dislikes: _strList(j['dislikes']),
        avoid: _strList(j['avoid']),
        triggers: _strList(j['triggers']),
      );
}

/// 场景化例句（few-shot）。
class PersonaExample {
  final String context; // 什么情境
  final String reply; // TA 会怎么回

  const PersonaExample({this.context = '', this.reply = ''});

  Map<String, dynamic> toJson() => {'context': context, 'reply': reply};

  factory PersonaExample.fromJson(Map<String, dynamic> j) =>
      PersonaExample(context: _str(j['context']), reply: _str(j['reply']));
}

// ── 宽容解析辅助 ─────────────────────────────────────────
String _str(dynamic v) => v == null ? '' : v.toString();

List<String> _strList(dynamic v) =>
    v is List ? v.map((e) => e.toString()).toList() : const [];

Map<String, dynamic> _map(dynamic v) =>
    v is Map ? v.cast<String, dynamic>() : const {};

int _int(dynamic v, {int fallback = 0}) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

Map<String, double> _doubleMap(dynamic v) {
  if (v is! Map) return const {};
  final out = <String, double>{};
  v.forEach((k, val) {
    final d = val is num ? val.toDouble() : double.tryParse('$val');
    if (d != null) out[k.toString()] = d;
  });
  return out;
}
