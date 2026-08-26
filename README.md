# self-iterating-harness

自迭代 AI Coding Harness：让 coding agent 在项目工作中沉淀路径记忆，经你确认后反哺规则、skills 与配置，半自动升级自己的 AI coding 框架。

> 本仓库与项目**混合在同一个目录**：本仓库根目录即 `<项目>/.dev/`。`.dev/` 按 **private/public 原则**收纳：**`private/` = UAC 用户辅助内容**（跨模型稳定，指导与用户交互/汇报；本仓库跟踪、项目忽略），**`public/` = MAC 模型辅助内容**（增强模型能力，换模型需消融；项目与本仓库都跟踪）。

## 自迭代闭环

- path-memory：项目工作中沉淀探索记录（探索/纠正/碰壁/跑通，经你确认后写入 `private/records/`）。
- 规则演进：记录反哺 UAC/MAC 规则；换模型时按 `private/rules/ABLATION.md` 对 MAC 逐条消融。
- 部署：`public/scripts/sync.ps1` 把演进后的规则、skills、配置部署到本机生效，形成闭环。

自迭代不依赖额外逻辑，闭环即上述已有机制。

## 布局（与项目混合在同一目录，private/public 收纳）

```text
<项目>/
├─ .git/                       # 项目仓库（跟踪项目代码与 .dev/public/**）
├─ src/ tests/ ...             # 项目业务代码
├─ AGENTS.md                   # 项目入口规则（harness 部署的副本，git 忽略）
└─ .dev/                       # 本仓库根（harness 仓库，.git 在 .dev/.git）
   ├─ README.md / .gitignore   # 根入口（README 仓库主页展示；.gitignore git 机制）
   ├─ private/                 # UAC 用户辅助内容（本仓库跟踪；项目忽略）
   │  ├─ AGENTS.md / CLAUDE.md # 仓库工作指南
   │  ├─ rules/                # 全局工作规范（UAC/MAC 分区 + ABLATION）
   │  ├─ docs/                 # 使用说明与变更记录
   │  ├─ lab/                  # Agent Lab 框架（规范/词汇表/ADR）
   │  ├─ skills/docs-writing/ skills/review/   # 项目私有 skills（两仓库都不跟踪）
   │  └─ records/              # 路径记忆（两仓库都不跟踪）
   └─ public/                  # MAC 模型辅助内容（项目与本仓库都跟踪——组合区）
      ├─ skills/ configs/ scripts/ preview/ plans/   # harness 的 MAC 内容
      └─ lab/                  # 项目实验 + 门户
```

分离组合（靠 ignore 配置）：

- `private/`（UAC）＝分离区：仅本仓库跟踪，项目忽略；本仓库另忽略 `private/records/`、`private/skills/docs-writing/`、`private/skills/review/`（项目本地）。
- `public/`（MAC）＝组合区：项目仓库与本仓库都跟踪（项目 `.gitignore`：`.dev/*` + `!.dev/public/**`；本仓库不忽略 public）。

## 快速开始

```powershell
# 在本仓库根（<项目>/.dev）执行
.\public\scripts\validate.ps1            # 校验 skills 结构
.\public\scripts\sync.ps1 -Hooks         # 部署到本机 + 安装 path-memory hooks
.\public\scripts\sync.ps1 -DryRun        # 预览
```

零安装：仅依赖 PowerShell 与 git，不运行任何安装程序。

## 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留在本仓库（`private/` 与 `public/` 下）。
- **agent 工作产物只记框架**：lab 等 agent 工作产生的实验、报告、证据只保留结构/模板框架，具体产物留在项目 `.dev/public/`。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `public/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `public/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `public/scripts/validate.ps1`；更新第三方前运行 `public/scripts/pull-vendor.ps1`。

详细说明见 [docs/usage.md](private/docs/usage.md)；仓库内工作规范见 [AGENTS.md](AGENTS.md)。
