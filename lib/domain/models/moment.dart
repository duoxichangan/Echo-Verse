/// 朋友圈视图模型（说明书 §6.8 / 第十七节，Phase 3）。
///
/// 与 drift moments 行解耦，供朋友圈 UI 与社交服务使用。
class MomentView {
  final int id;
  final int personaId;
  final String content; // 纯文字内容
  final int postedAt; // 毫秒
  final bool likedByUser;
  final String? userComment;

  /// 发布者展示信息（聚合页用；单人页可空）。
  final String? personaName;
  final String? personaAvatarPath;

  const MomentView({
    required this.id,
    required this.personaId,
    required this.content,
    required this.postedAt,
    this.likedByUser = false,
    this.userComment,
    this.personaName,
    this.personaAvatarPath,
  });
}
