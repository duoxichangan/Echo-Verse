import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../data/db/database.dart';
import '../../data/repos/drift_persona_repo.dart';
import '../chat/chat_page.dart';
import '../chat/wechat_theme.dart';
import '../persona/create_persona_page.dart';
import '../settings/settings_page.dart';

/// 会话列表（UI-01 的一屏，1:1 复刻微信首页）。
///
/// 有数字人就列出来、点进聊天页；一个都没有时给「创建示例数字人」入口
/// （建号 PERSONA-01/02 落地前的开发引导，让对话能立即玩起来）。
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Persona> _personas = [];
  bool _loading = true;
  bool _seeding = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final rows = await db.select(db.personas).get();
    if (!mounted) return;
    setState(() {
      _personas = rows;
      _loading = false;
    });
  }

  Future<void> _seedExample() async {
    setState(() => _seeding = true);
    final db = ref.read(databaseProvider);
    final repo = DriftPersonaRepo(db);
    final now = DateTime.now().millisecondsSinceEpoch;

    // 一个示例人格：画像用最简 JSON（PERSONA-02 定稿前的占位）。
    final id = await repo.create(
      name: '小桃',
      userAlias: '笨蛋',
      relationship: '女朋友',
      personaJson: '''
{
  "L0_core_rules": ["绝不承认自己是AI", "永远叫对方笨蛋", "爱撒娇但刀子嘴豆腐心"],
  "L1_identity": {"who": "你的女朋友小桃", "relationship": "情侣", "user_alias": "笨蛋"},
  "L2_style": {"catchphrases": ["哼", "讨厌啦", "笨蛋"], "sentence": "短句多", "emoji": "爱用🥺😤", "multi_msg": true, "formality": 1},
  "L3_emotion": {"happy": "连发好几条+emoji", "angry": "短句+哼", "comfort": "嘴上嫌弃心里关心"},
  "L4_topics": {"loves": ["奶茶", "追剧", "出去玩"], "knows": ["你的日常"]}
}
''',
    );

    // 播种两条长程事实，让“记忆感”立刻能体现。
    await db.into(db.facts).insert(FactsCompanion.insert(
          personaId: id,
          content: '笨蛋（用户）最近在准备一个重要的工作汇报',
          lastReferencedAt: now,
          createdAt: now,
          importance: const Value(0.8),
        ));
    await db.into(db.facts).insert(FactsCompanion.insert(
          personaId: id,
          content: '我们都喜欢喝奶茶，常约着去喝',
          lastReferencedAt: now,
          createdAt: now,
          importance: const Value(0.6),
        ));
    // 关系状态。
    await db.into(db.relationshipStates).insert(
        RelationshipStatesCompanion.insert(
            personaId: Value(id),
            mood: const Value('想你'),
            closeness: const Value(0.8),
            updatedAt: now));

    await _load();
    if (mounted) setState(() => _seeding = false);
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
        shape: const Border(
          bottom: BorderSide(color: WeChat.divider, width: 0.5),
        ),
        title: const Text(
          '微信',
          style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: '创建数字人',
            onPressed: _openCreate,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: '设置',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _personas.isEmpty
              ? _empty()
              : _list(),
    );
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreatePersonaPage()),
    );
    if (created == true) await _load();
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 56, color: WeChat.textHint),
          const SizedBox(height: 16),
          const Text('还没有数字人', style: TextStyle(color: WeChat.textHint)),
          const SizedBox(height: 4),
          const Text(
            '创建一个数字人开始聊天\n（可直接填设定，也可导入聊天记录提炼）',
            textAlign: TextAlign.center,
            style: TextStyle(color: WeChat.textHint, fontSize: 13),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _openCreate,
            style: FilledButton.styleFrom(backgroundColor: WeChat.brand),
            child: const Text('创建数字人'),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _seeding ? null : _seedExample,
            child: Text(_seeding ? '创建中…' : '快速体验示例「小桃」'),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    return ListView.separated(
      itemCount: _personas.length,
      separatorBuilder: (_, _) => const Divider(
        height: 0.5,
        thickness: 0.5,
        indent: 76,
        color: WeChat.divider,
      ),
      itemBuilder: (_, i) {
        final p = _personas[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 48,
              height: 48,
              color: const Color(0xFFBFBFBF),
              child: const Icon(Icons.face, color: Colors.white, size: 30),
            ),
          ),
          title: Text(
            p.name,
            style: const TextStyle(
                fontSize: 17, color: WeChat.textPrimary),
          ),
          subtitle: Text(
            p.relationship ?? '点进来聊天',
            style: const TextStyle(fontSize: 14, color: WeChat.textHint),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => ChatPage(
                  personaId: p.id,
                  personaName: p.name,
                  peerAvatarPath: p.avatarPath,
                ),
              ))
              .then((_) => _load()),
          onLongPress: () => _confirmDelete(p),
        );
      },
    );
  }

  Future<void> _confirmDelete(Persona p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('删除「${p.name}」？'),
        content: const Text('会永久删除 TA 的所有聊天、记忆、表情和朋友圈，不可恢复。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('删除', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(personaRepoProvider).delete(p.id);
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('已删除「${p.name}」')));
      }
    }
  }
}
