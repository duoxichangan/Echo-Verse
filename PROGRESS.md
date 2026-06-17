# 开发进度 · virtual_World

> 本文件记录开发进度与续作指引，随里程碑更新。
> 配套文档（仓库根目录）：`项目说明书.md`（权威行为定义）、`开发手册.md`（工单拆分/接口契约）、`方案_v0.1.md`（决策来由）。
> 最后更新：2026-06-17

---

## 当前状态

**已完成：批次 A / M0「工程地基可运行」** — 提交 `65dda0d`
**进行中：批次 B / MVP 核心** — 对话闭环 + UI-01 微信聊天页（1:1 复刻）

- `flutter analyze`：无问题
- `flutter test`：全 34 项通过（对话/记忆逻辑 + 气泡 widget）
- `flutter build apk --debug`：✅ 通过（已配国内镜像解决依赖超时，见工具链坑 #3/#4）

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

### MEM-01/03 记忆读取与衰减检索（记忆线，「像真人」核心）
- [x] `lib/app/memory/salience.dart`：显著度纯函数 `importance × exp(-Δt/τ)`（艾宾浩斯式
      指数衰减，τ 默认 14 天半衰期，pinned 跳过）。无时钟依赖，可独立单测
- [x] `lib/app/memory/drift_memory_service.dart`：
      - `readResident`：拼装 L1 摘要 + L3 关系 + 高显著 L2 事实，按字符近似预算从低到高裁剪
      - `topFacts`：过滤 invalid / superseded，pinned 置顶，按显著度降序，截断到上限
      - `search`：L5 关键词检索（中英分词 + `contains`，按命中词数→新近排序去重，无 embedding）
      - `extract`（MEM-02）：依赖 ModelAdapter + OpenLoopEngine，留待后续工单，暂抛 UnimplementedError
- [x] DI 注册 `memoryServiceProvider`
- [x] 决策：遗忘曲线选**指数衰减**、检索选**关键词+时间**（用户确认，记忆求「像真人」）

### 对话闭环 CHAT-01/02/03（「发一句→分条回复」跑通）
- [x] `lib/data/repos/drift_persona_repo.dart`：PERSONA-03 存储部分，personas CRUD +
      `restoreInitial`（R6）+ `create`（建号用）
- [x] `lib/prompts/chat_prompts.dart`：§8.2 对话 system 模板（L2 语气 / `‹SEP›` 分条 /
      `[表情:label]` 限清单 / `[记住:x]` / 绝不承认 AI），变量具名注入
- [x] `lib/app/chat/context_assembler_impl.dart`（CHAT-01）：组装 system（画像 + 常驻记忆 +
      表情清单）与 messages（最近 N 条原文），记忆块预算交 `readResident` 内部裁剪
- [x] `lib/domain/contracts/chat_engine.dart` + `lib/app/chat/chat_engine_impl.dart`（CHAT-02）：
      落库 user → 取最近原文 → assemble → ModelAdapter.chat → CHAT-03 process →
      按 delayMs 逐条 yield 并落库 persona 连发消息；`honorDelays` 开关便于测试
- [x] DI 注册 `personaRepoProvider` / `contextAssemblerProvider` / `chatEngineProvider`
- [x] 5 项闭环单测（分条流 / 表情渲染 / 双方落库 / 多轮历史串联 / 不阻塞），全程 MockAdapter 离线

### UI-01 聊天页（1:1 复刻微信，说明书 §15）
- [x] `lib/ui/chat/wechat_theme.dart`：微信配色/尺寸常量（背景 #EDEDED、自己气泡 #95EC69、
      输入栏 #F7F7F7、主绿 #07C160 等）
- [x] `lib/ui/chat/chat_bubble.dart`：左白右绿气泡 + CustomPaint 侧边尖角 + 方角头像，
      文本/表情两类，表情坏路径兜底占位
- [x] `lib/ui/chat/chat_page.dart`：微信顶栏（返回 + 居中标题 + 标题下「对方正在输入…」+「…」进设置）、
      消息列表（历史加载 + 流式追加 + 自动滚底）、底部输入栏（语音/输入框/表情/有字变绿「发送」）。
      接 `chatEngineProvider`，发送→流式收 RenderedMessage→逐条蹦气泡
- [x] `lib/ui/home/home_page.dart`：微信式会话列表；空态给「创建示例数字人『小桃』」入口
      （建号未做前的开发引导，播种画像 + 2 条事实 + 关系状态，让记忆感立即可体验）
- [x] `main.dart` 入口改为 `HomePage`
- [x] 3 项气泡 widget 单测（HomePage/ChatPage 的真异步 drift 查询不适合 fake-async widget 测试，
      留真机/集成验证；对话逻辑已由 chat_engine_test 覆盖）
- [x] 国内镜像配置 + 清理陈旧 Gradle 缓存 → `flutter build apk --debug` 通过（见工具链坑 #3/#4）

---

## 待办（批次 B / MVP 核心 · M1–M3，尚未开工）

> 多条线可并行，彼此只靠已冻结的契约 / Mock 耦合。

- **对话线**：~~`CHAT-03`~~ ✅ ~~`CHAT-01` 上下文组装~~ ✅ ~~`CHAT-02` 对话生成~~ ✅ → 接真 key 端到端验证
- **人格线**：`PERSONA-01` 微信 txt 解析 → `PERSONA-02` 人格提炼 → ~~`PERSONA-03` 画像存储~~ ✅（编辑器 UI 待 M4）
- **记忆线**：~~`MEM-01` 读取 / `MEM-03` 衰减检索~~ ✅ → `MEM-02` 写入提炼（依赖 ModelAdapter + OpenLoopEngine）
- **界面线**：~~`UI-01` 聊天页~~ ✅（含会话列表雏形）→ `UI-02` 建号向导（替换示例 persona 入口）

**当前断点**：能在微信式界面里打字、收到分条回复、看历史；但**还不会自动写记忆**（每轮聊完不沉淀事实），
且**示例 persona 是开发占位**（真正建号 PERSONA-01/02 未做）。
下一步二选一：① `MEM-02` 记忆写入（聊着聊着自动记住事，闭合「记忆像真人」）；
② `PERSONA-01/02` 建号（导入真实聊天记录提炼人格，替换示例「小桃」）。

**推荐起步点**：`CHAT-03`（纯函数、不依赖 LLM、单测友好）+ `PERSONA-01`（靠 MockAdapter 可离线验证）。

之后是批次 C（M4，MVP 收尾）、批次 D（主动性）、批次 E（社交）、批次 F（扩展）。详见 `开发手册.md` §4。

---

## 工具链注意事项（坑与解法）

1. **master 渠道 build_runner 无法编译 native build hook**
   现象：`dart run build_runner build` 报 `'dart compile' does not support build hooks`。
   解法：`pubspec.yaml` 已把 `drift`/`drift_dev` 锁在 `>=2.20.0 <2.23.0`，并 `dependency_overrides` 固定 `sqlite3: 2.8.0`、`objective_c: 9.1.0`。将来切到 stable 渠道可移除这些 pin。

2. **flutter_local_notifications 需要 core library desugaring**
   已在 `android/app/build.gradle.kts` 启用 `isCoreLibraryDesugaringEnabled` + `desugar_jdk_libs`。

3. **`flutter build apk` 依赖网络拉 Google maven / Android SDK（已解决）**
   现象（2026-06-17）：`Connection timed out` —— 拉不到 AGP `8.11.1`、Gradle distribution、SDK Platform 35。
   解法（已落地，构建通过）：切国内镜像 ——
   - `android/settings.gradle.kts` 的 `pluginManagement.repositories`、`android/build.gradle.kts` 的
     `allprojects.repositories`：在 `google()` 前加阿里云 `maven.aliyun.com/repository/{google,public,gradle-plugin}`；
   - `android/gradle/wrapper/gradle-wrapper.properties` 的 `distributionUrl` 换腾讯云
     `mirrors.cloud.tencent.com/gradle/gradle-8.14-all.zip`；
   - Flutter 侧 `PUB_HOSTED_URL` / `FLUTTER_STORAGE_BASE_URL` 已是国内镜像（日志显示用 storage.flutter-io.cn）。

4. **Gradle 缓存残留他机绝对路径致构建失败（已解决）**
   现象：`Failed to create parent directory 'C:\Users\duoxichangan\...'` —— `android/.gradle` 执行历史里
   残留了另一用户路径（项目曾在 `C:\Users\duoxichangan\Desktop` 下构建过）。
   解法：`rm -rf android/.gradle build android/app/build` + `flutter clean` 后重建。这些目录均已被 .gitignore，
   清理无副作用。换机/换路径后若构建报陌生绝对路径，先清这些缓存。

> ✅ `flutter build apk --debug` 已通过，产物 `build/app/outputs/flutter-apk/app-debug.apk`（约 154MB，debug 正常）。

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
