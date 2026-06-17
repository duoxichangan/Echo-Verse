# 开发进度 · virtual_World

> 本文件记录开发进度与续作指引，随里程碑更新。
> 配套文档（仓库根目录）：`项目说明书.md`（权威行为定义）、`开发手册.md`（工单拆分/接口契约）、`方案_v0.1.md`（决策来由）。
> 最后更新：2026-06-17

---

## 当前状态

**已完成：批次 A / M0「工程地基可运行」** — 提交 `65dda0d`
**进行中：批次 B / MVP 核心** — 已落地 `CHAT-03` 输出后处理

- `flutter analyze`：无问题
- `flutter test`：全 14 项通过（MockAdapter 2 + Settings DB 2 + CHAT-03 10）

---

## 已完成清单（对照开发手册工单）

### 工程与目录
- [x] 定 `virtual/` 为正式工程，补建 Android 平台，删除无用的 web
- [x] git 初始化（main 分支）+ M0 初始提交

### INFRA-01 脚手架
- [x] 分层目录：`domain / data / adapter / platform / app / ui / prompts`
- [x] riverpod 依赖注入（`lib/app/di/providers.dart`）
- [x] 全局错误处理与日志（`lib/app/error_handling.dart`）

### 冻结契约（手册 §2，全在 `lib/domain/contracts/`）
- [x] `ModelAdapter` `PersonaRepo` `MemoryService` `ContextAssembler`
- [x] `OutputPostProcessor` `Scheduler` `OpenLoopEngine` `NotificationPort`
- [x] `StickerRepo` `SecretStore` `SettingsRepo`
- [x] 领域模型（`lib/domain/models/`）：`Persona / OpenLoop / Prompt / RenderedMessage / AppSettings / chat_message(Msg,ChatOpts)`

### DATA-01 数据库
- [x] drift 落地说明书 §6 全部 9 张表 + 索引（facts、messages）+ 迁移框架
- [x] `lib/data/db/database.g.dart` 已生成

### MODEL-01 适配器
- [x] `OpenAIAdapter`（DS/GPT 共用，dio + SSE 流式、超时、重试、错误提取）
- [x] `MockAdapter`（离线开发用，按字符流式吐脚本文本）

### INFRA-02 / 03 密钥与配置
- [x] `SecureSecretStore`（API key 只进加密存储，绝不入库）
- [x] `DriftSettingsRepo`（配置单行落库）

### UI-05 设置页（M0 验收界面）
- [x] 填 provider / key / base_url / model → 点"测试"→ 收到流式回复

### 测试
- [x] `test/mock_adapter_test.dart`
- [x] `test/settings_repo_test.dart`（缺 native sqlite 时自动跳过）
- [x] `test/output_post_processor_test.dart`（CHAT-03，10 项覆盖分条/表情/兜底/延迟）

### CHAT-03 输出后处理（批次 B 首个落地）
- [x] `lib/app/chat/output_post_processor_impl.dart`：按 `‹SEP›` 分条、`[表情:label]`
      解析（命中库才渲染，未命中保留原文）、每条字数延迟 + 首条思考延迟 + 总延迟压缩
- [x] `lib/data/repos/in_memory_sticker_repo.dart`：StickerRepo 内存桩（PERSONA-03 就绪前用）
- [x] DI 注册 `stickerRepoProvider` / `outputPostProcessorProvider`
- [x] 契约 `OutputPostProcessor.process` 增 `personaId`（表情查表需要）

---

## 待办（批次 B / MVP 核心 · M1–M3，尚未开工）

> 多条线可并行，彼此只靠已冻结的契约 / Mock 耦合。

- **对话线**：~~`CHAT-03` 输出后处理~~ ✅ → `CHAT-01` 上下文组装 → `CHAT-02` 对话生成
- **人格线**：`PERSONA-01` 微信 txt 解析 → `PERSONA-02` 人格提炼 → `PERSONA-03` 画像存储
- **记忆线**：`MEM-01` 读取 / `MEM-03` 衰减检索 → `MEM-02` 写入提炼
- **界面线**：`UI-01` 聊天页 / `UI-02` 建号向导（可用 mock 数据先做视觉）

**推荐起步点**：`CHAT-03`（纯函数、不依赖 LLM、单测友好）+ `PERSONA-01`（靠 MockAdapter 可离线验证）。

之后是批次 C（M4，MVP 收尾）、批次 D（主动性）、批次 E（社交）、批次 F（扩展）。详见 `开发手册.md` §4。

---

## 工具链注意事项（坑与解法）

1. **master 渠道 build_runner 无法编译 native build hook**
   现象：`dart run build_runner build` 报 `'dart compile' does not support build hooks`。
   解法：`pubspec.yaml` 已把 `drift`/`drift_dev` 锁在 `>=2.20.0 <2.23.0`，并 `dependency_overrides` 固定 `sqlite3: 2.8.0`、`objective_c: 9.1.0`。将来切到 stable 渠道可移除这些 pin。

2. **flutter_local_notifications 需要 core library desugaring**
   已在 `android/app/build.gradle.kts` 启用 `isCoreLibraryDesugaringEnabled` + `desugar_jdk_libs`。

---

## 续作指引

新开会话后，核对状态的最快方式：

```bash
cd virtual
git log --oneline      # 应看到 M0 提交
flutter analyze        # 应无问题
flutter test           # MockAdapter 通过，DB 测试跳过
```

确认无误后，从「待办」的推荐起步点继续即可。
