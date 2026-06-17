import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../adapter/mock_adapter.dart';
import '../../adapter/openai_adapter.dart';
import '../../data/db/database.dart';
import '../../data/repos/drift_persona_repo.dart';
import '../../data/repos/drift_settings_repo.dart';
import '../../data/repos/drift_sticker_repo.dart';
import '../../domain/contracts/chat_engine.dart';
import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/context_assembler.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/notification_port.dart';
import '../../domain/contracts/open_loop_engine.dart';
import '../../domain/contracts/output_post_processor.dart';
import '../../domain/contracts/persona_builder.dart';
import '../../domain/contracts/persona_repo.dart';
import '../../domain/contracts/scheduler.dart';
import '../../domain/contracts/secret_store.dart';
import '../../domain/contracts/settings_repo.dart';
import '../../domain/contracts/sticker_repo.dart';
import '../../domain/models/app_settings.dart';
import '../../platform/secure_secret_store.dart';
import '../chat/chat_engine_impl.dart';
import '../chat/context_assembler_impl.dart';
import '../chat/output_post_processor_impl.dart';
import '../memory/drift_memory_service.dart';
import '../ops/backup_service.dart';
import '../persona/llm_chat_log_parser.dart';
import '../persona/llm_persona_builder.dart';
import '../proact/active_hours.dart';
import '../proact/default_open_loop_engine.dart';
import '../proact/default_scheduler.dart';
import '../proact/local_notification_port.dart';

/// 全局依赖注入总线（手册 INFRA-01）。
/// 所有单例 / 工厂在此注册，UI 与应用层只通过契约类型消费。

/// 数据库单例。
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// 密钥存储（契约类型）。
final secretStoreProvider = Provider<SecretStore>((ref) => SecureSecretStore());

/// 配置仓储（契约类型）。
final settingsRepoProvider = Provider<SettingsRepo>(
  (ref) => DriftSettingsRepo(ref.watch(databaseProvider)),
);

/// 当前配置（异步加载）。
final settingsProvider = FutureProvider<AppSettings>(
  (ref) => ref.watch(settingsRepoProvider).get(),
);

/// 是否启用 Mock 适配器（离线开发开关）。
/// 默认 false；联调或无网时可在此 override 为 true。
final useMockAdapterProvider = Provider<bool>((ref) => false);

/// 模型适配器工厂（契约类型）。
///
/// 依据当前配置 + SecretStore 中的 key 构造真实适配器；
/// 无 key 或开启 mock 开关时回退到 MockAdapter，保证离线可跑。
final modelAdapterProvider = FutureProvider<ModelAdapter>((ref) async {
  if (ref.watch(useMockAdapterProvider)) return const MockAdapter();

  final settings = await ref.watch(settingsProvider.future);
  final key = await ref.watch(secretStoreProvider).read(SecretKeys.apiKey);
  if (key == null || key.isEmpty) return const MockAdapter();

  return OpenAIAdapter(
    baseUrl: settings.baseUrl,
    apiKey: key,
    model: settings.model,
  );
});

/// 表情库仓储（手册 StickerRepo / 说明书 §16）。drift 落库，可上传/命名/删除。
final stickerRepoProvider = Provider<StickerRepo>(
  (ref) => DriftStickerRepo(ref.watch(databaseProvider)),
);

/// 输出后处理（手册 CHAT-03）。纯逻辑，仅依赖 [StickerRepo]。
final outputPostProcessorProvider = Provider<OutputPostProcessor>(
  (ref) => OutputPostProcessorImpl(ref.watch(stickerRepoProvider)),
);

/// 记忆服务（手册 MEM-01 读取 / MEM-02 写入 / MEM-03 检索）。
///
/// 读取/检索不需要模型；写入提炼（extract）需要 adapter——用 valueOrNull 拿当前已
/// 解析的适配器（未就绪则为 null，extract 退化为只处理 [记住:x] 内联标记，不阻塞读取）。
final memoryServiceProvider = Provider<MemoryService>(
  (ref) => DriftMemoryService(
    ref.watch(databaseProvider),
    adapter: ref.watch(modelAdapterProvider).valueOrNull,
  ),
);

/// 画像仓储（手册 PERSONA-03 存储部分）。
final personaRepoProvider = Provider<PersonaRepo>(
  (ref) => DriftPersonaRepo(ref.watch(databaseProvider)),
);

/// 上下文组装（手册 CHAT-01）。组合画像 + 记忆 + 表情清单。
final contextAssemblerProvider = Provider<ContextAssembler>(
  (ref) => ContextAssemblerImpl(
    personaRepo: ref.watch(personaRepoProvider),
    memoryService: ref.watch(memoryServiceProvider),
    stickerRepo: ref.watch(stickerRepoProvider),
  ),
);

/// 对话引擎（手册 CHAT-02）。依赖 modelAdapter，故为异步 provider。
final chatEngineProvider = FutureProvider<ChatEngine>((ref) async {
  final adapter = await ref.watch(modelAdapterProvider.future);
  return ChatEngineImpl(
    db: ref.watch(databaseProvider),
    assembler: ref.watch(contextAssemblerProvider),
    adapter: adapter,
    postProcessor: ref.watch(outputPostProcessorProvider),
    memoryService: ref.watch(memoryServiceProvider), // 每 M 轮提炼（MEM-02）
  );
});

/// 微信 txt 解析（手册 PERSONA-01）。依赖 modelAdapter。
final chatLogParserProvider = FutureProvider<ChatLogParser>((ref) async {
  final adapter = await ref.watch(modelAdapterProvider.future);
  return LlmChatLogParser(adapter);
});

/// 人格提炼（手册 PERSONA-02）。依赖 modelAdapter。
final personaBuilderProvider = FutureProvider<PersonaBuilder>((ref) async {
  final adapter = await ref.watch(modelAdapterProvider.future);
  return LlmPersonaBuilder(adapter);
});

/// 本地导出/导入（手册 OPS-01 / R8）。
final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(databaseProvider)),
);

// ── 批次 D 主动性 ─────────────────────────────────────────

/// 活动调度中枢（手册 PROACT-01，R1）。作息+配额来自当前配置。
final schedulerProvider = Provider<Scheduler>((ref) {
  final s = ref.watch(settingsProvider).valueOrNull;
  return DefaultScheduler(
    activeHours: ActiveHours.fromJson(s?.activeHoursJson ?? '{}'),
    dailyQuota: s?.dailyProactiveQuota ?? 5,
  );
});

/// 本地通知端口（手册 PROACT-03）。点击回调由 main 注入（这里默认空）。
final notificationPortProvider = Provider<NotificationPort>(
  (ref) => LocalNotificationPort(),
);

/// 开放回路引擎（手册 PROACT-02）。
final openLoopEngineProvider = Provider<OpenLoopEngine>(
  (ref) => DefaultOpenLoopEngine(
    db: ref.watch(databaseProvider),
    scheduler: ref.watch(schedulerProvider),
    notifications: ref.watch(notificationPortProvider),
  ),
);
