# CLAUDE.md

这是给 Claude Code 的仓库级说明。先读本文件，再处理任何任务。

## 这是什么仓库

个人 AI 编程配置库：自研 skills（`skills/my/`）、第三方 skills（`skills/vendor/`）、Codex/Claude Code/MCP 配置模板（`configs/`），以及配套 PowerShell 脚本（`scripts/`）。仓库本身没有业务代码，也不含密钥。

## 布局速览

- `skills/my/<name>/SKILL.md`：自研 skill，frontmatter 必须含 `name` 与 `description`。
- `skills/vendor/<来源>/`：第三方 skills，目录内必须含 `SOURCE.md` 记录来源。
- `configs/claude/settings.json`：Claude 权限模板（allow/ask/deny 示例）。
- `configs/codex/`、`configs/mcp/`：对应工具模板。
- `docs/usage.md`：人类使用说明；`docs/changelog.md`：变更记录。

## 关键规则

1. 新增 skill：确认放 `my/` 还是 `vendor/`；保持标准结构（`SKILL.md` + 可选 `references/`、`scripts/`、`assets/`）。
2. 编辑第三方 skill 前先看 `SOURCE.md`；有改动必须记录在"本地修改"小节。
3. 不向 `configs/` 写入真实密钥，只用占位符。
4. 完成修改后运行 `scripts/validate.ps1`，并按需更新 `docs/changelog.md`。
5. 不要改动 `scripts/vendor-manifest.json` 之外的 vendor 内容；更新第三方用 `scripts/pull-vendor.ps1`。

## 兼容性说明

- 本仓库 skills 采用 Codex 与 Claude Code 都能识别的结构（每个 skill 一个目录 + `SKILL.md`）。
- 同步脚本 `scripts/sync.ps1` 负责把 skills 复制到 `~/.codex/skills` 与 `~/.claude/skills`，请勿在仓库内同时维护两份重复副本。
