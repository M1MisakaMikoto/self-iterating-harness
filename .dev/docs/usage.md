# 使用说明

## 首次使用

```powershell
# 克隆到本地（示例）
git clone https://github.com/<USER>/ai-coding-configs.git
cd ai-coding-configs

# 校验结构
.\\.dev\\scripts\\validate.ps1

# 一键同步到本机：skills + 全局规则 + 配置模板（零安装，仅需 PowerShell 与 git）
.\\.dev\\scripts\\sync.ps1
```

`sync.ps1` 会把 `.dev/rules/AGENTS.global.md`、`.dev/rules/CLAUDE.global.md` 部署为
`~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md`，对所有项目生效。目标文件已存在时会先备份为
`.bak-<时间戳>` 再覆盖。

`sync.ps1` 还会向**所在项目**的根 `.gitignore` 追加忽略规则（仅当不存在时）：

```text
# ai-coding-configs sync 自动追加
.dev/service/
/AGENTS.md
```

即：服务于 coding agent 的内容（`.dev/service/`）与项目根 `AGENTS.md` 不记录；lab 等 agent 产出内容不被忽略、自动记录。

### 内容边界

- **预制内容完整记录**：AGENTS.md / CLAUDE.md / skills / 配置模板等预先编写的内容完整保留。
- **agent 工作产物只记框架**：lab 等 agent 工作产生的实验、报告、证据等只保留结构/模板框架，具体产物留在项目本地，不提交版本库。

## 日常操作

### 新增一个自研 skill

1. 在 `.dev/skills/my/` 下新建 `kebab-case-name/` 目录。
2. 创建 `SKILL.md`，frontmatter 至少包含 `name` 与 `description`。
3. 需要的话补充 `references/`、`scripts/`、`assets/`。
4. 运行 `.\\.dev\\scripts\\validate.ps1` 校验，然后提交。

### 拉取第三方 skill

1. 编辑 `.dev/scripts/vendor-manifest.json`，添加来源条目（url、commit、skills 路径）。
2. 运行 `.\\.dev\\scripts\\pull-vendor.ps1 -Name <来源名>`。
3. 检查生成的 `SOURCE.md` 与 LICENSE，确认许可证后再提交。

### 同步到新机器

`sync.ps1` 会把：

- `.dev/skills/my`、`.dev/skills/vendor` 下所有合法 skill 复制到 `~/.codex/skills` 与 `~/.claude/skills`；
- `.dev/configs/codex/*` 复制到 `~/.codex/`（仅当目标文件不存在）；
- `.dev/configs/claude/*` 复制到 `~/.claude/`（仅当目标文件不存在）。

如需"改一处全生效"的链接模式，可改用 junction：

```powershell
New-Item -ItemType Junction -Path "$HOME\.codex\skills" -Target "<仓库路径>\skills"
```

## 发布到 GitHub

在 GitHub 新建空仓库（不要勾选初始化 README），然后：

```powershell
git remote add origin https://github.com/<USER>/ai-coding-configs.git
git branch -M main
git push -u origin main
```

### 国内访问加速（可选）

在 Gitee 建同名仓库后，把 GitHub 作为 origin、Gitee 作为 mirror：

```powershell
git remote add mirror https://gitee.com/<USER>/ai-coding-configs.git
git push mirror --all
git push mirror --tags
```

## 安全注意事项

- 真实密钥、token 一律不入库（`.gitignore` 已排除 `.env*`、`*.local.*`）。
- `.dev/configs/` 只放模板与占位符。
- 从不可信来源拉取 skill 时，先读 `SKILL.md` 与 `scripts/`，确认不会执行危险操作。
