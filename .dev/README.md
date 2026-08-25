# ai-coding-configs

个人 AI 编程配置仓库：集中存放自用的 `AGENTS.md` / `CLAUDE.md`、自研 skills、从社区拉取的第三方 skills，以及 Codex / Claude Code / MCP 等工具的配置模板。

> 本仓库是"事实源（source of truth）"：所有内容以这里为准，再通过同步脚本部署到本机工具目录。

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

- 本仓库可放在任意项目内（如 `ai-coding-configs/` 子目录），其根 `README.md` 与项目根 `README.md` 互不影响（不同目录、不同仓库）。
- `sync.ps1` 会把服务 coding agent 的忽略规则（`.dev/private/`、`/AGENTS.md`）追加到项目 `.gitignore`（仅当不存在时）；`.dev/public/` 内容默认不被忽略、自动记录。

详细说明见 [.dev/docs/usage.md](docs/usage.md)。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `.dev/skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `.dev/configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `.dev/scripts/validate.ps1`；更新第三方前运行 `.dev/scripts/pull-vendor.ps1`。

完整规则见 [AGENTS.md](AGENTS.md)。
