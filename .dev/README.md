# self-iterating-harness

自迭代 AI Coding Harness：集中管理自用的 `AGENTS.md` / `CLAUDE.md`、自研 skills、从社区拉取的第三方 skills、Codex / Claude Code / MCP 配置模板与同步脚本；path-memory 路径记忆与规则消融构成自迭代闭环，让框架在项目工作中自我演进。

> 本仓库是"事实源（source of truth）"：所有内容以这里为准，再通过同步脚本部署到本机工具目录。

## 自迭代闭环

- path-memory：项目工作中沉淀探索记录（探索/纠正/碰壁/跑通，经你确认后写入）。
- 规则演进：记录反哺 UAC/MAC 规则；换模型时按 `rules/ABLATION.md` 对 MAC 逐条消融。
- 部署：`sync.ps1` 把演进后的规则、skills、配置部署到本机生效，形成闭环。

自迭代不依赖额外逻辑，闭环即上述已有机制。

## 目录结构

```text
.
├─ README.md / AGENTS.md / CLAUDE.md / .gitignore   # 根只留入口（本文件是详细说明）
└─ .dev/
   ├─ lab/              # Agent Lab 框架：AGENTS、CONTEXT、docs/norms、docs/adr
   ├─ preview/          # 前端 preview 模板（门户页 index.html）
   ├─ plans/            # 计划目录
   ├─ rules/            # 全局工作规范（完整）+ 规则模板
   ├─ skills/
   │  ├─ my/            # 自研 skills，每个子目录一个 skill（含 SKILL.md）
   │  └─ vendor/        # 第三方 skills，按来源分组，每组带 SOURCE.md
   ├─ configs/          # 工具配置模板（不含真实密钥）
   ├─ scripts/          # sync / validate / pull-vendor / vendor-manifest.json
   └─ docs/             # usage.md / changelog.md
```

## 快速开始

```powershell
# 1. 校验仓库内 skills 结构是否合法
.\\.dev\\scripts\\validate.ps1

# 2. 一键部署到本机：skills + 全局规则 + 配置模板（配置模板不覆盖已存在的本地文件）
.\\.dev\\scripts\\sync.ps1

# 预览将执行的操作
.\\.dev\\scripts\\sync.ps1 -DryRun
```

零安装：仅依赖 PowerShell 与 git，不运行任何安装程序。

## 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留。
- **agent 工作产物只记框架**：lab 等 agent 工作产生的实验、报告、证据只保留结构/模板框架，具体产物留在项目本地。

## 与项目仓库的关系

- 本仓库与项目**同级放置**（如 `D:\dev\projects\self-iterating-harness` 与 `D:\dev\projects\<项目>` 并列）；也可临时放进项目内。根 `README.md` 与项目根 `README.md` 互不影响（不同目录、不同仓库）。
- 放在项目内时，`sync.ps1` 会把服务 coding agent 的忽略规则（`.dev/private/`、`/AGENTS.md`）追加到项目 `.gitignore`（仅当不存在时）；同级放置时该步骤自动跳过，由各项目自行维护 `.gitignore`。`.dev/public/` 内容默认不被忽略、自动记录。

详细说明见 [.dev/docs/usage.md](docs/usage.md)。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `.dev/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `.dev/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `.dev/scripts/validate.ps1`；更新第三方前运行 `.dev/scripts/pull-vendor.ps1`。

完整规则见 [AGENTS.md](AGENTS.md)。
