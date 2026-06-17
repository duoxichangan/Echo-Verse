import '../models/moment.dart';

/// 社交服务契约（手册 SOCIAL-01/02/03，Phase 3）。
///
/// 收口三个伏笔：对外人格推演、朋友圈发布、点赞感知跨场景提起。
abstract class SocialService {
  /// SOCIAL-01：推演并存储对外人格（基于 L0–L5 画像）。
  Future<void> buildOutwardPersona(int personaId);

  /// SOCIAL-02：尝试发一条朋友圈（受活动调度中枢约束）。
  /// 返回新朋友圈；被作息/配额拒绝时返回 null。
  Future<MomentView?> maybePublish(int personaId);

  /// 列出某人格的朋友圈（最新在前）。
  Future<List<MomentView>> listMoments(int personaId);

  /// 聚合所有数字人的朋友圈（发现页用，含发布者名/头像，最新在前）。
  Future<List<MomentView>> listAllMoments();

  /// SOCIAL-03：用户给某条朋友圈点赞/取消。点赞会登记一个"等待互动"开放回路，
  /// 数字人下次私聊自然提起（产品高光）。
  Future<void> setLiked(int momentId, bool liked);
}
