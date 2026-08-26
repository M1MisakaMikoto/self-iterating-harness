# Agent Lab 指导（lab.md）

本文件是 Agent Lab 的**唯一指导**（预制内容，随 harness 部署到每个项目）。全局工作规则见工作区根 `AGENTS.md` / `CLAUDE.md`；本文件只定义 lab 特有约定。

## 角色分工（避免重复）

- **指导**：本文件（`.dev/serve_agent/lab.md`），定义实验规范、词汇与维护约定。
- **实验实施位置**：`.dev/serve_project/lab/`，每个实验一个子目录；门户 `index.html` 与实验产出都在这里。
- **联系**：由工作区根 `AGENTS.md` 建立——agent 进入项目先读根规则，根规则指向本指导与实验实施位置。

## 实验约定

1. 新增/修改实验：在实验目录 `README.md` 写明目的/对照/指标/结论，证据文件与脚本同目录保存。
2. 维护门户：`serve_project/lab/index.html` 中的实验导航卡片与目录实际内容保持一致。
3. 术语：新术语先在本文件「词汇表」定义再使用；同一概念全文只用一个词。
4. 决策：难以逆转的决策写入 `serve_project/lab/docs/adr/NNNN-*.md`，格式参照 `serve_agent/skills/vendor/mattpocock-skills/domain-modeling/ADR-FORMAT.md`。
5. 图表：mermaid 一律深色主题（`%%{init: {'theme':'dark'}}%%`），禁止浅色背景。
6. lab 不引入构建工具与安装程序；门户保持零依赖静态 HTML。

## 文档写作规范

1. **结论先行**：每个文档开头一句话说清结论/用途，再展开细节。
2. **证据可追溯**：实验结论必须指向同目录证据文件（JSON/日志/report）；禁止只有结论没有证据。
3. **严禁不确定表述**：不确定的点必须查清后再写；临时结论明确标注"待验证"。
4. **命名**：目录与文件用 kebab-case（如 `tool-approval-experiment`）；正文默认中文，代码/命令/术语用英文。
5. **ADR**：编号从 `0001` 递增不复用。

## 词汇表

- **Agent Lab**：个人 agent 实验、文档规范与门户的集合。
- **实验（experiment）**：一个可复现的验证单元，包含目的、对照/步骤、指标、证据与结论；对应 `serve_project/lab/` 下一个实验子目录。
- **门户（portal）**：`serve_project/lab/index.html`，零依赖静态页面，是 lab 的导航入口。
- **证据（evidence）**：实验产生的可复核结果文件（JSON、日志、报告），用于支撑结论。
- **ADR（Architecture Decision Record）**：记录难以逆转、需要向未来读者解释的决策。
- **词汇表（glossary）**：本文件的词汇表小节；术语先在此定义再在文档中使用。

## 快速开始

```powershell
# 打开门户
.\serve_project\lab\index.html
# 或本地 HTTP 服务（markdown 链接可正常查看）
python -m http.server 8000 --directory .dev\serve_project\lab
```
