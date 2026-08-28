# self-iterating-harness

自迭代 AI Coding Harness：coding agent 在项目工作中沉淀路径记忆，经用户确认后提炼为规则、skills 与配置。

## 工作区布局

```text
<工作区>/
├─ .git/                       # harness 仓库
├─ AGENTS.md / CLAUDE.md       # 规则真源
├─ .agents/skills/             # Codex 项目级 skill 入口
├─ .codex/hooks.json           # Codex 项目级 hooks
├─ .dev/
│  ├─ README.md / .gitignore
│  ├─ serve_agent/             # 可复用框架，harness 仓库跟踪
│  │  ├─ docs/                 # harness 使用与变更说明
│  │  ├─ rules/                # 规则模板与消融规范
│  │  ├─ skills/               # skill 真源
│  │  ├─ scripts/              # hooks、校验与同步脚本
│  │  ├─ configs/              # 配置模板
│  │  └─ templates/            # 项目产物模板
│  └─ serve_project/           # 当前项目本地产物，harness 仓库忽略
│     ├─ records/              # 路径记忆
│     ├─ plans/                # 计划
│     └─ lab/                  # 实验、报告与证据
└─ <项目名>/                   # 独立项目仓库
   ├─ .git/
   └─ src/ tests/ ...
```

工作区根的 harness 仓库通过 `.git/info/exclude` 排除项目子目录；项目仓库位于子目录，因此不会看到外层 `.dev/`。`serve_project/` 由 `.dev/.gitignore` 排除，不被任一仓库跟踪。

## 自迭代闭环

1. SessionStart hook 从 `.dev/serve_project/records/` 注入当前路径的既有记录摘要。
2. 探索任务结束时，Stop hook 先请求用户确认，再写入本地记录。
3. 经用户确认，将可跨项目复用的结论提炼到 `AGENTS.md`、`serve_agent/skills/` 或配置中。
4. harness 变更由外层仓库提交并在不同项目工作区间同步。

## 使用

```powershell
# 校验 harness 结构与跟踪边界
.\.dev\serve_agent\scripts\validate.ps1

# 查看外层 harness 仓库
.\.dev\serve_agent\scripts\hgit.ps1 status

# 查看内层项目仓库
git -C <项目名> status
```

项目级 hooks 首次加载或脚本变更后，在 Codex `/hooks` 中审查并信任。此布局不要求运行全局 `sync.ps1`，也不会修改 `~/.codex` 或 `~/.claude`。

详细说明见 [使用说明](serve_agent/docs/usage.md)。
