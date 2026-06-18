import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/moment.dart';
import '../chat/chat_bubble.dart' show formatWeChatTime;
import '../chat/wechat_theme.dart';
import '../common/wechat_emoji.dart';

/// 发现页 / 朋友圈（聚合所有数字人的动态，1:1 复刻微信朋友圈）。
///
/// 用户可点赞 → 登记开放回路，对应数字人下次私聊自然提起（SOCIAL-03 高光）。
class DiscoverPage extends ConsumerStatefulWidget {
  const DiscoverPage({super.key});

  @override
  ConsumerState<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends ConsumerState<DiscoverPage> {
  List<MomentView> _moments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final svc = await ref.read(socialServiceProvider.future);
    final list = await svc.listAllMoments();
    if (!mounted) return;
    setState(() {
      _moments = list;
      _loading = false;
    });
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
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _moments.isEmpty
                  ? ListView(children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Text('还没有朋友圈\n数字人会在合适的时候自己发',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: WeChat.textHint)),
                      ),
                    ])
                  : ListView.separated(
                      itemCount: _moments.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 0.5, color: WeChat.divider, indent: 70),
                      itemBuilder: (_, i) => _momentTile(_moments[i]),
                    ),
            ),
    );
  }

  Widget _momentTile(MomentView m) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatar(m.personaAvatarPath),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(m.personaName ?? '数字人',
                    style: const TextStyle(
                        color: Color(0xFF576B95),
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(convertWeChatEmoji(m.content),
                    style: const TextStyle(fontSize: 16, color: WeChat.textPrimary, height: 1.4)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(formatWeChatTime(DateTime.fromMillisecondsSinceEpoch(m.postedAt)),
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
                    child: const Row(children: [
                      Icon(Icons.favorite, size: 14, color: Color(0xFF576B95)),
                      SizedBox(width: 6),
                      Text('你', style: TextStyle(fontSize: 13, color: Color(0xFF576B95))),
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String? path) {
    final ok = path != null && path.isNotEmpty && File(path).existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        width: 42,
        height: 42,
        child: ok
            ? Image.file(File(path), fit: BoxFit.cover)
            : Container(
                color: const Color(0xFFBFBFBF),
                child: const Icon(Icons.face, color: Colors.white, size: 26)),
      ),
    );
  }
}
