# self-iterating-harness

自迭代 AI Coding Harness：让 coding agent 在项目工作中沉淀路径记忆，经你确认后反哺规则、skills 与配置，半自动升级自己的 AI coding 框架。

> 本仓库与项目**混合在同一个目录**：本仓库根目录即 `<项目>/.dev/`。`.dev/` 按 private/public 原则收纳——`private/` 放服务 coding agent 的内容（本仓库跟踪、项目忽略），`public/` 放服务项目/产出的内容（项目跟踪、本仓库忽略）。

## 自迭代闭环

- path-memory：项目工作中沉淀探索记录（探索/纠正/碰壁/跑通，经你确认后写入 `private/records/`）。
- 规则演进：记录反哺 UAC/MAC 规则；换模型时按 `private/rules/ABLATION.md` 对 MAC 逐条消融。
- 部署：`private/scripts/sync.ps1` 把演进后的规则、skills、配置部署到本机生效，形成闭环。

自迭代不依赖额外逻辑，闭环即上述已有机制。

## 布局（与项目混合在同一目录，private/public 收纳）

```text
<项目>/
├─ .git/                       # 项目仓库（跟踪项目代码与 .dev/public/**）
├─ src/ tests/ ...             # 项目业务代码
├─ AGENTS.md                   # 项目入口规则（harness 部署的副本，git 忽略）
└─ .dev/                       # 本仓库根（harness 仓库，.git 在 .dev/.git）
   ├─ README.md / AGENTS.md / CLAUDE.md / .gitignore   # 本仓库入口
   ├─ private/                 # 服务 coding agent（本仓库跟踪；项目忽略）
   │  ├─ rules/ skills/ configs/ scripts/ docs/ lab/ preview/ plans/   # harness 内容
   │  ├─ skills/docs-writing/ skills/review/          # 项目私有 skills（两仓库都不跟踪）
   │  └─ records/              # 路径记忆（两仓库都不跟踪）
   └─ public/                  # 服务项目/产出（项目跟踪；本仓库忽略）
      ├─ lab/                  # 实验 + 门户
      └─ plans/                # 项目计划
```

分离组合（靠 ignore 配置）：

- 项目仓库：`.gitignore` 忽略 `.dev/*`，仅保留 `!.dev/public/**`；业务代码与 `.dev/public/` 由项目记录。
- 本仓库：`.gitignore` 忽略 `public/`、`private/records/`、`private/skills/docs-writing/`、`private/skills/review/`；其余 `private/` 内容由本仓库记录。

## 快速开始

```powershell
# 在本仓库根（<项目>/.dev）执行
.\private\scripts\validate.ps1            # 校验 skills 结构
.\private\scripts\sync.ps1 -Hooks         # 部署到本机 + 安装 path-memory hooks
.\private\scripts\sync.ps1 -DryRun        # 预览
```

零安装：仅依赖 PowerShell 与 git，不运行任何安装程序。

## 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留在本仓库（`private/` 下）。
- **agent 工作产物只记框架**：lab 等 agent 工作产生的实验、报告、证据只保留结构/模板框架，具体产物留在项目 `.dev/public/`。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `private/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `private/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `private/scripts/validate.ps1`；更新第三方前运行 `private/scripts/pull-vendor.ps1`。

详细说明见 [docs/usage.md](private/docs/usage.md)；仓库内工作规范见 [AGENTS.md](AGENTS.md)。
