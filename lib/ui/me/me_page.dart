import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di/providers.dart';
import '../../domain/models/app_settings.dart';
import '../common/image_store.dart';
import '../chat/wechat_theme.dart';
import '../settings/settings_page.dart';

/// 「我」Tab（微信「我」页）：用户全局头像 / 昵称 + 设置入口。
class MePage extends ConsumerStatefulWidget {
  const MePage({super.key});

  @override
  ConsumerState<MePage> createState() => _MePageState();
}

class _MePageState extends ConsumerState<MePage> {
  AppSettings? _s;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await ref.read(settingsRepoProvider).get();
    if (!mounted) return;
    setState(() => _s = s);
  }

  Future<void> _changeAvatar() async {
    final path = await pickAndSaveImage(subDir: 'avatars', prefix: 'user');
    if (path == null || _s == null) return;
    await ref.read(settingsRepoProvider).update(_s!.copyWith(userAvatarPath: path));
    ref.invalidate(settingsProvider);
    await _load();
  }

  Future<void> _changeName() async {
    final s = _s;
    if (s == null) return;
    final ctrl = TextEditingController(text: s.userName);
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('昵称'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('保存')),
        ],
      ),
    );
    if (name != null && name.isNotEmpty) {
      await ref.read(settingsRepoProvider).update(s.copyWith(userName: name));
      ref.invalidate(settingsProvider);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    return Scaffold(
      backgroundColor: WeChat.bg,
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 40),
                // 个人信息卡。
                Container(
                  color: WeChat.bg,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _changeAvatar,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _avatar(s.userAvatarPath),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _changeName,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.userName,
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              const Text('点击修改头像 / 昵称',
                                  style: TextStyle(fontSize: 13, color: WeChat.textHint)),
                            ],
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: WeChat.textHint),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  color: WeChat.bg,
                  child: ListTile(
                    leading: const Icon(Icons.settings_outlined, color: WeChat.brand),
                    title: const Text('设置'),
                    trailing: const Icon(Icons.chevron_right, color: WeChat.textHint, size: 20),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const SettingsPage()))
                        .then((_) => _load()),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _avatar(String? path) {
    final ok = path != null && path.isNotEmpty && File(path).existsSync();
    return SizedBox(
      width: 64,
      height: 64,
      child: ok
          ? Image.file(File(path), fit: BoxFit.cover)
          : Container(
              color: WeChat.brand,
              child: const Icon(Icons.person, color: Colors.white, size: 40)),
    );
  }
}
