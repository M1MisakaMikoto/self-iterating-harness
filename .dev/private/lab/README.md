# Agent Lab（框架）

本目录是 Agent Lab 的**框架**（预制模板，完整记录）：规范、词汇表、决策记录与维护约定。本目录即 `<项目>/.dev/private/lab/`（本仓库与项目混合在同一目录，服务 coding agent，归 private）。

实际由 agent 工作产生的实验、报告、证据等**具体内容**不放在本仓库，留在项目 `.dev/public/lab/`（由项目仓库记录）。

## 目录

```text
private/lab/
├─ AGENTS.md            # lab 内 agent 约定（薄规则）
├─ CONTEXT.md           # 词汇表（只放术语定义）
├─ README.md            # 本文件
└─ docs/
   ├─ norms.md          # 文档写作规范
   └─ adr/              # 架构决策记录
```

使用方式：框架内容已就位（`<项目>/.dev/private/lab/`），无需复制；具体实验内容放到项目 `.dev/public/lab/`。
