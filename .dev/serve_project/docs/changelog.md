# 变更记录

## [0.16.0] - 2026-08-26

- 目录改名：`private/` → `serve_agent/`、`public/` → `serve_project/`（按服务对象命名）。
- Agent Lab 去重：删除 `serve_agent/lab/` 框架目录，新建 `serve_agent/lab.md` 作为唯一指导；`serve_project/lab/` 为实验实施位置；两者由根 `AGENTS.md` 建立联系。
- 全量更新引用（AGENTS.md / CLAUDE.md / sync.ps1 / hooks / path-memory / rules / docs / 门户）。

## [0.15.0] - 2026-08-26

- 按修正后的 private/public 分级标准调整：`skills` / `scripts` / `configs` 从 public 移回 private（服务 coding agent）；`docs` 从 private 移到 public（服务项目/产出）；删除 private 内的 `AGENTS.md` / `CLAUDE.md`（规则只有项目根一份）。
- 修正标签：**UAC/MAC 是规则/提示词内容的分类，不用于目录**；目录按服务对象分（private=服务 agent，public=产出/服务项目）。分级标准写入 `private/rules/README.md`，不再凭记忆。

## [0.14.0] - 2026-08-26

- **仓库独立、根同目录**：harness 仓库 git 元数据移至项目根 `.git-harness`，工作根指向项目根（与项目仓库同目录）；harness 文件仍混在 `.dev/`（private=UAC / public=MAC）。
- 根 `AGENTS.md` / `CLAUDE.md` 由 harness 仓库直接跟踪（无副本、无项目内同步）。
- 分离规则移到各仓库 `info/exclude`（项目忽略 `.dev/*` 仅保留 public、忽略 AGENTS/CLAUDE；harness 忽略项目代码与自身 gitdir），根 `.gitignore` 只放通用规则。
- 新增 `hgit.ps1`：在项目根快捷运行 harness 仓库 git。

## [0.13.1] - 2026-08-26

- 规则去副本：`AGENTS.md` / `CLAUDE.md` 就是项目根的**唯一真源**，无副本、不做项目内同步；`private/rules/` 只保留模板与 ABLATION。
- `sync.ps1` 直接部署项目根 `AGENTS.md` / `CLAUDE.md` 到 `~/.codex`、`~/.claude`。

## [0.13.0] - 2026-08-26

- **记录 private/public 原则（勿忘）**：`private/` = 服务 coding agent 的内容；`public/` = agent 产出、服务项目的内容。（UAC/MAC 是规则提示词内容的分类，不用于目录；此前的 UAC/MAC 目录标签表述有误，已在此修正。）
- 内容归类：private ← rules / docs / lab 框架（+ AGENTS / CLAUDE 工作指南）；public ← skills / configs / scripts / preview / plans（+ 项目实验）。
- 跟踪：private 为分离区（仅 harness 仓库跟踪、项目忽略）；public 为组合区（项目仓库与 harness 仓库都跟踪）。

## [0.12.0] - 2026-08-26

- 按 private/public 原则收纳：harness 内容（服务 coding agent：rules/skills/configs/scripts/docs/lab 框架/preview 模板/plans 框架）全部进 `private/`（本仓库跟踪、项目忽略）；`public/` 只放服务项目/产出的内容（实验、门户、计划，项目跟踪、本仓库忽略）。
- 项目私有内容（`private/records/`、`private/skills/docs-writing/`、`private/skills/review/`）两仓库都不跟踪；命令与文档路径更新为 `private/scripts/...`。

## [0.11.0] - 2026-08-26

- 仓库根迁移至项目 `.dev/`：harness 与项目**混合在同一目录**，项目 `.git` 与 harness `.dev/.git` 两个 git 仓库同时可见，靠 ignore 配置分离组合（项目忽略 `.dev/*` 仅保留 `public/**`，本仓库忽略 `private/`、`public/`）。
- 内部路径全部改为新根相对路径（`rules/`、`skills/`、`configs/`、`scripts/`、`lab/` 等）；项目 lab 门户链接、AGENTS 权威路径同步更新。

## [0.10.2] - 2026-08-26

- 恢复与项目"混合在同一目录"的布局：harness 仓库嵌套于项目根（`<项目>/self-iterating-harness/`），与项目文件同目录；撤销同级放置方案。
- 项目忽略规则、lab 门户链接、AGENTS 权威路径同步恢复为嵌套形态；内部文档路径保持仓库相对 `.dev/...`。

## [0.10.1] - 2026-08-26

- 仓库移出项目目录，与项目同级放置（`D:\dev\projects\self-iterating-harness` 与 `D:\dev\projects\<项目>` 并列），项目内不再嵌套 config 仓库。
- 内部文档路径改为仓库相对 `.dev/...`；项目 lab 门户链接与忽略规则同步更新。

## [0.10.0] - 2026-08-26

- 仓库重定位为"自迭代 AI Coding Harness"并更名 `self-iterating-harness`：自迭代即已有机制（path-memory 路径记忆、UAC/MAC 规则 + ABLATION 消融、lab 实验、sync 部署），不新增额外逻辑。
- 全量更新引用路径（项目 `.gitignore`、lab 门户链接、文档路径、usage 占位 URL、sync 注释）。

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
