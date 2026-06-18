import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/persona.dart';
import '../../domain/models/proactive_tier.dart';
import '../common/image_store.dart';
import '../chat/wechat_theme.dart';
import '../persona/persona_editor_page.dart';

/// 数字人资料页（微信「聊天信息/朋友详情」式）。
///
/// 改头像、备注名（写 personas.avatarPath / name），以及进入更深的人设编辑器。
class PersonaProfilePage extends ConsumerStatefulWidget {
  final int personaId;

  const PersonaProfilePage({super.key, required this.personaId});

  @override
  ConsumerState<PersonaProfilePage> createState() => _PersonaProfilePageState();
}

class _PersonaProfilePageState extends ConsumerState<PersonaProfilePage> {
  Persona? _p;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ref.read(personaRepoProvider).getPersona(widget.personaId);
    if (!mounted) return;
    setState(() {
      _p = p;
      _loading = false;
    });
  }

  Future<void> _changeAvatar() async {
    final path = await pickAndSaveImage(subDir: 'avatars', prefix: 'persona');
    if (path == null || _p == null) return;
    await ref.read(personaRepoProvider).update(_copy(avatarPath: path));
    await _load();
  }

  Future<void> _changeName() async {
    final p = _p;
    if (p == null) return;
    final ctrl = TextEditingController(text: p.name);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('备注名'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('保存')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && name != p.name) {
      await ref.read(personaRepoProvider).update(_copy(name: name));
      await _load();
    }
  }

  Future<void> _changeProactiveTier() async {
    final p = _p;
    if (p == null) return;
    final current = ProactiveTier.fromIndex(p.proactiveTier);
    final picked = await showModalBottomSheet<ProactiveTier>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('TA 主动找我的频率',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            for (final t in ProactiveTier.values)
              ListTile(
                title: Text(t.label),
                subtitle: Text(t.description),
                trailing: t == current
                    ? const Icon(Icons.check, color: WeChat.brand)
                    : null,
                onTap: () => Navigator.pop(context, t),
              ),
          ],
        ),
      ),
    );
    if (picked == null || picked == current) return;
    await ref.read(personaRepoProvider).setProactiveTier(p.id, picked.index);
    await _load();
    // 档位变了立刻重排一次（开启→排下一条；关闭→下次对账不再排）。
    try {
      final engine = await ref.read(proactiveMessageEngineProvider.future);
      await engine.scheduleNext(p.id);
    } catch (_) {/* 排期失败不影响设置 */}
  }

  // Persona 没有 copyWith，这里手动构造。
  Persona _copy({String? name, String? avatarPath}) {
    final p = _p!;
    return Persona(
      id: p.id,
      name: name ?? p.name,
      avatarPath: avatarPath ?? p.avatarPath,
      personaJson: p.personaJson,
      personaJsonInitial: p.personaJsonInitial,
      outwardPersonaJson: p.outwardPersonaJson,
      userAlias: p.userAlias,
      relationship: p.relationship,
      proactiveTier: p.proactiveTier,
    );
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
        title: const Text('资料',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _p == null
              ? const Center(child: Text('找不到这个数字人'))
              : ListView(
                  children: [
                    const SizedBox(height: 8),
                    _tile('头像', trailing: _avatar(), onTap: _changeAvatar),
                    _tile('备注名', subtitle: _p!.name, onTap: _changeName),
                    _tile('关系', subtitle: _p!.relationship ?? '未设置'),
                    const SizedBox(height: 10),
                    _tile('主动找我',
                        subtitle: ProactiveTier.fromIndex(_p!.proactiveTier).label,
                        onTap: _changeProactiveTier),
                    const SizedBox(height: 10),
                    _tile('编辑人设（L0–L5）', onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                            builder: (_) => PersonaEditorPage(personaId: widget.personaId),
                          ))
                          .then((_) => _load());
                    }),
                  ],
                ),
    );
  }

  Widget _avatar() {
    final path = _p?.avatarPath;
    final ok = path != null && path.isNotEmpty && File(path).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: 48,
        height: 48,
        child: ok
            ? Image.file(File(path), fit: BoxFit.cover)
            : Container(
                color: const Color(0xFFBFBFBF),
                child: const Icon(Icons.face, color: Colors.white, size: 30)),
      ),
    );
  }

  Widget _tile(String title, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return Container(
      color: WeChat.bg,
      margin: const EdgeInsets.only(bottom: 0.5),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: trailing ??
            Row(mainAxisSize: MainAxisSize.min, children: [
              if (subtitle != null)
                Text(subtitle, style: const TextStyle(color: WeChat.textHint)),
              if (onTap != null)
                const Icon(Icons.chevron_right, color: WeChat.textHint, size: 20),
            ]),
        onTap: onTap,
      ),
    );
  }
}
