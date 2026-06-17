import '../models/open_loop.dart';

/// 开放回路引擎契约（手册 PROACT-02）。
///
/// 登记/对账/闭环/过期。**触发前对账 reconcile 是不穿帮的关键（R2）：**
/// 检查回路是否已被后续对话闭环/提及，是则取消、不发。
abstract class OpenLoopEngine {
  /// 登记新回路：钟点型经 Scheduler 申请并预约通知；事件型转话题触发；周期型派生周期问候。
  Future<void> register(OpenLoop loop);

  /// 触发前对账：返回 true 表示仍应触发；false 表示已闭环/已提及，应取消。
  Future<bool> reconcile(OpenLoop loop);

  /// 闭环：回应沉淀为新事实（回调 MemoryService）+ 更新 L3。
  Future<void> close(OpenLoop loop);

  /// 过期淡出（问一两次即 expired，不连环追问）。
  Future<void> expire(OpenLoop loop);
}
