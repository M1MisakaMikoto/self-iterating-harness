# self-iterating-harness

自迭代 AI Coding Harness：让 coding agent 在项目工作中沉淀路径记忆，经你确认后反哺规则、skills 与配置，半自动升级自己的 AI coding 框架。

> 本仓库与项目**文件混在一起、仓库各自独立**：harness 仓库 git 元数据在 `<项目>/.git-harness`，工作根指向项目根（与项目仓库的根在同一个目录）。harness 文件按 **private/public 原则**收纳在 `.dev/`：**`private/` = 服务 coding agent 的内容**（本仓库跟踪、项目忽略），**`public/` = agent 产出、服务项目的内容**（项目只跟踪其中的实验与计划文件）。UAC/MAC 是规则提示词内容的分类，不用于目录。

## 自迭代闭环

- path-memory：项目工作中沉淀探索记录（探索/纠正/碰壁/跑通，经你确认后写入 `private/records/`）。
- 规则演进：记录反哺 UAC/MAC 规则；换模型时按 `private/rules/ABLATION.md` 对 MAC 逐条消融。
- 部署：`private/scripts/sync.ps1` 把演进后的规则、skills、配置部署到本机生效，形成闭环。

自迭代不依赖额外逻辑，闭环即上述已有机制。

## 布局（与项目混合在同一目录，private/public 收纳）

```text
<项目>/
├─ .git/                       # 项目仓库（跟踪项目代码与 .dev/public/**）
├─ .git-harness/               # harness 仓库 git 元数据（工作根=项目根，独立仓库）
├─ src/ tests/ ...             # 项目业务代码
├─ AGENTS.md / CLAUDE.md       # 规则唯一真源（harness 跟踪、项目忽略，无副本无同步）
└─ .dev/                       # harness 文件混在这里
   ├─ README.md / .gitignore   # 根入口（README 仓库主页展示；.gitignore git 机制）
   ├─ private/                 # 服务 coding agent（本仓库跟踪、项目忽略）
   │  ├─ rules/                # 规则模板 + ABLATION（规范真源在项目根 AGENTS.md/CLAUDE.md）
   │  ├─ skills/               # my/ vendor/（harness）+ docs-writing/ review/（项目私有，不跟踪）
   │  ├─ scripts/              # sync / validate / hooks / hgit
   │  ├─ configs/              # 工具配置模板
   │  ├─ lab/                  # Agent Lab 框架（规范/词汇表/ADR）
   │  └─ records/              # 路径记忆（两仓库都不跟踪）
   └─ public/                  # agent 产出、服务项目
      ├─ docs/                 # 使用说明与变更记录
      ├─ preview/              # 门户模板
      ├─ plans/                # 计划（框架 README + 项目计划）
      └─ lab/                  # 项目实验 + 门户
```

分离组合（仓库独立，靠各仓库 info/exclude 分离）：

- 项目仓库 `info/exclude`：忽略 `.dev/*`（保留 `!.dev/public/**`）、`/AGENTS.md`、`/CLAUDE.md`。
- 本仓库 `info/exclude`：忽略项目代码（`/src/`、`/tests/` 等）与自身 gitdir `/.git-harness/`；`.dev/.gitignore` 再排除 `private/records/` 等项目本地内容。
- 根 `.gitignore` 只放两边通用的规则，不做分离（共享工作区，避免规则互相泄漏）。
- git 用法：项目仓库在项目根直接 `git`；本仓库在项目根 `git --git-dir=.git-harness <命令>` 或 `.\dev\public\scripts\hgit.ps1 <命令>`。

## 快速开始

```powershell
# 在本仓库根（<项目>/.dev）执行
.\private\scripts\validate.ps1            # 校验 skills 结构
.\private\scripts\sync.ps1 -Hooks         # 部署到本机 + 安装 path-memory hooks
.\private\scripts\sync.ps1 -DryRun        # 预览
# harness 仓库 git（在项目根执行）
.\dev\public\scripts\hgit.ps1 status
```

零安装：仅依赖 PowerShell 与 git，不运行任何安装程序。

## 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留在本仓库（`private/` 与 `public/` 下）。
- **agent 工作产物只记框架**：lab 等 agent 工作产生的实验、报告、证据只保留结构/模板框架，具体产物留在项目 `.dev/public/`。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `private/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `private/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `private/scripts/validate.ps1`；更新第三方前运行 `private/scripts/pull-vendor.ps1`。

详细说明见 [docs/usage.md](public/docs/usage.md)。
