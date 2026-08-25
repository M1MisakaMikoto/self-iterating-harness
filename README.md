# ai-coding-configs

个人 AI 编程配置仓库：集中存放自用的 `AGENTS.md` / `CLAUDE.md`、自研 skills、从社区拉取的第三方 skills，以及 Codex / Claude Code / MCP 等工具的配置模板。

> 本仓库是"事实源（source of truth）"：所有内容以这里为准，再通过同步脚本部署到本机工具目录。

## 目录结构

```text
.
├─ AGENTS.md            # 给 Codex 等 agent 的仓库说明（AI 维护本仓库时遵守）
├─ CLAUDE.md            # 给 Claude Code 的仓库说明
├─ skills/
│  ├─ my/               # 自研 skills，每个子目录一个 skill（含 SKILL.md）
│  └─ vendor/           # 第三方 skills，按来源分组，每组带 SOURCE.md
├─ configs/             # 工具配置模板（不含真实密钥）
│  ├─ codex/
│  ├─ claude/
│  └─ mcp/
├─ scripts/
│  ├─ sync.ps1          # 同步 skills/配置到本机 ~/.codex、~/.claude
│  ├─ pull-vendor.ps1   # 按 manifest 拉取/更新第三方 skills
│  ├─ validate.ps1      # 校验 skills 结构（提交前运行）
│  └─ vendor-manifest.json
├─ docs/
│  ├─ usage.md          # 详细使用说明
│  └─ changelog.md
└─ README.md
```

## 快速开始

```powershell
# 1. 校验仓库内 skills 结构是否合法
.\scripts\validate.ps1

# 2. 部署到本机（只复制/覆盖 skills，配置模板不覆盖已存在的本地文件）
.\scripts\sync.ps1

# 预览将执行的操作
.\scripts\sync.ps1 -DryRun
```

详细说明见 [docs/usage.md](docs/usage.md)。

## 约定（摘要）

- 每个 skill 独立目录，根目录必须有 `SKILL.md`，frontmatter 包含 `name` 与 `description`。
- 第三方内容一律进 `skills/vendor/<来源>/`，并维护 `SOURCE.md`（来源 URL、commit、许可证、本地修改）。
- `configs/` 只放模板与占位符，真实密钥永不入库。
- 提交前运行 `scripts/validate.ps1`；更新第三方前运行 `scripts/pull-vendor.ps1`。

完整规则见 [AGENTS.md](AGENTS.md)。
