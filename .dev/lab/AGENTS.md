# AGENTS.md（Agent Lab）

本目录是 Agent Lab。全局工作规则见仓库根 `AGENTS.md` 与 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`（9 条工作步骤与规范）。本文件只补充 lab 特有约定。

## Lab 特有约定

1. 新增/修改实验：按 `docs/norms.md` 的文档规范记录（README 含目的/对照/指标/结论，证据文件与脚本同目录保存）。
2. 维护门户：`index.html` 中的实验导航卡片、文档规范入口、skills 索引必须与目录实际内容保持一致。
3. 术语：新术语先写入 `CONTEXT.md` 词汇表再使用；术语冲突时以 `CONTEXT.md` 为准。
4. 决策：难以逆转的决策写入 `docs/adr/NNNN-*.md`，格式参照 `ai-coding-configs/skills/vendor/mattpocock-skills/domain-modeling/ADR-FORMAT.md`。
5. 图表：mermaid 一律使用深色主题（`%%{init: {'theme':'dark'}}%%`），禁止浅色背景。
6. 本 lab 不引入构建工具与安装程序；门户保持零依赖静态 HTML。
