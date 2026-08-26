# CLAUDE.md

这是给 Claude Code 的仓库级说明。先读本文件，再处理任何任务。

## 这是什么仓库

自迭代 AI Coding Harness：个人 AI 编程框架（自研/第三方 skills、Codex/Claude Code/MCP 配置模板、全局规则、Lab 框架与门户模板、配套脚本）与自迭代机制（path-memory 路径记忆、规则消融、lab 实验），所有内容在 `.dev/` 下，仓库本身没有业务代码，也不含密钥。

## 布局速览

- `.dev/skills/my/<name>/SKILL.md`：自研 skill，frontmatter 必须含 `name` 与 `description`。
- `.dev/skills/vendor/<来源>/`：第三方 skills，目录内必须含 `SOURCE.md` 记录来源。
- `.dev/rules/AGENTS.global.md`、`CLAUDE.global.md`：全局工作规范，由 sync 部署。
- `.dev/configs/claude/settings.json`：Claude 权限模板（allow/ask/deny 示例）。
- `.dev/docs/usage.md`：人类使用说明；`.dev/docs/changelog.md`：变更记录。

## 关键规则

1. 新增 skill：确认放 `my/` 还是 `vendor/`；保持标准结构（`SKILL.md` + 可选 `references/`、`scripts/`、`assets/`）。
2. 编辑第三方 skill 前先看 `SOURCE.md`；有改动必须记录在"本地修改"小节。
3. 不向 `.dev/configs/` 写入真实密钥，只用占位符。
4. 完成修改后运行 `.dev/scripts/validate.ps1`，并按需更新 `.dev/docs/changelog.md`。
5. 不要改动 `.dev/scripts/vendor-manifest.json` 之外的 vendor 内容；更新第三方用 `.dev/scripts/pull-vendor.ps1`。
6. 预制内容完整记录；agent 工作产物只记录框架，具体内容留在项目本地。

## 兼容性说明

- 本仓库 skills 采用 Codex 与 Claude Code 都能识别的结构（每个 skill 一个目录 + `SKILL.md`）。
- 同步脚本 `.dev/scripts/sync.ps1` 负责把 skills 复制到 `~/.codex/skills` 与 `~/.claude/skills`，请勿在仓库内同时维护两份重复副本。
