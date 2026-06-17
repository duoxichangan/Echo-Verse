import '../../domain/contracts/context_assembler.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/persona_repo.dart';
import '../../domain/contracts/sticker_repo.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/prompt.dart';
import '../../prompts/chat_prompts.dart';

/// 上下文组装实现（手册 CHAT-01 / 说明书 §7.1）。
///
/// 把人格画像 + 常驻记忆 + 表情清单组装成 system 提示，
/// 把最近 N 条原文 + 当前用户消息组装成 messages，产出 [Prompt] 喂给模型。
///
/// 预算分配（§7.1，从高到低，预算不足砍低优先级）：
///  - system 内：人格画像 > 关系 > 高显著事实 > 表情清单 > 会话摘要
///    （记忆部分的内部裁剪交给 [MemoryService.readResident]，按 [memoryBudgetTokens]）；
///  - messages：最近 N 条原文（受 [maxRecentMsgs] 限制）。
class ContextAssemblerImpl implements ContextAssembler {
  final PersonaRepo personaRepo;
  final MemoryService memoryService;
  final StickerRepo stickerRepo;

  /// 带入 messages 的最近原文最大条数（L0 工作记忆）。
  final int maxRecentMsgs;

  /// 分给常驻记忆块的 token 预算占总预算的比例（其余留给画像与原文）。
  final double memoryBudgetRatio;

  /// 取当前时间（注入便于测试）；用于给 prompt 注入时段感。
  final DateTime Function() now;

  ContextAssemblerImpl({
    required this.personaRepo,
    required this.memoryService,
    required this.stickerRepo,
    this.maxRecentMsgs = 20,
    this.memoryBudgetRatio = 0.4,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  @override
  Future<Prompt> assemble(
    int personaId,
    List<Msg> recentMsgs,
    int budgetTokens,
  ) async {
    final persona = await personaRepo.getPersona(personaId);

    // 常驻记忆（readResident 已按预算内部裁剪摘要/关系/高显著事实）。
    final memBudget = (budgetTokens * memoryBudgetRatio).round();
    final memoryBlock = await memoryService.readResident(personaId, memBudget);

    // 当前可用表情清单（动态注入，方案 §16）。
    final labels = await stickerRepo.listLabels(personaId);

    final system = ChatPrompts.system(
      personaName: persona?.name ?? '对方',
      personaProfile: persona?.personaJson ?? '（暂无画像，按一个普通熟人的口吻自然聊天）',
      userAlias: persona?.userAlias,
      memoryBlock: memoryBlock,
      stickerLabels: labels,
      now: now(),
    );

    // messages：只保留最近 maxRecentMsgs 条（更早的已被摘要覆盖）。
    final trimmed = recentMsgs.length > maxRecentMsgs
        ? recentMsgs.sublist(recentMsgs.length - maxRecentMsgs)
        : recentMsgs;

    return Prompt(system: system, messages: List.unmodifiable(trimmed));
  }
}
