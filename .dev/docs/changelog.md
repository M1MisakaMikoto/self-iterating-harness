# 变更记录

## [0.9.1] - 2026-08-26

- 调整记录确认点：由"草稿 → 确认 → 写入"改为"先确认 → 直接写入"。Stop hook 提醒后 agent 用 2-3 行要点询问，确认后直接写入 `records/` 并报告位置；不生成草稿、不二次确认，减少 token 消耗。

## [0.9.0] - 2026-08-26

- 新增 path-memory 探索路径记忆：hook 驱动，agent 判断任务带探索性质时自行启用（创建会话标记），任务结束后 Stop hook 自动发起总结对话，草稿经用户确认后才写入 `.dev/private/records/`。
- 新增 hook 脚本：`scripts/hooks/session-start.ps1`（注入会话 ID/待确认草稿/历史摘要）、`stop-hook.ps1`（触发续写总结）、`search-records.ps1`（按 tag/关键词检索）。
- 新增 `skills/my/path-memory` skill：启用判断、总结模板、tag 词表、检索与比对方法。
- `sync.ps1` 新增 `-Hooks` 一键安装：部署 hook 脚本、写入 `~/.codex/hooks.json`、合并 `~/.claude/settings.json`、初始化项目 records 目录。
- UAC 新增第 10 条：写入探索记录前必须先经用户确认；MAC 调整第 4 条（纠正由 hook 捕获）、新增第 9 条（探索性任务启用路径记忆）。

## [0.8.0] - 2026-08-26

- UAC 新增"报告结构"：报告问题或任务结果时按 4 点结构——能做到什么 / 为什么能做到 / 什么情况下做不到 / 怎么确保说到的都做到了。

## [0.7.0] - 2026-08-26

- 全局规则按 **UAC / MAC** 分区：UAC（用户辅助内容，跨模型稳定）与 MAC（模型辅助内容，换模型需消融）。
- 混合规则（最小验证、纠正记录、兜底、变更范围）拆分为 UAC 交互侧与 MAC 工作侧子条。
- 新增 `rules/ABLATION.md`：更换模型时对 MAC 逐条消融实验的模板。

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
