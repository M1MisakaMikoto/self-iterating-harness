# 探索路径记忆

本目录记录各工作路径的探索经验，由 path-memory 机制维护：

- 启用：探索性任务开始时创建 `.staging/.flag-<会话ID>`
- 确认与写入：任务结束时 Stop hook 发起确认对话，agent 用 2-3 行要点向你确认后直接写入 `records/`（`<slug>.md`）
- 记录写入前必须先经你确认；确认后直接写入并报告位置；不生成草稿、不二次确认

## tag 词表

纠正、决策、探索、碰壁、跑通、验证、简化、实验、失败、待定、工具、流程

新增 tag 前先查此表；确需扩展时向用户确认。

## 记录模板

frontmatter：`path` / `status`（exploration | validated | abandoned）/ `tags` / `created` / `updated`

正文分区：目标方向 / 已确认决策 / 用户纠正 / 探索路径 / 碰壁点（含原因）/ 跑通方案（步骤与依据）/ 边界条件 / 未决问题

## 搜索

```powershell
# 按 tag
powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -Tag 纠正
# 按关键词
powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -Keyword 关键词
# 列全部
powershell -NoProfile -ExecutionPolicy Bypass -File <hooks目录>/search-records.ps1 -List
# 直接 rg
rg "关键词" .dev/private/records
```

`<hooks目录>` 在 Codex 下为 `~/.codex/hooks`，在 Claude Code 下为 `~/.claude/hooks`。
