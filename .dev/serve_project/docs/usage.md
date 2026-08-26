# 使用说明

本仓库是自迭代 AI Coding Harness：配置是"现状"，path-memory 路径记忆与规则消融是"演进"，sync 是"部署"。

## 首次使用

```powershell
# 克隆到本地（示例）
git clone https://github.com/M1MisakaMikoto/self-iterating-harness.git <工作区>
cd <工作区>/.dev

# 校验结构
.\serve_agent\scripts\validate.ps1

# 一键同步到本机：skills + 全局规则 + 配置模板（零安装，仅需 PowerShell 与 git）
.\serve_agent\scripts\sync.ps1
```

`sync.ps1` 会把工作区根 `AGENTS.md`、`CLAUDE.md`（规则唯一真源，无副本）部署为
`~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`，对所有项目生效。目标文件已存在时会先备份为
`.bak-<时间戳>` 再覆盖。

`sync.ps1` 还会向**所在项目**的根 `.gitignore` 追加忽略规则（仅当不存在时）：

```text
# self-iterating-harness sync 自动追加
.dev/serve_agent/
/AGENTS.md
```

即：服务于 coding agent 的内容（`.dev/serve_agent/`）与工作区根 `AGENTS.md` 不随项目代码仓库记录；项目代码仓库在同名子目录只跟踪代码；`.dev/serve_project/` 的 lab 实验、计划等由 harness 仓库记录。

## 探索路径记忆（path-memory hooks）

```powershell
# 一键安装 hooks：部署脚本 + 写入 Codex hooks.json + 合并 Claude settings.json + 初始化项目 records 目录
.\serve_agent\scripts\sync.ps1 -Hooks
# 先预览
.\serve_agent\scripts\sync.ps1 -Hooks -DryRun
```

工作机制：

- 默认不动作。agent 判断任务带**探索性质**（新领域/方案未定/多路径尝试/预期碰壁）时，创建 `.dev/serve_agent/records/.staging/.flag-<会话ID>` 启用。
- 任务结束 Stop hook 检测到标记，发起一次确认对话；agent 用 2-3 行要点询问是否记录。
- 你确认后 agent 直接写入 `.dev/serve_agent/records/<路径slug>.md` 并报告位置；拒绝则不写。不生成草稿、不二次确认。

注意：

- Codex 交互模式首次使用需在 `/hooks` 中审查并信任新 hook；脚本内容变更后也需重新信任。
- 无头/自动化模式（`codex exec`）可加 `--dangerously-bypass-hook-trust` 在本次调用中跳过信任。
- 记录、草稿、标记均在 `.dev/serve_agent/`（git 忽略），不入项目仓库，不随 config 仓库同步；换机器时本机重跑 `sync.ps1 -Hooks` 即可重建机制，记录需自行迁移。

### 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留。
- **agent 工作产物**：lab 实验、报告、证据等位于 `.dev/serve_project/lab/`，由 harness 仓库记录（如需按"只记框架"收窄，可另行清理）。

## 日常操作

### 新增一个自研 skill

1. 在 `serve_agent/skills/my/` 下新建 `kebab-case-name/` 目录。
2. 创建 `SKILL.md`，frontmatter 至少包含 `name` 与 `description`。
3. 需要的话补充 `references/`、`scripts/`、`assets/`。
4. 运行 `.\serve_agent\scripts\validate.ps1` 校验，然后提交。

### 拉取第三方 skill

1. 编辑 `serve_agent/scripts/vendor-manifest.json`，添加来源条目（url、commit、skills 路径）。
2. 运行 `.\serve_agent\scripts\pull-vendor.ps1 -Name <来源名>`。
3. 检查生成的 `SOURCE.md` 与 LICENSE，确认许可证后再提交。

### 同步到新机器

`sync.ps1` 会把：

- `serve_agent/skills/my`、`serve_agent/skills/vendor` 下所有合法 skill 复制到 `~/.codex/skills` 与 `~/.claude/skills`；
- `serve_agent/configs/codex/*` 复制到 `~/.codex/`（仅当目标文件不存在）；
- `serve_agent/configs/claude/*` 复制到 `~/.claude/`（仅当目标文件不存在）。

如需"改一处全生效"的链接模式，可改用 junction：

```powershell
New-Item -ItemType Junction -Path "$HOME\.codex\skills" -Target "<工作区>\.dev\serve_agent\skills"
```

## 发布到 GitHub

在 GitHub 新建空仓库（不要勾选初始化 README），然后：

```powershell
git remote add origin https://github.com/M1MisakaMikoto/self-iterating-harness.git
git branch -M main
git push -u origin main
```

### 国内访问加速（可选）

在 Gitee 建同名仓库后，把 GitHub 作为 origin、Gitee 作为 mirror：

```powershell
git remote add mirror https://gitee.com/<USER>/self-iterating-harness.git
git push mirror --all
git push mirror --tags
```

## 安全注意事项

- 真实密钥、token 一律不入库（`.gitignore` 已排除 `.env*`、`*.local.*`）。
- `serve_agent/configs/` 只放模板与占位符。
- 从不可信来源拉取 skill 时，先读 `SKILL.md` 与 `scripts/`，确认不会执行危险操作。
