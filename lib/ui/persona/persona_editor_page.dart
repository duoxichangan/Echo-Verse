import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/persona.dart';
import '../../domain/models/persona_profile.dart';
import '../chat/wechat_theme.dart';

/// 画像编辑器（手册 UI-03 / PERSONA-03 / 说明书 §4.2）。
///
/// 逐层展示并编辑 L0–L5 + 置信度提示，支持「恢复到初始生成版本」（R6）。
/// 列表型字段用换行分隔编辑，落库时写回 persona_json。
class PersonaEditorPage extends ConsumerStatefulWidget {
  final int personaId;

  const PersonaEditorPage({super.key, required this.personaId});

  @override
  ConsumerState<PersonaEditorPage> createState() => _PersonaEditorPageState();
}

class _PersonaEditorPageState extends ConsumerState<PersonaEditorPage> {
  Persona? _persona;
  PersonaProfile? _profile;
  bool _loading = true;
  bool _dirty = false;

  // 各字段控制器。
  final _coreRules = TextEditingController();
  final _who = TextEditingController();
  final _relationship = TextEditingController();
  final _userAlias = TextEditingController();
  final _catchphrases = TextEditingController();
  final _emoji = TextEditingController();
  final _loves = TextEditingController();
  final _dislikes = TextEditingController();
  bool _multiMsg = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ref.read(personaRepoProvider).getPersona(widget.personaId);
    if (p == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    final profile = PersonaProfile.fromJsonString(p.personaJson);
    _fill(profile);
    if (!mounted) return;
    setState(() {
      _persona = p;
      _profile = profile;
      _loading = false;
    });
  }

  void _fill(PersonaProfile pr) {
    _coreRules.text = pr.coreRules.join('\n');
    _who.text = pr.identity.who;
    _relationship.text = pr.identity.relationship;
    _userAlias.text = pr.identity.userAlias;
    _catchphrases.text = pr.style.catchphrases.join('、');
    _emoji.text = pr.style.emoji;
    _loves.text = pr.topics.loves.join('、');
    _dislikes.text = pr.boundaries.dislikes.join('、');
    _multiMsg = pr.style.multiMsg;
  }

  PersonaProfile _collect() {
    final base = _profile ?? PersonaProfile.empty();
    return base.copyWith(
      coreRules: _lines(_coreRules.text),
      identity: PersonaIdentity(
        who: _who.text.trim(),
        relationship: _relationship.text.trim(),
        userAlias: _userAlias.text.trim(),
        anchors: base.identity.anchors,
      ),
      style: base.style.copyWith(
        catchphrases: _items(_catchphrases.text),
        emoji: _emoji.text.trim(),
        multiMsg: _multiMsg,
      ),
      topics: PersonaTopics(
        loves: _items(_loves.text),
        cold: base.topics.cold,
        knows: base.topics.knows,
        notKnows: base.topics.notKnows,
      ),
      boundaries: PersonaBoundaries(
        dislikes: _items(_dislikes.text),
        avoid: base.boundaries.avoid,
        triggers: base.boundaries.triggers,
      ),
    );
  }

  List<String> _lines(String s) =>
      s.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  List<String> _items(String s) => s
      .split(RegExp(r'[，,、;；\n]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final p = _persona;
    if (p == null) return;
    final profile = _collect();
    final updated = Persona(
      id: p.id,
      name: p.name,
      avatarPath: p.avatarPath,
      personaJson: profile.toJsonString(),
      personaJsonInitial: p.personaJsonInitial,
      outwardPersonaJson: p.outwardPersonaJson,
      userAlias: _userAlias.text.trim().isEmpty ? p.userAlias : _userAlias.text.trim(),
      relationship:
          _relationship.text.trim().isEmpty ? p.relationship : _relationship.text.trim(),
    );
    await ref.read(personaRepoProvider).update(updated);
    if (mounted) {
      setState(() => _dirty = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已保存')));
    }
  }

  Future<void> _restore() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('恢复到初始生成版本？'),
        content: const Text('会丢弃你对画像的所有修改，回到刚建号时的版本。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('恢复')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(personaRepoProvider).restoreInitial(widget.personaId);
    await _load();
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('已恢复到初始版本')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeChat.bg,
      appBar: AppBar(
        backgroundColor: WeChat.barBg,
        foregroundColor: WeChat.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: WeChat.divider, width: 0.5)),
        title: const Text('编辑人设',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
        actions: [
          if (!_loading && _persona != null)
            IconButton(
              icon: const Icon(Icons.restore),
              tooltip: '恢复初始版本',
              onPressed: _restore,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _persona == null
              ? const Center(child: Text('找不到这个数字人'))
              : _form(),
      bottomNavigationBar: (_loading || _persona == null)
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton(
                  onPressed: _dirty ? _save : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: WeChat.brand,
                    minimumSize: const Size.fromHeight(46),
                  ),
                  child: Text(_dirty ? '保存修改' : '没有改动'),
                ),
              ),
            ),
    );
  }

  Widget _form() {
    final conf = _profile?.confidence ?? const {};
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _section('L0 核心铁律', '不可违背的行为规则，每行一条', conf['L0']),
        _multiline(_coreRules, '每行一条铁律'),
        _section('L1 身份与关系', 'TA 是谁、和你什么关系', conf['L1']),
        _line(_who, 'TA 是谁'),
        _line(_relationship, '关系（女友/好友…）'),
        _line(_userAlias, 'TA 怎么称呼你'),
        _section('L2 语气', '口头禅、emoji、是否连发', conf['L2']),
        _line(_catchphrases, '口头禅（顿号分隔）'),
        _line(_emoji, 'emoji 习惯'),
        SwitchListTile(
          title: const Text('爱连发多条短消息'),
          value: _multiMsg,
          activeThumbColor: WeChat.brand,
          contentPadding: EdgeInsets.zero,
          onChanged: (v) => setState(() {
            _multiMsg = v;
            _dirty = true;
          }),
        ),
        _section('L4 兴趣', '爱聊什么', conf['L4']),
        _line(_loves, '喜欢的话题（顿号分隔）'),
        _section('L5 边界', '不爱聊/会不高兴的', conf['L5']),
        _line(_dislikes, '不喜欢的（顿号分隔）'),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _section(String title, String hint, double? confidence) {
    final low = confidence != null && confidence < 0.4;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(width: 8),
          if (low)
            const Text('材料不足，建议补充',
                style: TextStyle(fontSize: 11, color: Colors.orange))
          else if (confidence != null)
            Text('置信度 ${confidence.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 11, color: WeChat.textHint)),
          const Spacer(),
          Flexible(
            child: Text(hint,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 11, color: WeChat.textHint)),
          ),
        ],
      ),
    );
  }

  Widget _line(TextEditingController c, String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(
          controller: c,
          onChanged: (_) => _markDirty(),
          decoration: _dec(hint),
        ),
      );

  Widget _multiline(TextEditingController c, String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextField(
          controller: c,
          maxLines: null,
          minLines: 3,
          onChanged: (_) => _markDirty(),
          decoration: _dec(hint),
        ),
      );

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WeChat.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: WeChat.divider),
        ),
      );

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  @override
  void dispose() {
    for (final c in [
      _coreRules, _who, _relationship, _userAlias,
      _catchphrases, _emoji, _loves, _dislikes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }
}
