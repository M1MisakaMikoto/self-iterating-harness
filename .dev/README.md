# self-iterating-harness

自迭代 AI Coding Harness：让 coding agent 在项目工作中沉淀路径记忆，经你确认后反哺规则、skills 与配置，半自动升级自己的 AI coding 框架。

> 本仓库与项目**文件混在同一个工作区、仓库各自独立**：harness 仓库 git 元数据在工作区根 `.git`（工作树=工作区根）；项目代码仓库在工作区根下的**同名子目录**（如 `AgentSupport\AgentSupport`）。harness 内容按 **serve_agent / serve_project** 原则收纳在 `.dev/`：**`serve_agent/` = 服务 coding agent 的内容**（本仓库跟踪、项目忽略），**`serve_project/` = agent 产出、服务项目的内容**（实验、门户、计划等）。UAC/MAC 是规则提示词内容的分类，不用于目录。

## 自迭代闭环

- path-memory：项目工作中沉淀探索记录（探索/纠正/碰壁/跑通，经你确认后写入 `serve_agent/records/`）。
- 规则演进：记录反哺 UAC/MAC 规则；换模型时按 `serve_agent/rules/ABLATION.md` 对 MAC 逐条消融。
- 部署：`serve_agent/scripts/sync.ps1` 把演进后的规则、skills、配置部署到本机生效，形成闭环。

自迭代不依赖额外逻辑，闭环即上述已有机制。

## 布局（harness 与项目混在同一工作区）

```text
<工作区>/
├─ .git/                       # harness 仓库 git 元数据（工作树=工作区根）
├─ AGENTS.md / CLAUDE.md       # 规则唯一真源（harness 跟踪，无副本无同步）
├─ .dev/                       # harness 内容混在这里
│  ├─ README.md / .gitignore   # 根入口
│  ├─ serve_agent/             # 服务 coding agent（本仓库跟踪、项目忽略）
│  │  ├─ lab.md                # Agent Lab 指导（唯一描述）
│  │  ├─ CONTEXT.md            # Agent Lab 词汇表（独立文件）
│  │  ├─ rules/                # 规则模板 + ABLATION（规范真源在 AGENTS.md/CLAUDE.md）
│  │  ├─ skills/               # my/ vendor/（harness）+ docs-writing/ review/（项目私有，不跟踪）
│  │  ├─ scripts/              # sync / validate / hooks / hgit
│  │  ├─ configs/              # 工具配置模板
│  │  └─ records/              # 路径记忆（两仓库都不跟踪）
│  └─ serve_project/           # agent 产出、服务项目
│     ├─ docs/                 # 使用说明与变更记录
│     ├─ preview/              # 门户模板
│     ├─ plans/                # 计划
│     └─ lab/                  # 实验实施位置（实验 + 门户 index.html）
└─ <项目名>/                   # 项目代码仓库（如 AgentSupport/）
   ├─ .git/
   └─ src/ tests/ ...          # 项目业务代码
```

分离组合（仓库独立，靠各仓库 info/exclude 分离）：

- 项目代码仓库：只跟踪自身代码（不含 `.dev`）。
- harness 仓库 `info/exclude`：排除 `<项目名>/` 子目录与本地残留；`.dev/.gitignore` 再排除 `serve_agent/records/` 等项目本地内容。
- git 用法：harness 仓库在工作区根直接 `git`；项目仓库 `git -C <项目名>`；快捷命令 `.\dev\serve_agent\scripts\hgit.ps1`（等价于根目录 `git`）。

## 快速开始

```powershell
# 在工作区根（<工作区>/.dev 所在处）执行
.\dev\serve_agent\scripts\validate.ps1            # 校验 skills 结构
.\dev\serve_agent\scripts\sync.ps1 -Hooks         # 部署到本机 + 安装 path-memory hooks
.\dev\serve_agent\scripts\sync.ps1 -DryRun        # 预览
# harness 仓库 git（在工作区根执行）
.\dev\serve_agent\scripts\hgit.ps1 status
```

零安装：仅依赖 PowerShell 与 git，不运行任何安装程序。

## 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留在本仓库（`serve_agent/` 与 `serve_project/` 下）。
- **agent 工作产物**：lab 实验、报告、证据等位于 `serve_project/lab/`，由本仓库记录（如需按"只记框架"收窄，可另行清理）。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `serve_agent/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `serve_agent/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `serve_agent/scripts/validate.ps1`；更新第三方前运行 `serve_agent/scripts/pull-vendor.ps1`。

详细说明见 [docs/usage.md](serve_project/docs/usage.md)。
