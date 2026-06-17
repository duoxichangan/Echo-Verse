# 开发进度 · virtual_World

> 本文件记录开发进度与续作指引，随里程碑更新。
> 配套文档（仓库根目录）：`项目说明书.md`（权威行为定义）、`开发手册.md`（工单拆分/接口契约）、`方案_v0.1.md`（决策来由）。
> 最后更新：2026-06-17

---

## 当前状态

**已完成：批次 A / M0** — 提交 `65dda0d`
**已完成：批次 B+C / MVP** — 建号(填设定/txt导入) + 微信聊天 + 五层记忆(读/写/衰减/面板) + 画像编辑器 + 表情系统 + 导出导入
**进行中：批次 D / 主动性**

- `flutter analyze`：无问题
- `flutter test`：全 63 项通过
- `flutter build apk --debug`：✅ 通过（已配国内镜像，见工具链坑 #3/#4）

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

### PERSONA-01/02 建号（解析 + 提炼 + 直接创建，逻辑全做 / UI 先做创建路径）
- [x] `lib/domain/models/persona_profile.dart`：L0–L5 结构化画像模型（§8.1 骨架），
      宽容 JSON 编解码（缺字段给默认、坏输入回退空骨架）、`empty()` 预置 L0 铁律
- [x] `lib/prompts/persona_prompts.dart`：§7.4 解析 prompt + §8.1 提炼 prompt（只输出 JSON 约束）
- [x] `lib/app/persona/json_extract.dart`：从 LLM 文本稳健抠 JSON（剥 ```代码块 / 取 {..} / 兜底）
- [x] `lib/app/persona/llm_chat_log_parser.dart`（PERSONA-01）：全交 LLM 解析（§7.4）→ ParsedLog，
      最近 N 行采样上限 + sampled 标记，非 JSON 兜底整段一条
- [x] `lib/app/persona/llm_persona_builder.dart`（PERSONA-02）：`build` 调 LLM 提炼画像
      （L0 兜底补“不承认 AI”、用户硬设定覆盖模型猜测的 L1）；`buildFromHints` 不调 LLM
      按设定本地造默认画像（“不导入也能建”路径）
- [x] `lib/ui/persona/create_persona_page.dart`：建号向导（填昵称/关系/称呼/性格词 → 创建），
      含 txt 导入入口占位（解析逻辑已就绪，UI 下轮接）
- [x] HomePage 接入：右上「+」与空态「创建数字人」进创建页；示例「小桃」降为快捷体验
- [x] `PersonaRepo` 契约加 `create`；DI 注册 `chatLogParserProvider` / `personaBuilderProvider`
- [x] 16 项单测（json 抽取 / 画像编解码往返 / 解析器结构+采样+兜底 / 提炼 build+buildFromHints+L0兜底+硬设定覆盖）

### MEM-02 记忆写入 / 提炼（「记忆像真人」收口——会自己长记忆）
- [x] `lib/domain/models/memory_extraction.dart`：提炼输出模型（summary_update / new_facts /
      superseded / relationship_update / new_open_loops），宽容解析、空内容/坏 id 过滤、ISO→ms
- [x] `lib/prompts/memory_prompts.dart`：§8.3 提炼 prompt（喂带 id 的已知事实以识别矛盾，只输出 JSON）
- [x] `DriftMemoryService.extract`：识别 `[记住:x]` 内联标记直接入库（高重要性，无需 LLM）；
      调 LLM 提炼 → 写 L2 新事实、**矛盾覆盖**（旧事实 valid=false + superseded_by）、
      更新 L1 摘要（覆盖式）、更新 L3 关系（closeness 增量 clamp）、
      开放回路落 `open_loops`(pending，本轮不调度——PROACT-02 后续接)
- [x] `DriftMemoryService` 加可选 `ModelAdapter`；adapter=null 时退化为只处理内联标记
- [x] ChatEngine 每累计 `extractEvery`(默认 6) 条新消息后台静默触发提炼（不阻塞回复、失败不影响对话）
- [x] DI：`memoryServiceProvider` 用 `modelAdapterProvider.valueOrNull` 拿 adapter；chatEngine 注入 memoryService
- [x] 决策：开放回路**先落库不调度**、提炼**每 M 轮自动**（用户确认）
- [x] 9 项单测（提炼模型解析 / 内联标记 / 新事实 / 矛盾覆盖 / L3 更新 / 回路落库 pending / 非 JSON 兜底）

---

## 待办（批次 B / MVP 核心 · M1–M3，尚未开工）

> 多条线可并行，彼此只靠已冻结的契约 / Mock 耦合。

- **对话线**：~~`CHAT-03`~~ ✅ ~~`CHAT-01`~~ ✅ ~~`CHAT-02`~~ ✅ → 接真 key 端到端验证
- **人格线**：~~`PERSONA-01` txt 解析~~ ✅ ~~`PERSONA-02` 人格提炼（含直接创建）~~ ✅ → `PERSONA-03` 编辑器 UI（UI-03，M4）
- **记忆线**：~~`MEM-01` 读取 / `MEM-03` 衰减检索~~ ✅ ~~`MEM-02` 写入提炼~~ ✅ → `MEM-04` 记忆面板（M4）
- **界面线**：~~`UI-01` 聊天页~~ ✅ ~~`UI-02` 建号向导（创建路径）~~ ✅ → txt 导入向导 UI / `UI-03` 画像编辑器 / `UI-04` 记忆面板

**当前断点**：MVP 核心闭环已基本贯通——建号（填设定/逻辑上可导入）→ 微信界面聊天 → 读历史记忆 →
**聊着聊着自动长记忆**（事实/关系/开放回路）。仍缺：txt 导入只有逻辑没接 UI；
画像/记忆只能看不能逐层改（UI-03/04，M4）；开放回路只落库未主动推送（PROACT，批次 D）。
下一步候选：① 接真 key 端到端验证「像不像本人」（MVP 灵魂验收）；② txt 导入向导 UI；③ M4 收尾（编辑器/记忆面板/导出）。

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
