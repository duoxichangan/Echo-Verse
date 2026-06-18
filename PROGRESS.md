# 开发进度 · virtual_World

> 本文件记录开发进度与续作指引，随里程碑更新。
> 配套文档（仓库根目录）：`项目说明书.md`（权威行为定义）、`开发手册.md`（工单拆分/接口契约）、`方案_v0.1.md`（决策来由）。
> 最后更新：2026-06-18

---

## 当前状态

**已完成：批次 A / M0** — 提交 `65dda0d`
**已完成：批次 B+C / MVP** — 建号(填设定/txt导入) + 微信聊天 + 五层记忆(读/写/衰减/面板) + 画像编辑器 + 表情系统 + 导出导入
**已完成：批次 D / 主动性** — 活动调度中枢 + 开放回路引擎 + 本地通知 + 启动补发对账
**已完成：批次 E / 社交** — 对外人格推演 + 纯文字朋友圈 + 点赞感知跨场景提起 + 朋友圈页

> 🎉 四个 Phase（MVP / 主动性 / 社交）全部落地。Phase 4 扩展（多人/群聊/iOS/云备份/Claude适配器/embedding）按需。

> 修复（提交 `861f88a`）：txt 解析改「本地优先 + LLM 兜底 + 多轮凝练」——规整导出格式
> （`时间 '说话人'` 头）本地正则全量切分（实测 17220 行→5735 条全部识别），超长记录提炼走
> map-reduce 分批读完全部。此前「全交 LLM 逐条重输出」会因输出截断只识别出 1 条。

> 修复（本轮，2026-06-18）：三项体验问题 ——
> ① **微信内置表情显示**：数字人从聊天记录学到 `[捂脸]` `[爱心]` `[旺柴]` 这类微信自带表情名，
>    原来当普通文字显示成穿帮原文。新增 `lib/ui/common/wechat_emoji.dart`（名→emoji 映射 +
>    `convertWeChatEmoji`），在聊天气泡 / 朋友圈**展示时**还原成 emoji；未知占位符原样保留、
>    落库仍存原文供记忆提炼。表情包（`[表情:label]`）查库逻辑不变，两者不冲突。
> ② **主界面头像**：`home_page.dart` 会话列表原来硬编码 `Icons.face`，没读 `persona.avatarPath`；
>    改为有图显示头像、无图回退占位（与聊天页一致）。
> ③ **记忆状态更新 + 时间感知**：提炼 prompt 增「识别状态变化并覆盖旧事实」规则——
>    “在准备/在学/在等”的事一旦说**做完/结束/放弃**就 superseded 旧事实并写新状态，
>    不再把已完成的事当“正在进行”留着，也不再为其登记 open_loop；对话 prompt 强化时间感——
>    对方说的话与当前时间对不上（如下午发“早安”）会自然点出、调侃，而非平淡回应。
>    新增 `wechat_emoji_test`（5 项）。

> 新功能（本轮，2026-06-18）：**数字人主动找你**（预生成 + 定时通知）——
> ① 每个数字人在资料页可设「主动找我」档位（关闭/偶尔约每天1次/正常每天2-3次/频繁每天4-5次，
>    `ProactiveTier`，落库 `personas.proactiveTier`）。
> ② **预生成模式**（应对国产 ROM 杀后台）：App 启动/回前台时，`ProactiveMessageEngine.scheduleNext`
>    按档位算下一触发时刻（落活跃时段 + ±40% 抖动 + 受调度配额约束），**提前用 LLM 生成**一条
>    符合人设/记忆/时段的主动开场白（`proactive_prompts.dart`），写入新表 `scheduled_proactives`，
>    并排一条本地通知（AlarmManager，App 被杀也能到点弹）。
> ③ `ProactiveBootstrap` 扩展 `_deliverDueProactives`：到点（或下次启动对账）把排期投递成正式
>    `messages`(isProactive=true，按 ‹SEP› 分条多行)，标 delivered，再排下一条。
> ④ 通知点开 → main 注入 onTap 路由：先对账投递、再打开对应 ChatPage（用全局 navigatorKey）。
> ⑤ schema v2→v3：`personas.proactiveTier` 列 + `scheduled_proactives` 表（迁移）。
>    AndroidManifest 加通知/精确闹钟/开机权限 + flutter_local_notifications 的两个 receiver。
> ⑥ 新增测试 11 项（`proactive_tier` / `proactive_message_engine` / `proactive_bootstrap`）。
> 范围外：WorkManager 真后台实时生成、iOS 通知、通知内快捷回复。

> 增强（schema v2）：① 底部 Tab（微信/发现/我）+ 朋友圈聚合页 + 启动按「朋友圈活跃度」概率
> 自发朋友圈（设置页滑块可调，受调度作息/配额约束）；② 用户全局头像/昵称 +「我」页、数字人
> 头像/备注资料页（聊天页标题进入）；③ prompt 注入当前时间（深夜会困/饭点问吃饭）+ 气泡按
> 微信规则显示时间分隔。settings 表加 userName/userAvatarPath/momentFrequency 三列（迁移 v1→v2）。

- `flutter analyze`：无问题
- `flutter test`：全 120 项通过
- `flutter build apk --debug`：✅ 通过

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

## 全部批次完成情况

| 批次 | 内容 | 状态 |
|---|---|---|
| A / M0 | 工程地基、契约冻结、DB、适配器、设置页 | ✅ |
| B+C / MVP | 建号(填设定+txt导入)、微信聊天、五层记忆(读/写/衰减/面板)、画像编辑器、表情系统、导出导入、隐私告知 | ✅ |
| D / 主动性 | 活动调度中枢(R1)、开放回路引擎(对账 R2)、本地通知、启动补发 | ✅ |
| E / 社交 | 对外人格、纯文字朋友圈、点赞感知跨场景提起、朋友圈页 | ✅ |
| F / 扩展 | 多人/群聊、iOS、云备份、Claude 适配器、GPT embedding 增强 | ⬜ 按需 |

`flutter analyze` 0 问题；`flutter test` 81 项通过；`flutter build apk --debug` 通过。

## 已知限制 / 接真 key 后需验证

- **未真机/真 key 跑通**：所有 LLM 环节（对话/解析/提炼/朋友圈）由 MockAdapter 单测覆盖，
  真实模型的输出质量、像不像本人，需配 key 后 `flutter run` 实测校准（这是 MVP 灵魂验收）。
- **本地通知到点弹**：`LocalNotificationPort` 已封装 zonedSchedule，但关 App 到点弹通知需真机验证
  （含 Android 通知权限、精确闹钟权限）。补发对账逻辑已单测。
- **点开通知 → 落消息**：`NotificationPort.onTap` 回调骨架已留，main 里尚未把点开通知路由到对应聊天页
  并按人设 LLM 生成完整消息（当前补发用 plannedAction 文本占位，§8.4 可升级为 LLM 生成）。
- **朋友圈自动发布**：`maybePublish` 受调度约束，但目前靠朋友圈页右上手动触发；尚无"作息到点自动发"的定时驱动。
- **txt 导入图片/表情迁移**：备份不含表情图片文件本身（只存路径），换机需另行迁移图片。

## Phase 4 可选扩展（手册批次 F）

`MODEL-02` Claude 适配器、通讯录/多数字人、群聊、云加密备份、iOS 端、AI 生图朋友圈配图、
自动脱敏、GPT embedding 增强检索。均与现有契约解耦，可随时插入。

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
git log --oneline      # 应看到 M0→批次E 共 12 个提交
flutter analyze        # 应无问题
flutter test           # 81 项通过
```

四个 Phase 已全部实现。**最有价值的下一步是接真 key 在真机/模拟器 `flutter run` 跑一遍**，
验证「聊起来像不像本人」（MVP 灵魂）并校准 prompt；之后按需做「已知限制」里的真机项
（通知到点弹、点开通知路由）或 Phase 4 扩展。
