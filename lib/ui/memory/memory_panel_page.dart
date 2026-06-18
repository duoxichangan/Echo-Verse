import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/memory_fact.dart';
import '../chat/wechat_theme.dart';

/// 记忆管理面板（手册 MEM-04 / 说明书 §8.3 透明度）。
///
/// 用户可看「数字人记住了哪些事」，并删 / 改 / 置顶为永久（pinned 跳过衰减）。
/// 隐私可控，是信任加分项。
class MemoryPanelPage extends ConsumerStatefulWidget {
  final int personaId;
  final String personaName;

  const MemoryPanelPage({
    super.key,
    required this.personaId,
    required this.personaName,
  });

  @override
  ConsumerState<MemoryPanelPage> createState() => _MemoryPanelPageState();
}

class _MemoryPanelPageState extends ConsumerState<MemoryPanelPage> {
  List<MemoryFact> _facts = [];
  RelationshipSnapshot? _rel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final svc = ref.read(memoryServiceProvider);
    final facts = await svc.listFacts(widget.personaId);
    final rel = await svc.readRelationship(widget.personaId);
    if (!mounted) return;
    setState(() {
      _facts = facts;
      _rel = rel;
      _loading = false;
    });
  }

  Future<void> _togglePin(MemoryFact f) async {
    await ref.read(memoryServiceProvider).setFactPinned(f.id, !f.pinned);
    await _load();
  }

  Future<void> _delete(MemoryFact f) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('删除这条记忆？'),
        content: Text(f.content),
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
      await ref.read(memoryServiceProvider).deleteFact(f.id);
      await _load();
    }
  }

  Future<void> _edit(MemoryFact f) async {
    final ctrl = TextEditingController(text: f.content);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('修改记忆'),
        content: TextField(
          controller: ctrl,
          maxLines: 3,
          autofocus: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('保存')),
        ],
      ),
    );
    if (result != null && result.isNotEmpty && result != f.content) {
      await ref.read(memoryServiceProvider).updateFactContent(f.id, result);
      await _load();
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
        title: Text('${widget.personaName}的记忆',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                if (_rel != null) _relCard(_rel!),
                _sectionHeader('记住的事（${_facts.length}）'),
                if (_facts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text('还没记住什么，多聊聊就有了',
                          style: TextStyle(color: WeChat.textHint)),
                    ),
                  )
                else
                  ..._facts.map(_factTile),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _relCard(RelationshipSnapshot rel) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: WeChat.bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('此刻的关系',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 8),
          Row(children: [
            const Text('情绪：', style: TextStyle(color: WeChat.textHint)),
            Text(rel.mood.isEmpty ? '平静' : rel.mood),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Text('亲密度：', style: TextStyle(color: WeChat.textHint)),
            Expanded(
              child: LinearProgressIndicator(
                value: rel.closeness,
                color: WeChat.brand,
                backgroundColor: WeChat.divider,
              ),
            ),
            const SizedBox(width: 8),
            Text(rel.closeness.toStringAsFixed(2)),
          ]),
          if (rel.unresolved.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('未了结的事：', style: TextStyle(color: WeChat.textHint)),
            ...rel.unresolved.map((u) => Text('· $u')),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Text(title,
            style: const TextStyle(color: WeChat.textHint, fontSize: 13)),
      );

  Widget _factTile(MemoryFact f) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: WeChat.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          f.pinned ? Icons.push_pin : Icons.lightbulb_outline,
          color: f.pinned ? WeChat.brand : WeChat.textHint,
          size: 22,
        ),
        title: Text(f.content),
        subtitle: Text(
          f.pinned
              ? '已置顶 · 永久记住'
              : '显著度 ${f.salience.toStringAsFixed(2)}（重要性 ${f.importance.toStringAsFixed(1)}）',
          style: const TextStyle(fontSize: 12, color: WeChat.textHint),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: WeChat.textHint),
          onSelected: (v) {
            if (v == 'pin') _togglePin(f);
            if (v == 'edit') _edit(f);
            if (v == 'delete') _delete(f);
          },
          itemBuilder: (_) => [
            PopupMenuItem(value: 'pin', child: Text(f.pinned ? '取消置顶' : '置顶为永久')),
            const PopupMenuItem(value: 'edit', child: Text('修改')),
            const PopupMenuItem(value: 'delete', child: Text('删除')),
          ],
        ),
      ),
    );
  }
}
