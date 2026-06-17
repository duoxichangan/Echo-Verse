import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../data/db/database.dart';
import '../memory/memory_panel_page.dart';
import '../moments/moments_page.dart';
import '../persona/persona_editor_page.dart';
import '../settings/settings_page.dart';
import '../sticker/sticker_manager_page.dart';
import 'chat_bubble.dart';
import 'wechat_theme.dart';

/// UI-01 聊天页（说明书 §15：1:1 复刻微信）。
///
/// 接 [chatEngineProvider]：打字 → 发送 → 数字人分条蹦出回复，
/// 期间顶栏标题下显示“对方正在输入…”。历史消息从 messages 表加载。
class ChatPage extends ConsumerStatefulWidget {
  final int personaId;
  final String personaName;
  final String? peerAvatarPath;

  const ChatPage({
    super.key,
    required this.personaId,
    required this.personaName,
    this.peerAvatarPath,
  });

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _bubbles = <ChatBubbleData>[];

  bool _loading = true;
  bool _typing = false; // 对方正在输入
  bool _sending = false; // 防重复发送

  @override
  void initState() {
    super.initState();
    _inputCtrl.addListener(() => setState(() {})); // 输入变化切换发送按钮
    _loadHistory();
    // 把刚提炼出的 pending 开放回路纳入调度（预约通知）。失败不影响聊天。
    ref.read(openLoopEngineProvider).processPending(widget.personaId).ignore();
  }

  Future<void> _loadHistory() async {
    final db = ref.read(databaseProvider);
    final rows = await (db.select(db.messages)
          ..where((m) => m.personaId.equals(widget.personaId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .get();
    setState(() {
      _bubbles.clear();
      for (final r in rows) {
        _bubbles.add(_toBubble(r));
      }
      _loading = false;
    });
    _jumpToBottom();
  }

  ChatBubbleData _toBubble(Message r) {
    final isSelf = r.sender == 'user';
    if (r.type == 'sticker') {
      return ChatBubbleData.sticker(r.content, isSelf: isSelf);
    }
    return ChatBubbleData.text(r.content, isSelf: isSelf);
  }

  Future<void> _send() async {
    final text = _inputCtrl.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _sending = true;
      _bubbles.add(ChatBubbleData.text(text, isSelf: true));
      _inputCtrl.clear();
      _typing = true;
    });
    _scrollToBottom();

    try {
      final engine = await ref.read(chatEngineProvider.future);
      await for (final m in engine.send(widget.personaId, text)) {
        if (!mounted) return;
        setState(() {
          _bubbles.add(
            m.stickerPath != null
                ? ChatBubbleData.sticker(m.stickerPath, isSelf: false)
                : ChatBubbleData.text(m.content, isSelf: false),
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _bubbles.add(
              ChatBubbleData.text('（消息发送失败：$e）', isSelf: false),
            ));
      }
    } finally {
      if (mounted) {
        setState(() {
          _typing = false;
          _sending = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WeChat.bg,
      appBar: _appBar(),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _bubbles.length,
                    itemBuilder: (_, i) => ChatBubble(
                      data: _bubbles[i],
                      peerAvatarPath: widget.peerAvatarPath,
                    ),
                  ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: WeChat.barBg,
      foregroundColor: WeChat.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: const Border(
        bottom: BorderSide(color: WeChat.divider, width: 0.5),
      ),
      titleSpacing: 0,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.personaName,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: WeChat.textPrimary,
            ),
          ),
          if (_typing)
            const Text(
              '对方正在输入…',
              style: TextStyle(fontSize: 12, color: WeChat.textHint),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz),
          tooltip: '更多',
          onSelected: (v) {
            if (v == 'memory') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MemoryPanelPage(
                  personaId: widget.personaId,
                  personaName: widget.personaName,
                ),
              ));
            } else if (v == 'persona') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => PersonaEditorPage(personaId: widget.personaId),
              ));
            } else if (v == 'stickers') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => StickerManagerPage(personaId: widget.personaId),
              ));
            } else if (v == 'moments') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MomentsPage(
                  personaId: widget.personaId,
                  personaName: widget.personaName,
                ),
              ));
            } else if (v == 'settings') {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'memory', child: Text('查看 TA 的记忆')),
            PopupMenuItem(value: 'persona', child: Text('编辑人设')),
            PopupMenuItem(value: 'stickers', child: Text('表情包')),
            PopupMenuItem(value: 'moments', child: Text('TA 的朋友圈')),
            PopupMenuItem(value: 'settings', child: Text('设置')),
          ],
        ),
      ],
    );
  }

  Widget _inputBar() {
    final hasText = _inputCtrl.text.trim().isNotEmpty;
    return Container(
      color: WeChat.barBg,
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 7,
        bottom: 7 + MediaQuery.of(context).padding.bottom,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _circleIcon(Icons.keyboard_voice_outlined),
          const SizedBox(width: 6),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 38),
              decoration: BoxDecoration(
                color: WeChat.inputFieldBg,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              child: TextField(
                controller: _inputCtrl,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                style: const TextStyle(fontSize: 16, color: WeChat.textPrimary),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          _circleIcon(Icons.emoji_emotions_outlined, onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => StickerManagerPage(personaId: widget.personaId),
            ));
          }),
          const SizedBox(width: 6),
          if (hasText)
            _sendButton()
          else
            _circleIcon(Icons.add_circle_outline),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return IconButton(
      icon: Icon(icon, size: 28, color: const Color(0xFF54545A)),
      onPressed: onTap ?? () {}, // 无回调的为 UI 占位（语音等后续接入）
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
    );
  }

  Widget _sendButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: FilledButton(
        onPressed: _sending ? null : _send,
        style: FilledButton.styleFrom(
          backgroundColor: WeChat.brand,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          minimumSize: const Size(0, 38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Text('发送', style: TextStyle(fontSize: 15)),
      ),
    );
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }
}
