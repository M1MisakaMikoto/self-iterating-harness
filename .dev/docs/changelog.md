# 变更记录

## [0.6.1] - 2026-08-25

- 项目 `.dev` 分层更新：`private/`（服务 coding agent，不记录）与 `public/`（服务项目，记录）。
- `sync.ps1` 追加的忽略规则由 `.dev/service/` 改为 `.dev/private/`。

## [0.6.0] - 2026-08-25

- 结构重构：所有内容统一进 `.dev/`，根目录只留入口（README / AGENTS / CLAUDE / .gitignore）。
- 新增 `.dev/lab/`（Agent Lab 框架）、`.dev/preview/`（门户模板）、`.dev/plans/`（计划目录）。
- 脚本移至 `.dev/scripts/`，命令相应变为 `.\\.dev\\scripts\\...`。
- `sync.ps1` 新增安装步骤：向项目根 `.gitignore` 追加忽略规则（`.dev/service/`、`/AGENTS.md`），仅当不存在时追加。

## [0.5.0] - 2026-08-25

- 修正内容边界：预制内容（AGENTS.md / CLAUDE.md / skills）**完整记录**，恢复 `rules/AGENTS.global.md`、`rules/CLAUDE.global.md` 完整规则内容。
- `sync.ps1` 恢复全局规则部署步骤。
- 明确 agent 工作产物（lab 实验、报告、证据）只记录框架，具体内容留在项目本地。

## [0.4.0] - 2026-08-25

- 调整仓库定位：只放框架与模板，移除具体规则内容（`rules/AGENTS.global.md`、`rules/CLAUDE.global.md` 删除）。
- `rules/` 改为规则框架：新增 `README.md` 与 `AGENTS.template.md`（占位模板）。
- `sync.ps1` 移除全局规则部署步骤，只负责 skills 与配置模板。
- 具体规则内容由各项目仓库记录；全局生效时手动维护 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`。

## [0.3.0] - 2026-08-25

- 新增 `rules/AGENTS.global.md`、`rules/CLAUDE.global.md`：个人全局工作规范事实源。
- `sync.ps1` 新增全局规则部署：写入 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`，已存在时先备份再覆盖。

## [0.2.0] - 2026-08-25

- 新增第三方 skills：`mattpocock-skills` 的 `grill-with-docs` 及其依赖 `grilling`、`domain-modeling`（含 SOURCE.md 与 LICENSE）。
- `pull-vendor.ps1`：使用 OpenSSL 后端 + HTTP/1.1 提升 GitHub 连接兼容性；克隆/检出失败自动重试 3 次。
- `validate.ps1`：支持 vendor 来源组嵌套结构（组级 SOURCE.md + 组内递归校验 SKILL.md）。
- `sync.ps1`：递归发现 skills，支持 vendor 嵌套目录。

## [0.1.0] - 2026-08-25

- 初始化仓库骨架：README、AGENTS.md、CLAUDE.md、目录结构。
- 新增脚本：`sync.ps1`（同步）、`pull-vendor.ps1`（拉取第三方）、`validate.ps1`（校验）。
- 新增配置模板：Codex config、Claude settings、MCP 说明。
