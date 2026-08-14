# Matt Pocock Skills — 个人中文化 Fork

本仓库是 [mattpocock/skills](https://github.com/mattpocock/skills)（**Skills For Real Engineers**）的个人 fork。技能本体与上游一致——小而可组合、任何模型可用、按真实工程经验沉淀——在此之上带两处本地改动（见[与原项目的差异](#与原项目的差异)）。

> **同步策略**：本 fork 只从上游拉取更新（`git pull` 同步），本地改动不回推上游。

## 与原项目的差异

与原项目相比，本 fork 只改了一个技能：`setup-matt-pocock-skills`（及其两个 tracker 种子模板），其余技能文件与上游一致。

### 1. 按项目中文化（语言选项）

`/setup-matt-pocock-skills` 初始化时新增**语言选项**，每个项目独立选择：

- **全中文** —— 生成的 `docs/agents/*.md` 与 `## Agent skills` 块用中文；tracker 的标签值（triage 五角色 + wayfinder 的 map/type）也中文化，并写入"本项目标签值为准、技能正文英文 token 仅作默认"的覆盖说明；setup 时探测存量英文标签并提示处理
- **中文，标签值保留英文**（推荐）—— 文档与输出中文，标签值保持英文 token
- **英文** —— 与上游原行为一致

选中文档位时，`CLAUDE.md` / `AGENTS.md` 的 `## Agent skills` 块里会多一行**输出语言指令**：本项目的技能输出、总结、报告都用中文（一条线覆盖对话总结与结果输出）。改语言只需编辑那行或 `docs/agents/*.md`。

### 2. 关闭 issue 前先勾选验收标准

GitLab 会把 issue 描述里的 `- [ ]` / `- [x]` 渲染成任务清单，`N/M tasks completed` 只跟复选框走、与 open/closed 无关——用 commit 消息 `Closes #n` 自动关闭的 issue 会显示 **"0 of 4 tasks completed"**。本 fork 在 GitLab 与 GitHub 的 tracker 模板里加了约束：

1. **关闭前先勾选**已完成的验收标准（`glab issue update` / `gh issue edit` 重写描述，其余部分保持原样）
2. **显式关闭**，不用 `Closes #n` 自动关闭
3. **关闭后自检** `task_completion_status.completed_count == count`（GitHub 查正文确认全勾选）

## 安装

### 推荐：skills.sh（任何 agent 通用）

```bash
npx skills@latest add ddv12138/mattpocock-skills
```

选择要安装的技能，以及装到哪些 coding agent 上。**安装器会让你勾选技能——务必包含 `setup-matt-pocock-skills`。** 它以普通文件形式把技能写进你的项目，可自由编辑；想拉取最新改动时用 `npx skills update`。

**已装过原项目？** 用一键脚本：自动检测原项目安装，已装则询问是否彻底清理——同意就先删干净再装本 fork，拒绝则给建议退出、不动任何东西：

```bash
bash scripts/install-skills.sh
```

> 勾选子集时务必包含 `setup-matt-pocock-skills`（本 fork 唯一与上游不同的技能），否则它保持上游版。

### Claude Code 插件（可选）

本 fork 不在 Claude Code 官方 marketplace 里。插件名是 `mattpocock-skills-cn`，与官方 `mattpocock-skills` 区分开（不会同名冲突）——但**两者各带全套技能，不能共存**：若已装官方插件，先卸载再装本 fork。

一键脚本（自动检测官方插件，询问是否先卸载，确认后完成安装）：

```bash
bash scripts/install-claude-plugin.sh
```

或手动：

```
/plugin marketplace add ddv12138/mattpocock-skills
/plugin install mattpocock-skills-cn@mattpocock
```

> **已装官方插件？** 手动方式请先 `/plugin uninstall mattpocock-skills` 再执行上面两条（脚本会自动完成）。插件是只读、随发布更新的捆绑；skills.sh 写的是你可编辑的文件。**两条路二选一**——都装会得到两套技能。

## 正常的工作流程

每个仓库先跑一次 `/setup-matt-pocock-skills`（选择输出语言、issue tracker、triage 标签、领域文档布局），之后的主链路：

```
/grill-with-docs → /to-spec → /to-tickets → /implement → 关闭 ticket
```

1. **`/grill-with-docs`** —— 对齐要做的事，同时构建领域模型（术语进 `CONTEXT.md`，难决策进 ADR）。纯讨论、没有代码库时用 `/grill-me`。
2. **`/to-spec`** —— 把对齐结果合成 spec，发布到 tracker。不再访谈，只综合已经讨论清楚的。
3. **`/to-tickets`** —— 把 spec 拆成一组"曳光弹"ticket：每条都是贯穿各层的垂直切片、声明自己的阻塞边，发布到 tracker。
4. **`/implement`** —— 一个会话一个 ticket：在预定 seam 上驱动 `/tdd`，常跑类型检查与测试，最后 `/code-review`，提交到当前分支。
5. **关闭 ticket** —— 先勾选已完成的验收标准（`- [x]`），显式关闭（不用 `Closes #n` 自动关闭），关闭后自检完成数（本 fork 的改动，见上）。

其他场景：

- 跨多个会话的大工程 → **`/wayfinder`**（在 tracker 上生成决策 ticket 地图，逐个解决到终点清晰）
- 存量 issue / 外部 PR 流入 → **`/triage`**
- 每隔几天 → **`/improve-codebase-architecture`**（扫描"加深模块"的机会）
- 中途遇到硬 bug → **`/diagnosing-bugs`**
- 不知道下一步用哪个 → **`/ask-matt`**（路由器）

## 技能参考

按触发方式分两类：**用户触发**的技能只能由你输入斜杠命令调用，负责编排；**模型触发**的技能既可以由你调用、也允许 agent 在任务匹配时自动拾取，承载可复用的纪律。用户触发的技能可以调用模型触发的，但不会调用另一个用户触发的。

### Engineering — 工程技能（日常代码工作）

**用户触发**

- **[ask-matt](./skills/engineering/ask-matt/SKILL.md)** —— 不知道该用哪个技能或流程时问它；本仓库用户触发技能的路由器。
- **[grill-with-docs](./skills/engineering/grill-with-docs/SKILL.md)** —— 拷问式对话，同时构建项目领域模型：打磨术语、就地更新 `CONTEXT.md` 与 ADR。
- **[triage](./skills/engineering/triage/SKILL.md)** —— 把 issue 和外部 PR 推过 triage 状态机：分类、验证、必要时拷问、写 agent 就绪简报。
- **[improve-codebase-architecture](./skills/engineering/improve-codebase-architecture/SKILL.md)** —— 扫描代码库找"加深模块"的机会，产出可视化 HTML 报告，再逐个拷问选定项。
- **[setup-matt-pocock-skills](./skills/engineering/setup-matt-pocock-skills/SKILL.md)** —— 每仓库配置工程技能的前提：输出语言、issue tracker、triage 标签、领域文档布局。每个仓库跑一次。
- **[to-spec](./skills/engineering/to-spec/SKILL.md)** —— 把当前对话合成 spec 并发布到 tracker。不再访谈——只综合你已经讨论清楚的。
- **[to-tickets](./skills/engineering/to-tickets/SKILL.md)** —— 把任何计划、spec 或对话拆成一组"曳光弹"ticket，各自声明阻塞边——本地文件，或真实 tracker 的原生阻塞链接。
- **[implement](./skills/engineering/implement/SKILL.md)** —— 按 spec 或一组 ticket 构建工作，在预定 seam 上驱动 `/tdd`，提交前用 `/code-review` 收尾。
- **[wayfinder](./skills/engineering/wayfinder/SKILL.md)** —— 把超过一个 agent 会话容量的大工程规划成 tracker 上一张决策 ticket 地图——逐个解决，直到终点清晰。

**模型触发**

- **[prototype](./skills/engineering/prototype/SKILL.md)** —— 为回答设计问题做一次性原型：状态/逻辑问题一个可共享的 HTML 文件，或从单一路由切换的多个 UI 变体。
- **[diagnosing-bugs](./skills/engineering/diagnosing-bugs/SKILL.md)** —— 硬 bug 与性能回归的纪律化诊断循环：建立"在此 bug 上变红"的反馈环 → 最小化 → 假设 → 插桩 → 修复 → 回归测试。
- **[research](./skills/engineering/research/SKILL.md)** —— 对高可信一手来源调研，把结论写成带引用的 Markdown 落在仓库里，以后台 agent 运行。
- **[tdd](./skills/engineering/tdd/SKILL.md)** —— 红绿重构循环的测试驱动开发，一次一个垂直切片地构建功能或修 bug。
- **[domain-modeling](./skills/engineering/domain-modeling/SKILL.md)** —— 主动构建并打磨项目领域模型：用词汇表挑战术语、边界场景压力测试、就地更新 `CONTEXT.md` 与 ADR。
- **[codebase-design](./skills/engineering/codebase-design/SKILL.md)** —— 设计"深模块"的共享纪律与词汇：少量行为通过简单接口暴露、放在干净的 seam、通过接口可测。
- **[code-review](./skills/engineering/code-review/SKILL.md)** —— 自固定点以来 diff 的双轴评审：**标准**（是否遵循仓库编码标准 + Fowler 坏味道基线）与**规格**（是否忠实实现源头 issue/spec），并行子 agent 运行互不污染。
- **[resolving-merge-conflicts](./skills/engineering/resolving-merge-conflicts/SKILL.md)** —— 逐 hunk 解决进行中的 merge/rebase 冲突，按意图追溯到双方的一手来源，然后完成操作——绝不 `--abort`。
- **[wizard](./skills/engineering/wizard/SKILL.md)** —— 生成交互式 bash 向导，带人走只有人才能做的步骤：配基础设施、凭证或 CI 密钥、陌生的第三方面板、一次性迁移或切换。

### Productivity — 效率技能（非代码工作流）

**用户触发**

- **[grill-me](./skills/productivity/grill-me/SKILL.md)** —— 关于计划或设计被持续追问，直到设计树的每个分支都解决。
- **[handoff](./skills/productivity/handoff/SKILL.md)** —— 把当前对话压缩成交接文档，让另一个 agent 能接着干。
- **[teach](./skills/productivity/teach/SKILL.md)** —— 跨多个会话教你一个新技能或概念，用当前目录作为有状态的教学生态空间。
- **[to-questionnaire](./skills/productivity/to-questionnaire/SKILL.md)** —— 把独自答不出的决策变成一份 Markdown 问卷，给唯一能答的人——异步填，或开会一起填。
- **[wait-what](./skills/productivity/wait-what/SKILL.md)** —— 消息一落地就触发：agent 用你缺的上下文、plain language 和 `CONTEXT.md` 词汇重新讲一遍。

**模型触发**

- **[grilling](./skills/productivity/grilling/SKILL.md)** —— 持续追问计划、决策或想法，直到设计树每个分支都解决。`grill-me`、`grill-with-docs`、`triage`、`wayfinder` 与 `improve-codebase-architecture` 背后的可复用访谈原语。
- **[writing-for-agents](./skills/productivity/writing-for-agents/SKILL.md)** —— 为 agent 写文档：技能、AGENTS.md/CLAUDE.md、任何 agent 按指针读取的文档。

## 上游与同步

- 原项目：[mattpocock/skills](https://github.com/mattpocock/skills)
- 本 fork 持续从上游同步，本地改动不回推上游
- 同步方式：把上游加为 remote 后 `git fetch` / `git merge`（README、`install-block.md` 与 `setup-matt-pocock-skills` 的几个文件是本地改动点，同步时可能产生冲突，以本地为准）
