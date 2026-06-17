import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/contracts/persona_builder.dart';
import '../chat/wechat_theme.dart';
import 'import_persona_page.dart';

/// 建号向导（UI-02 的「直接创建」路径，手册 PERSONA-02 §11.2）。
///
/// 不导入聊天记录，用户填几项关键设定 → `buildFromHints` 本地生成默认 L0–L5 画像
/// → 落库。导入 txt 的入口先占位（解析/提炼逻辑已就绪，UI 下一版接）。
class CreatePersonaPage extends ConsumerStatefulWidget {
  const CreatePersonaPage({super.key});

  @override
  ConsumerState<CreatePersonaPage> createState() => _CreatePersonaPageState();
}

class _CreatePersonaPageState extends ConsumerState<CreatePersonaPage> {
  final _name = TextEditingController();
  final _relationship = TextEditingController();
  final _alias = TextEditingController();
  final _traits = TextEditingController();
  bool _saving = false;

  bool get _canSave => _name.text.trim().isNotEmpty && !_saving;

  Future<void> _create() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    try {
      final builder = await ref.read(personaBuilderProvider.future);
      final hints = PersonaHints(
        name: _name.text.trim(),
        relationship: _emptyToNull(_relationship.text),
        userAlias: _emptyToNull(_alias.text),
        personalityHints: _emptyToNull(_traits.text),
      );
      final profile = builder.buildFromHints(hints);

      final repo = ref.read(personaRepoProvider);
      await repo.create(
        name: hints.name,
        personaJson: profile.toJsonString(),
        userAlias: hints.userAlias,
        relationship: hints.relationship,
      );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('创建失败：$e')));
      }
    }
  }

  String? _emptyToNull(String s) => s.trim().isEmpty ? null : s.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeChat.bg,
      appBar: AppBar(
        backgroundColor: WeChat.barBg,
        foregroundColor: WeChat.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(
          bottom: BorderSide(color: WeChat.divider, width: 0.5),
        ),
        title: const Text('创建数字人',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 导入入口（占位）。
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.upload_file, color: WeChat.brand),
              title: const Text('从微信聊天记录导入'),
              subtitle: const Text('提炼出“聊起来像本人”的人格'),
              trailing: const Icon(Icons.chevron_right, color: WeChat.textHint),
              onTap: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => const ImportPersonaPage()),
                );
                // 导入成功则把结果透传回 HomePage（它会刷新列表）。
                if (created == true && context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text('或者，直接创建一个并填写设定',
                style: TextStyle(color: WeChat.textHint, fontSize: 13)),
          ),
          _field('昵称 *', _name, hint: '给 TA 起个名字'),
          _field('和你的关系', _relationship, hint: '女朋友 / 好友 / 家人…'),
          _field('TA 怎么称呼你', _alias, hint: '笨蛋 / 宝 / 你的名字…'),
          _field('性格关键词', _traits,
              hint: '温柔、毒舌、爱撒娇…（顿号/逗号分隔）', maxLines: 2),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '创建后可在「编辑设定」里逐层完善人格（L0 铁律已预置“绝不承认是 AI”）。',
              style: TextStyle(color: WeChat.textHint, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _canSave ? _create : null,
            style: FilledButton.styleFrom(
              backgroundColor: WeChat.brand,
              minimumSize: const Size.fromHeight(48),
            ),
            child: Text(_saving ? '创建中…' : '创建'),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {String? hint, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: WeChat.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: WeChat.divider),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _relationship.dispose();
    _alias.dispose();
    _traits.dispose();
    super.dispose();
  }
}
