import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../adapter/mock_adapter.dart';
import '../../adapter/openai_adapter.dart';
import '../../data/db/database.dart';
import '../../data/repos/drift_settings_repo.dart';
import '../../data/repos/in_memory_sticker_repo.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/output_post_processor.dart';
import '../../domain/contracts/secret_store.dart';
import '../../domain/contracts/settings_repo.dart';
import '../../domain/contracts/sticker_repo.dart';
import '../../domain/models/app_settings.dart';
import '../../platform/secure_secret_store.dart';
import '../chat/output_post_processor_impl.dart';
import '../memory/drift_memory_service.dart';

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

/// 表情库仓储（契约类型）。
///
/// 暂用内存实现（[InMemoryStickerRepo]），PERSONA-03 / drift 表情仓储就绪后
/// 在此替换为持久化实现即可，消费方（CHAT-01/03）只认 [StickerRepo] 契约。
final stickerRepoProvider = Provider<StickerRepo>(
  (ref) => InMemoryStickerRepo(),
);

/// 输出后处理（手册 CHAT-03）。纯逻辑，仅依赖 [StickerRepo]。
final outputPostProcessorProvider = Provider<OutputPostProcessor>(
  (ref) => OutputPostProcessorImpl(ref.watch(stickerRepoProvider)),
);

/// 记忆服务（手册 MEM-01 读取 / MEM-03 检索；MEM-02 写入待后续工单）。
final memoryServiceProvider = Provider<MemoryService>(
  (ref) => DriftMemoryService(ref.watch(databaseProvider)),
);
