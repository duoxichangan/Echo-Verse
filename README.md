<p align="center">
  <img src="logo.jpg" alt="EchoVerse Logo" width="200">
</p>

# EchoVerse（虚拟数字人）

> 把那些熟悉的动静、习惯的语气，捻成线，缝进聊天框的缝隙里。

**EchoVerse** 是一个基于大语言模型（LLM）的**虚拟数字人应用**——导入你与某人的真实微信聊天记录，AI 会提炼出 TA 的人格画像，之后你就可以在复刻的微信界面里和 TA 聊天。TA 会像一个真人一样：有记忆、有情绪、有关心、有脾气，甚至会**主动找你**、**自发朋友圈**。

---

## 核心功能

### 🧠 人格复刻
- **聊天记录导入**：上传你与 TA 的微信聊天记录 txt 文件，AI 自动解析对话结构、提炼说话风格与性格特征
- **手动创建**：不导入记录也能建号——填昵称、关系、性格关键词，AI 自动生成合理画像
- **五层记忆架构**（L0–L5）：从铁律人格到可检索对话原文，记忆会自动衰减、覆盖、更新，越来越像真人

### 🔔 主动找你
- 每个数字人可设置**主动频率**（关闭 / 偶尔 / 正常 / 频繁）
- 到点 TA 会主动发消息给你（本地通知弹窗），预生成符合人设和时段的开场白
- 不怕 App 被杀——基于 AlarmManager 的精确闹钟，关机重启也会到点弹

### 📱 朋友圈
- 数字人会**自发朋友圈**（频率可调），内容符合 TA 的人设和近期记忆
- 你可以在朋友圈页看到所有数字人的动态
- 你点赞后，TA 会在聊天中自然提起（跨场景感知）

### 📦 备份与迁移
- 一键导出/导入整库（JSON），换手机不丢人
- 密钥（API key）不落库，走加密存储，备份自动剔除

---

## 导入微信聊天记录（WeFlow）

### 格式要求

EchoVerse 支持**两种解析路径**，优先本地正则（精确、免费、不丢消息），兜底 LLM（适应杂格式）：

#### 方式一：本地正则（推荐，100% 精确）

适用于 **WeFlow** 或其他工具导出的**规整格式**。文件需满足：

```
2025-01-12 12:57:01 '我'
今天中午吃啥？

2025-01-12 13:07:46 '张三'
不知道啊，你想吃啥？

2025-01-12 13:08:02 '我'
[表情包]

2025-01-12 13:10:15 '张三'
[捂脸]
```

**格式规则**：
- 每条消息以 `日期 时间 '说话人'` 开头（支持中英文单双引号，也支持无引号）
- 日期格式支持 `YYYY-MM-DD` 和 `YYYY/M/D`
- 时间格式 `H:M:S`
- 占位符如 `[图片]`、`[表情包]`、`[语音]` 等会被自动识别为对应类型
- 消息内容可以跨多行

#### 方式二：LLM 解析（兜底）

如果文件格式不规整（复制粘贴、OCR 提取等），本地解析失败后会自动回退到 LLM 解析，尽可能提取对话结构。

### 使用 WeFlow 导出

**WeFlow** 是目前推荐的工具，可导出规整的微信聊天记录为 txt。建议导出步骤：

1. 使用 WeFlow 打开目标聊天
2. 选择「导出为文本」
3. 确保导出格式包含时间戳和说话人信息
4. 保存为 `.txt` 文件，然后导入 EchoVerse

### 导入流程

1. 打开 EchoVerse → 点击右上角 `+` → 选择「导入聊天记录」
2. 选择导出的 `.txt` 文件
3. 等待解析完成（本地解析秒级，LLM 解析需联网且需数秒至数十秒）
4. 在解析结果中**指认你要复刻的人**（即 txt 里的说话人之一）
5. 补充昵称、关系等设定（可选）
6. 点击「开始创建」——AI 会从对话中提炼出 TA 的完整人格画像
7. 创建完成，开始聊天！

---

## 技术架构

```
lib/
├── domain/              # 领域层（契约 + 模型，纯 Dart，无依赖）
│   ├── contracts/       # 接口契约（ModelAdapter / PersonaRepo / MemoryService / ...）
│   └── models/          # 领域模型（Persona / MemoryFact / OpenLoop / ...）
├── data/                # 数据层
│   ├── db/              # drift SQLite 数据库（10 张表）
│   └── repos/           # 仓储实现（DriftPersonaRepo / DriftStickerRepo / ...）
├── adapter/             # 模型适配器（OpenAI 兼容 API / Mock 离线测试）
├── app/                 # 应用层（用例实现）
│   ├── di/              # 依赖注入（Riverpod）
│   ├── chat/            # 对话引擎 + 上下文组装 + 输出后处理
│   ├── memory/          # 记忆服务（五层架构 + 艾宾浩斯衰减）
│   ├── persona/         # 人格解析 + 提炼
│   ├── proact/          # 主动性调度（作息 + 开放回路 + 预生成 + 通知）
│   ├── social/          # 社交服务（朋友圈 + 对外人格）
│   └── ops/             # 备份导出/导入
├── platform/            # 平台桥接（加密存储）
├── prompts/             # Prompt 模板（对话 / 记忆 / 人格 / 主动性 / 社交）
└── ui/                  # UI 层（微信复刻）
    ├── chat/            # 聊天页 + 气泡组件 + 微信主题
    ├── persona/         # 创建/导入/资料/编辑
    ├── home/            # 会话列表
    ├── moments/         # 朋友圈
    ├── memory/          # 记忆面板
    ├── shell/           # 主框架（底部 Tab）
    ├── settings/        # 设置页
    ├── common/          # 通用组件（微信 emoji 映射等）
    └── me/              # 「我」页
```

### 技术栈

| 层 | 技术 |
|---|---|
| 框架 | Flutter (master 渠道, SDK ^3.12) |
| 状态管理 | riverpod |
| 数据库 | drift (SQLite) |
| 加密存储 | flutter_secure_storage |
| 网络 | dio + SSE 流式 |
| 通知 | flutter_local_notifications + AlarmManager |
| 依赖注入 | Riverpod Provider |
| 测试 | flutter_test + MockAdapter（离线全流程） |

### 记忆架构（五层）

| 层级 | 名称 | 说明 |
|---|---|---|
| L0 | 铁律 | 「绝不承认是 AI」「我就是 TA 本人」——永不衰减 |
| L1 | 滚动摘要 | 近期对话的压缩概要 |
| L2 | 长程事实 | 具体事件、偏好、承诺，按重要性衰减（τ=14天半衰期） |
| L3 | 关系状态 | 亲密度、情绪、未解之事 |
| L4 | 永久核心 | 性格、用语习惯、价值观——写入画像，不衰减 |
| L5 | 原始对话 | 可关键词检索的原话 |

---

## 快速开始

### 前置要求

- Flutter SDK（master 渠道，SDK ^3.12）
- Android Studio / Android SDK Platform 35
- JDK 17+
- 一个 LLM API key（支持 OpenAI 兼容接口，如 DeepSeek、GPT-4 等）

### 安装与运行

```bash
# 1. 克隆仓库
git clone git@github.com:duoxichangan/Echo-Verse.git
cd Echo-Verse/virtual

# 2. 安装依赖
flutter pub get

# 3. 生成数据库代码（如修改了 tables.dart）
dart run build_runner build

# 4. 运行测试（确保所有 120 项通过）
flutter test

# 5. 运行静态分析
flutter analyze

# 6. 连接设备，配置 API key 后运行
flutter run

# 7. 构建 release APK
flutter build apk
```

### 首次使用

1. 启动 App → 进入设置页 → 填入 LLM API 配置（provider / base_url / api_key / model）
2. 点击「测试连接」，确认能收到流式回复
3. 回到主页 → 点击 `+` → 选择「创建数字人」或「导入聊天记录」
4. 开始聊天！