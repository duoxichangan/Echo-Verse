import 'package:flutter/material.dart';

/// 微信视觉常量（说明书 §15：1:1 复刻微信，不另做 UI 设计）。
///
/// 取自微信经典聊天界面的配色与尺寸，集中放置便于全局统一。
class WeChat {
  WeChat._();

  // ── 配色 ──────────────────────────────────────────────
  /// 聊天页背景（经典浅灰）。
  static const bg = Color(0xFFEDEDED);

  /// 顶栏 / 输入栏底色。
  static const barBg = Color(0xFFEDEDED);

  /// 对方气泡（白）。
  static const bubbleIn = Color(0xFFFFFFFF);

  /// 自己气泡（微信绿）。
  static const bubbleOut = Color(0xFF95EC69);

  /// 输入框白底。
  static const inputFieldBg = Color(0xFFFFFFFF);

  /// 主文字色（近黑）。
  static const textPrimary = Color(0xFF191919);

  /// 次要文字 / 时间戳灰。
  static const textHint = Color(0xFFB2B2B2);

  /// 分隔线。
  static const divider = Color(0xFFD9D9D9);

  /// 微信主绿（发送按钮等）。
  static const brand = Color(0xFF07C160);

  // ── 尺寸 ──────────────────────────────────────────────
  static const avatarSize = 40.0;
  static const bubbleRadius = 5.0;
  static const tailSize = 6.0; // 气泡小尖角
  static const msgFontSize = 17.0;
  static const hGap = 10.0; // 头像与气泡间距
}
