# 使用说明

## 首次建立工作区

1. 将 `self-iterating-harness` 克隆为工作区根。
2. 将项目仓库放入工作区根的同名子目录。
3. 在 harness 仓库的 `.git/info/exclude` 中加入 `/<项目名>/`。
4. 运行 `.\.dev\serve_agent\scripts\validate.ps1`。
5. 启动 Codex 后使用 `/hooks` 审查并信任项目级 hooks。

`.codex/hooks.json` 直接调用 `.dev/serve_agent/scripts/hooks/`，`.agents/skills/` 提供项目级 skill 入口。无需向用户目录复制规则、skills 或 hooks。

## 内容边界

- `AGENTS.md`、`.agents/`、`.codex/`、`.dev/serve_agent/`：可复用 harness 框架，由外层仓库跟踪。
- `.dev/serve_project/`：当前项目的 records、plans、lab、报告与证据，仅保存在本地工作区。
- `<项目名>/`：独立项目仓库，由外层 harness 仓库在 `.git/info/exclude` 中排除。

框架模板位于 `.dev/serve_agent/templates/serve_project/`。初始化项目产物目录时复制模板，不把实例内容提交到 harness 仓库。

## 路径记忆

- 记录目录：`.dev/serve_project/records/`
- 会话标记：`.dev/serve_project/records/.staging/`
- 默认不动作；探索性任务才创建 `.flag-<会话ID>`。
- Stop hook 发现标记后请求一次确认；同意后直接写记录，拒绝则不写。
- 记录只保存在本地，不随任一仓库 clone、pull 或 push。

检索：

```powershell
.\.dev\serve_agent\scripts\hooks\search-records.ps1 -List
.\.dev\serve_agent\scripts\hooks\search-records.ps1 -Tag 纠正
.\.dev\serve_agent\scripts\hooks\search-records.ps1 -Keyword 关键词
```

## 可选全局部署

`sync.ps1` 保留给确实需要全局 Codex/Claude 配置的环境。本项目级布局不运行它，避免覆盖 `~/.codex/AGENTS.md`、写入全局 hooks 或安装 Claude 配置。

## 安全

- 密钥、token、records 与项目实验不得提交到 harness 仓库。
- 第三方 skill 必须保留来源、commit 与许可证信息。
- 提交 harness 变更前运行 `validate.ps1`，确保没有 `serve_project` 实例文件被跟踪。
