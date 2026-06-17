import 'dart:io';

import 'package:flutter/material.dart';

import 'wechat_theme.dart';

/// 聊天页用的 UI 消息模型（与落库的 message 行解耦，只装渲染需要的）。
class ChatBubbleData {
  /// true=自己（右侧绿气泡），false=对方（左侧白气泡）。
  final bool isSelf;

  /// 文本内容；表情消息为 null。
  final String? text;

  /// 表情图片路径；文本消息为 null。
  final String? stickerPath;

  const ChatBubbleData.text(this.text, {required this.isSelf})
      : stickerPath = null;

  const ChatBubbleData.sticker(this.stickerPath, {required this.isSelf})
      : text = null;

  bool get isSticker => stickerPath != null;
}

/// 一行聊天气泡（1:1 复刻微信：头像 + 带尖角的气泡）。
class ChatBubble extends StatelessWidget {
  final ChatBubbleData data;

  /// 对方头像路径（自己暂用占位）。
  final String? peerAvatarPath;

  const ChatBubble({super.key, required this.data, this.peerAvatarPath});

  @override
  Widget build(BuildContext context) {
    final self = data.isSelf;
    final avatar = _avatar(self);
    final bubble = data.isSticker ? _sticker() : _textBubble(self);

    // 气泡最大宽度约屏宽的 65%（微信观感）。
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.65;

    final row = Row(
      mainAxisAlignment:
          self ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!self) ...[avatar, const SizedBox(width: WeChat.hGap)],
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            child: bubble,
          ),
        ),
        if (self) ...[const SizedBox(width: WeChat.hGap), avatar],
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: row,
    );
  }

  Widget _avatar(bool self) {
    final hasImg = !self && peerAvatarPath != null && peerAvatarPath!.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4), // 微信头像方形小圆角
      child: SizedBox(
        width: WeChat.avatarSize,
        height: WeChat.avatarSize,
        child: hasImg
            ? Image.file(File(peerAvatarPath!), fit: BoxFit.cover)
            : Container(
                color: self ? WeChat.brand : const Color(0xFFBFBFBF),
                child: Icon(
                  self ? Icons.person : Icons.face,
                  color: Colors.white,
                  size: 24,
                ),
              ),
      ),
    );
  }

  Widget _textBubble(bool self) {
    final color = self ? WeChat.bubbleOut : WeChat.bubbleIn;
    return CustomPaint(
      painter: _BubbleTailPainter(color: color, isSelf: self),
      child: Container(
        margin: EdgeInsets.only(
          left: self ? 0 : WeChat.tailSize,
          right: self ? WeChat.tailSize : 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(WeChat.bubbleRadius),
        ),
        child: Text(
          data.text ?? '',
          style: const TextStyle(
            fontSize: WeChat.msgFontSize,
            color: WeChat.textPrimary,
            height: 1.3,
          ),
        ),
      ),
    );
  }

  Widget _sticker() {
    final path = data.stickerPath!;
    final img = File(path).existsSync()
        ? Image.file(File(path), width: 110, height: 110, fit: BoxFit.contain)
        : Container(
            width: 110,
            height: 110,
            color: const Color(0xFFE0E0E0),
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, color: WeChat.textHint),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: img,
    );
  }
}

/// 画气泡侧边的小尖角（微信气泡贴着头像那侧有个三角）。
class _BubbleTailPainter extends CustomPainter {
  final Color color;
  final bool isSelf;

  _BubbleTailPainter({required this.color, required this.isSelf});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const t = WeChat.tailSize;
    const topOffset = 14.0; // 尖角离顶端的距离
    final path = Path();
    if (isSelf) {
      // 右侧尖角，指向右。
      path.moveTo(size.width - t, topOffset);
      path.lineTo(size.width, topOffset + t / 2);
      path.lineTo(size.width - t, topOffset + t);
    } else {
      // 左侧尖角，指向左。
      path.moveTo(t, topOffset);
      path.lineTo(0, topOffset + t / 2);
      path.lineTo(t, topOffset + t);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BubbleTailPainter old) =>
      old.color != color || old.isSelf != isSelf;
}
