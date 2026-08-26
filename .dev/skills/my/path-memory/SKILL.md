---
name: path-memory
description: 探索路径记忆的启用、总结与检索。用于判断任务是否带探索性质并启用路径记忆 hook、在 Stop hook 提醒后撰写探索记录草稿、搜索历史记录并按已确认决策/纠正比对优化。适用于开始探索性任务、任务结束被要求总结、或需要检索过往探索记录时。
---

# path-memory

## 目标

把"这次是怎么探到这里的"沉淀下来：目标方向、已确认决策、用户纠正、探索路径、碰壁点、跑通方案、边界条件。记录位于 `.dev/private/records/<路径slug>.md`，**草稿经用户确认后才写入**。

## 何时启用（agent 自行判断）

任务带**探索性质**时启用：新领域/不熟悉的技术、方案未定需要比较、预期会碰壁、需要多路径尝试、用户明确说"探索/调研/实验"。

例行任务不启用：纯问答、已跑通的重复改动、明确的单点修复。

## 如何启用 / 停用

- 启用：创建标记文件 `<项目>/.dev/private/records/.staging/.flag-<会话ID>`（内容任意，目录不存在就创建）。会话 ID 来自 SessionStart hook 注入的 `[path-memory] 会话ID=...`。
- 停用：任务中途反悔时删除该标记。
- 启用后**专心工作、不边干边记**；任务结束时 Stop hook 会自动发起一次总结对话。

## 总结（Stop hook 提醒后）

按模板写草稿到 `.staging/`：

- 新探索：`<slug>.md.candidate`
- 已有记录：`<slug>.update.md`，并列出相对旧记录的改动点

写完创建完成标记 `.staging/.done-<会话ID>`，然后向用户展示草稿要点并询问是否写入 `records/`。用户确认才写；拒绝则删除草稿与标记。

### 模板

frontmatter：`path` / `status`（exploration | validated | abandoned）/ `tags` / `created` / `updated`

正文分区：目标方向 / 已确认决策 / 用户纠正 / 探索路径 / 碰壁点（含原因）/ 跑通方案（步骤与依据）/ 边界条件 / 未决问题

### tag 词表（新增前先查，避免泛滥）

纠正、决策、探索、碰壁、跑通、验证、简化、实验、失败、待定、工具、流程

## 检索历史记录

1. 先看 SessionStart 注入的本路径摘要（若有）。
2. 按 tag：`powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -Tag 纠正`
3. 按关键词：`powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -Keyword 关键词`
4. 列全部：`powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -List`
5. 直接 rg：`rg "关键词" .dev/private/records`

`records/README.md` 内有词表、模板与命令速查。

## 开工前比对

若本路径已有记录：先读摘要，遵循其中"已确认决策"与"用户纠正"；尝试复用跑通方案、避免重走碰壁路径；若发现记录可简化或方向已变，在任务结束后提出修改草稿，经用户确认后更新。
