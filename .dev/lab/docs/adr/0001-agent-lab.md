# ADR-0001：将 .dev/lab 改造为 Agent Lab

- 状态：Accepted
- 日期：2026-08-25

## 背景

`.dev/lab/` 已有多个独立实验目录（agent-state、confirmation、temporal、tool-approval），但没有统一入口、文档规范与词汇表。目标是给 agent 一个可浏览、可沉淀、可复用的 lab，且个人自用场景下要求零依赖、零安装、克隆即用。

## 决策

1. **门户采用零依赖静态 HTML**（`index.html`）：单文件、内嵌 CSS/JS、无外部 CDN、无构建工具；双击或本地 HTTP 服务即可打开。
2. **文档规范统一**：`docs/norms.md` 定义写作约定；`CONTEXT.md` 作为词汇表；`docs/adr/` 记录难以逆转的决策。
3. **现有实验目录保留原位不动**：门户只做入口链接，避免移动/改写已有证据与结论。
4. **全局工作规则双轨部署**：规则事实源在 `ai-coding-configs/rules/`，通过 `sync.ps1` 部署到 `~/.codex/AGENTS.md` 与 `~/.claude/CLAUDE.md`；仓库根 `AGENTS.md` 保留同一份规则，保证项目内形态贴合。

## 后果

- 优点：零安装成本；实验与规范有统一入口；规则一处修改、多处生效。
- 代价：门户导航需人工维护与目录同步；全局规则修改后需重新运行 `sync.ps1` 才能生效。
- 后续可扩展：门户页可增加实验状态徽标、自动生成导航的小脚本（仍保持零安装，仅用 PowerShell）。
