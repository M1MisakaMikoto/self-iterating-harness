# 文档写作规范（docs norms）

适用于 AgentSupport 仓库内由 agent 或人工产出的文档，重点覆盖 `.dev/lab/`。

## 1. 文档类型与位置

| 类型 | 位置 | 用途 |
|---|---|---|
| README | 目录根 `README.md` | 人类入口：目的、结构、快速开始 |
| AGENTS/CLAUDE | 目录根或 `AGENTS.md` | 给 agent 的规则；全局规则在仓库根与 `~/.codex`、`~/.claude` |
| 词汇表 | `CONTEXT.md` | 术语定义，只放词汇不放实现细节 |
| 决策记录 | `docs/adr/NNNN-*.md` | 难以逆转的架构/流程决策 |
| 变更记录 | `docs/changelog.md` | 版本与重大变更 |
| 实验记录 | 实验目录 `README.md` + 证据文件 | 可复现实验的完整叙述 |

## 2. 写作原则

1. **结论先行**：每个文档开头一句话说清结论/用途，再展开细节。
2. **术语先行**：新术语先在 `CONTEXT.md` 定义再使用；同一概念全文只用一个词。
3. **证据可追溯**：实验结论必须指向同目录证据文件（JSON/日志/report）；禁止只有结论没有证据。
4. **严禁不确定表述**：不确定的点必须查清后再写；临时结论明确标注"待验证"。
5. **变更记录**：有实质变更时更新对应 `changelog.md`，写明"改动前 → 改动后"。

## 3. 实验记录模板

每个实验目录的 `README.md` 建议包含：

```markdown
# <实验名>

## 目的
（一句话说明要回答什么问题）

## 对照/步骤
（可复现的步骤；有对照时说明对照组）

## 指标
（衡量成功的可量化指标）

## 证据
（指向 results/ 或同目录 JSON/日志，列出运行命令）

## 结论
（结论 + 仍待验证的点）
```

## 4. 图表规范

- 描述性任务优先用 mermaid 逻辑图/类图表达，避免大段文字。
- mermaid 一律深色主题，禁止浅色背景：

```mermaid
%%{init: {'theme':'dark'}}%%
flowchart LR
  A[开始] --> B[结束]
```

- 图片/图表文件放在文档同级的 `assets/` 或 `references/`。

## 5. 命名与语言

- 目录与文件命名：kebab-case（如 `tool-approval-experiment`）。
- 正文默认中文；代码、命令、术语标识符用英文。
- ADR 编号从 `0001` 递增，不复用。

## 6. 相关规范引用

- ADR 格式：`skills/vendor/mattpocock-skills/domain-modeling/ADR-FORMAT.md`
- 词汇表格式：`skills/vendor/mattpocock-skills/domain-modeling/CONTEXT-FORMAT.md`
