import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../app/di/providers.dart';
import '../../domain/contracts/sticker_repo.dart';
import '../chat/wechat_theme.dart';

/// 表情包管理（说明书 §16）。
///
/// 用户上传图片 + 起语义标签（如“抱抱”），对话时模型据语义输出 [表情:抱抱] 渲染成它。
/// 可用清单每次对话动态注入：新传即时可用、删掉的不再出现。
class StickerManagerPage extends ConsumerStatefulWidget {
  final int personaId;

  const StickerManagerPage({super.key, required this.personaId});

  @override
  ConsumerState<StickerManagerPage> createState() => _StickerManagerPageState();
}

class _StickerManagerPageState extends ConsumerState<StickerManagerPage> {
  List<StickerItem> _stickers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await ref.read(stickerRepoProvider).listStickers(widget.personaId);
    if (!mounted) return;
    setState(() {
      _stickers = list;
      _loading = false;
    });
  }

  Future<void> _addSticker() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    // 复制到 app 文档目录的 stickers/ 下持久化（picker 给的是临时路径）。
    final dir = await getApplicationDocumentsDirectory();
    final stickerDir = Directory(p.join(dir.path, 'stickers'));
    if (!stickerDir.existsSync()) stickerDir.createSync(recursive: true);
    final ext = p.extension(picked.path);
    final dest = p.join(stickerDir.path,
        'st_${DateTime.now().millisecondsSinceEpoch}$ext');
    await File(picked.path).copy(dest);

    if (!mounted) return;
    final label = await _askLabel();
    if (label == null || label.isEmpty) return;

    await ref.read(stickerRepoProvider).addSticker(
          personaId: widget.personaId,
          filePath: dest,
          label: label,
        );
    await _load();
  }

  Future<String?> _askLabel() async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('给这个表情起个名字'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: '如：得意、抱抱、无语',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
          TextButton(
              onPressed: () => Navigator.pop(context, ctrl.text.trim()),
              child: const Text('确定')),
        ],
      ),
    );
  }

  Future<void> _delete(StickerItem s) async {
    await ref.read(stickerRepoProvider).deleteSticker(s.id);
    await _load();
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
        title: const Text('表情包',
            style: TextStyle(fontWeight: FontWeight.w600, color: WeChat.textPrimary, fontSize: 17)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.add), tooltip: '添加', onPressed: _addSticker),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _stickers.isEmpty
              ? _empty()
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _stickers.length,
                  itemBuilder: (_, i) => _tile(_stickers[i]),
                ),
    );
  }

  Widget _empty() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_satisfied_alt,
                size: 56, color: WeChat.textHint),
            const SizedBox(height: 12),
            const Text('还没有表情包', style: TextStyle(color: WeChat.textHint)),
            const SizedBox(height: 4),
            const Text('上传图片并起名，TA 聊天时会按语义选用',
                style: TextStyle(color: WeChat.textHint, fontSize: 12)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _addSticker,
              icon: const Icon(Icons.add),
              label: const Text('添加表情'),
              style: FilledButton.styleFrom(backgroundColor: WeChat.brand),
            ),
          ],
        ),
      );

  Widget _tile(StickerItem s) {
    final exists = File(s.filePath).existsSync();
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: exists
                      ? Image.file(File(s.filePath), fit: BoxFit.cover)
                      : Container(
                          color: const Color(0xFFE0E0E0),
                          child: const Icon(Icons.broken_image, color: WeChat.textHint),
                        ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => _delete(s),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(s.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
