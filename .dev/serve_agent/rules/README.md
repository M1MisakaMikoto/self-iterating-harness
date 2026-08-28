# rules — 规则模板与消融模板

本目录放规则相关的**模板**（预制内容）：

- 规范**唯一真源**在项目根 `AGENTS.md`（无副本、不做项目内同步），由 `sync.ps1` 部署到 `~/.codex/AGENTS.md`。
- `AGENTS.template.md`：新建项目时的规则模板（框架）。
- `ABLATION.md`：更换模型时对 MAC 逐条做消融实验的模板。

## 内容边界

- **预制内容完整记录**：`AGENTS.md` / `CLAUDE.md` / skills / 配置模板等预先编写的内容，完整保留在本仓库。
- **agent 工作产物**：lab 实验、报告、证据等位于工作区根 `.dev/serve_project/lab/`，由 harness 仓库记录（如需按"只记框架"收窄，可另行清理）。

## UAC 与 MAC

- **UAC（用户辅助内容）**：指导如何向用户汇报与交互，跨模型稳定，更换模型时不变。
- **MAC（模型辅助内容）**：增强工作能力的方法论与纪律，与模型相关，更换模型时按 `ABLATION.md` 做消融实验。

## serve_agent/serve_project 分级标准（必读，勿凭记忆）

- 目录分类按**服务对象**，与 UAC/MAC 无关：
  - `serve_agent/` = **服务 coding agent**（本仓库跟踪、项目忽略）：`rules`、`skills`、`scripts`、`configs`、`records`、`lab.md`（指导）。
  - `serve_project/` = **agent 产出、服务项目**：`docs`、`preview`、`plans`、`lab`（实验实施）。
- **UAC / MAC 是规则/提示词内容的分类**（见项目根 `AGENTS.md` / `CLAUDE.md` 内部分区；换模型对 MAC 做 `ABLATION.md` 消融），**不是目录分类**，不要把 UAC/MAC 标签贴在目录上。
- `AGENTS.md`：只有项目根一份（规则唯一真源，由 harness 仓库跟踪），`.dev/` 内不放。
- 工作区根是 harness 仓库（跟踪 `AGENTS.md` / `CLAUDE.md` / `.dev/**`）；项目代码仓库位于工作区根下的同名子目录（如 `AgentSupport\AgentSupport`），只跟踪代码、不含 `.dev`。
- 新增内容先按"服务谁"分类：给 coding agent 用的进 `serve_agent/`，agent 产出/服务项目的进 `serve_project/`。
