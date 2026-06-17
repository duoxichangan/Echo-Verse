import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/moment.dart';
import '../chat/wechat_theme.dart';

/// 朋友圈页（UI-06 / 说明书第十七节，复刻微信朋友圈）。
///
/// 列出数字人的纯文字朋友圈；用户可点赞（→ 登记开放回路，数字人下次私聊自然提起）。
/// 右上"发一条"手动触发发布（受调度中枢约束；真实场景由作息自动发）。
class MomentsPage extends ConsumerStatefulWidget {
  final int personaId;
  final String personaName;

  const MomentsPage({
    super.key,
    required this.personaId,
    required this.personaName,
  });

  @override
  ConsumerState<MomentsPage> createState() => _MomentsPageState();
}

class _MomentsPageState extends ConsumerState<MomentsPage> {
  List<MomentView> _moments = [];
  bool _loading = true;
  bool _publishing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final svc = await ref.read(socialServiceProvider.future);
    final list = await svc.listMoments(widget.personaId);
    if (!mounted) return;
    setState(() {
      _moments = list;
      _loading = false;
    });
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    try {
      final svc = await ref.read(socialServiceProvider.future);
      final m = await svc.maybePublish(widget.personaId);
      if (!mounted) return;
      if (m == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('现在不是发朋友圈的时候（作息/配额限制）')));
      } else {
        await _load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('发布失败：$e')));
      }
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  Future<void> _toggleLike(MomentView m) async {
    final svc = await ref.read(socialServiceProvider.future);
    await svc.setLiked(m.id, !m.likedByUser);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: WeChat.barBg,
        foregroundColor: WeChat.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: WeChat.divider, width: 0.5)),
        title: const Text('朋友圈',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _publishing
                ? const SizedBox(
                    width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.add_a_photo_outlined),
            tooltip: '让 TA 发一条',
            onPressed: _publishing ? null : _publish,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _cover(),
                Expanded(
                  child: _moments.isEmpty
                      ? const Center(
                          child: Text('还没有朋友圈，点右上让 TA 发一条',
                              style: TextStyle(color: WeChat.textHint)),
                        )
                      : ListView.separated(
                          itemCount: _moments.length,
                          separatorBuilder: (_, _) => const Divider(
                              height: 0.5, color: WeChat.divider, indent: 70),
                          itemBuilder: (_, i) => _momentTile(_moments[i]),
                        ),
                ),
              ],
            ),
    );
  }

  /// 微信朋友圈顶部封面 + 头像名。
  Widget _cover() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFF4A5A6A)),
          ),
          Positioned(
            right: 16,
            bottom: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.personaName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: const Color(0xFFBFBFBF),
                    child: const Icon(Icons.face, color: Colors.white, size: 36),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _momentTile(MomentView m) {
    final dt = DateTime.fromMillisecondsSinceEpoch(m.postedAt);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 42,
              height: 42,
              color: const Color(0xFFBFBFBF),
              child: const Icon(Icons.face, color: Colors.white, size: 26),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.personaName,
                    style: const TextStyle(
                        color: Color(0xFF576B95),
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(m.content,
                    style: const TextStyle(fontSize: 16, color: WeChat.textPrimary, height: 1.4)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${dt.month}月${dt.day}日 ${_two(dt.hour)}:${_two(dt.minute)}',
                        style: const TextStyle(fontSize: 12, color: WeChat.textHint)),
                    const Spacer(),
                    InkWell(
                      onTap: () => _toggleLike(m),
                      child: Icon(
                        m.likedByUser ? Icons.favorite : Icons.favorite_border,
                        size: 20,
                        color: m.likedByUser ? const Color(0xFFE64340) : WeChat.textHint,
                      ),
                    ),
                  ],
                ),
                if (m.likedByUser) ...[
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    color: const Color(0xFFF7F7F7),
                    child: const Row(
                      children: [
                        Icon(Icons.favorite, size: 14, color: Color(0xFF576B95)),
                        SizedBox(width: 6),
                        Text('你', style: TextStyle(fontSize: 13, color: Color(0xFF576B95))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _two(int n) => n.toString().padLeft(2, '0');
}
