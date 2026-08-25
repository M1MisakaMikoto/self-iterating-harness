# CONTEXT.md — Agent Lab 词汇表

本文件只放术语定义，不包含实现细节、规范正文或决策记录。

- **Agent Lab**：`.dev/lab/` 目录，个人 agent 实验、文档规范与门户的集合。
- **实验（experiment）**：一个可复现的验证单元，包含目的、对照/步骤、指标、证据与结论；对应一个实验子目录。
- **门户（portal）**：`index.html`，零依赖静态页面，是 lab 的导航入口（前端 preview）。
- **文档规范（norms）**：`docs/norms.md` 定义的文档写作约定。
- **全局规则**：仓库根 `AGENTS.md` 及 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md` 中的 9 条工作步骤与规范。
- **薄规则**：只写局部特有约定、不重复全局规则的局部 `AGENTS.md`。
- **Skill**：AI 代理可加载的能力包，以 `SKILL.md`（含 `name`/`description` frontmatter）为核心。
- **ADR（Architecture Decision Record）**：记录难以逆转、需要向未来读者解释的决策。
- **证据（evidence）**：实验产生的可复核结果文件（JSON、日志、报告），用于支撑结论。
- **词汇表（glossary）**：本文件；术语先在此定义再在文档中使用。
