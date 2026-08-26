# rules — 规则模板与消融模板

本目录放规则相关的**模板**（预制内容）：

- 规范**唯一真源**在项目根 `AGENTS.md` / `CLAUDE.md`（无副本、不做项目内同步），由 `sync.ps1` 部署到 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`。
- `AGENTS.template.md`：新建项目时的规则模板（框架）。
- `ABLATION.md`：更换模型时对 MAC 逐条做消融实验的模板。

## 内容边界

- **预制内容完整记录**：`AGENTS.md` / `CLAUDE.md` / skills / 配置模板等预先编写的内容，完整保留在本仓库。
- **agent 工作产物只记框架**：lab 等由 agent 工作产生的实验、报告、证据等内容，只保留结构/模板框架，具体产物留在项目本地，不提交版本库。

## UAC 与 MAC

- **UAC（用户辅助内容）**：指导如何向用户汇报与交互，跨模型稳定，更换模型时不变。
- **MAC（模型辅助内容）**：增强工作能力的方法论与纪律，与模型相关，更换模型时按 `ABLATION.md` 做消融实验。
- **存放位置（private/public 原则）**：`private/` = UAC 用户辅助内容；`public/` = MAC 模型辅助内容。本目录（rules 模板）属 UAC，位于 `private/rules/`。
