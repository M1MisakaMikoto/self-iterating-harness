# rules — 规则框架（不含具体内容）

本目录只放"如何组织规则"的框架与模板，**不存放具体规则内容**。

具体内容（个人工作规则、项目约定等）记录在对应项目仓库：

- 项目根 `AGENTS.md` / `CLAUDE.md`：项目级具体内容。
- 需要全局生效时，将内容手动维护于 `~/.codex/AGENTS.md`（Codex）与 `~/.claude/CLAUDE.md`（Claude Code）。

## 使用方式

1. 复制 `AGENTS.template.md` 到项目根并命名为 `AGENTS.md`，把占位符替换为项目具体规则。
2. 如需全局生效，将最终内容复制到 `~/.codex/AGENTS.md` 与 `~/.claude/CLAUDE.md`。
3. 本仓库的 `scripts/` 只负责技能与配置模板的部署，不托管具体规则内容。
