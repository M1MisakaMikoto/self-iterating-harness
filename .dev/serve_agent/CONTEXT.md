# CONTEXT.md — Agent Lab 词汇表

本文件只放术语定义，不包含实现细节、规范正文或决策记录（决策记录见 `serve_project/lab/docs/adr/`）。由 domain-modeling / grill-with-docs 在对话中就地更新，术语一确定即写入。

- **Agent Lab**：个人 agent 实验、文档规范与门户的集合。
- **实验（experiment）**：一个可复现的验证单元，包含目的、对照/步骤、指标、证据与结论；对应 `serve_project/lab/` 下一个实验子目录。
- **门户（portal）**：`serve_project/lab/index.html`，零依赖静态页面，是 lab 的导航入口。
- **证据（evidence）**：实验产生的可复核结果文件（JSON、日志、报告），用于支撑结论。
- **ADR（Architecture Decision Record）**：记录难以逆转、需要向未来读者解释的决策。
- **词汇表（glossary）**：本文件；术语先在此定义再在文档中使用。
