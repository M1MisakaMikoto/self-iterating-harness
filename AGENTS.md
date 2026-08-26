# AGENTS.md

本文件面向在**本仓库**中工作的 AI 编程代理（Codex、Claude Code 等）。本仓库根即 `<项目>/.dev/`。它定义仓库的用途、布局和维护约定。

## 仓库用途

这是自迭代 AI Coding Harness 仓库：与项目**混合在同一目录**（本仓库根 = 项目 `.dev/`），自迭代闭环由 path-memory 路径记忆、UAC/MAC 规则与消融实验、lab 实验、sync 部署构成：

- 全局工作规范（`rules/`，完整记录）
- 自研 skills（`skills/my/`）
- 从社区拉取的第三方 skills（`skills/vendor/`）
- Codex / Claude Code / MCP 等工具配置模板（`configs/`）
- Agent Lab 框架（`lab/`）、门户模板（`preview/`）、计划（`plans/`）

本仓库不包含任何项目业务代码，也不包含真实密钥；项目侧内容（`private/`、`public/`）不归本仓库跟踪。

## 目录布局

| 路径 | 内容 | 维护要求 |
|---|---|---|
| `README.md` / `AGENTS.md` / `CLAUDE.md` / `.gitignore` | 本仓库入口 | 保持精简，详细内容在 `README.md` |
| `rules/` | 个人全局工作规范（完整）+ 规则模板 | 修改后运行 `scripts/sync.ps1` 部署到 `~/.codex/AGENTS.md`、`~/.claude/CLAUDE.md` |
| `skills/my/` | 自研 skills | 每个 skill 一个子目录，含 `SKILL.md` |
| `skills/vendor/` | 第三方 skills | 按来源分组，每组必须含 `SOURCE.md` |
| `configs/` | 工具配置模板 | 只用占位符，禁止真实密钥 |
| `scripts/` | 同步/校验/拉取脚本 | PowerShell，基于本仓库根（项目 `.dev/`）的相对路径 |
| `lab/` `preview/` `plans/` | Lab 框架 / 门户模板 / 计划 | 预制框架完整记录；agent 产物具体内容不入库 |
| `docs/` | 使用说明与变更记录 | 有实质变更时更新 `changelog.md` |

## 与项目仓库的分离组合

- 本仓库 git 元数据在 `<项目>/.dev/.git`，项目仓库 git 元数据在 `<项目>/.git`，两者工作区混合在同一目录。
- 分离靠两仓库各自的 ignore 配置：
  - 项目 `.gitignore`：`.dev/*` + `!.dev/public/**`（项目只记录业务代码与 `.dev/public/`）。
  - 本仓库 `.gitignore`：`private/`、`public/`（项目侧内容不归本仓库）。
- 在本仓库根（`<项目>/.dev/`）执行 `git` 命令操作本仓库；在项目根执行 `git` 命令操作项目仓库。

## 内容边界

- 预制内容（AGENTS.md / CLAUDE.md / skills / 配置模板 / lab 框架）**完整记录**在本仓库。
- agent 工作产物（实验、报告、证据等）**只记录框架**，具体内容留在项目本地不提交。

## 全局规则维护

- `rules/AGENTS.global.md`、`rules/CLAUDE.global.md` 是个人全局工作规范，修改后运行 `scripts/sync.ps1` 部署。
- 目标文件已存在时先备份 `.bak-<时间戳>` 再覆盖。

## 新增/修改 skill 的规则

1. 自研 skill 放在 `skills/my/<skill-name>/`；第三方 skill 放在 `skills/vendor/<来源>/<skill-name>/`，并维护 `SOURCE.md`。
2. 每个 skill 目录必须包含：
   - `SKILL.md`：frontmatter 至少包含 `name` 与 `description`，正文写清楚适用场景、工作流程、输入输出与边界。
   - 可选 `references/`（补充文档）、`scripts/`（辅助脚本）、`assets/`（资源文件）。
3. `SKILL.md` 保持精简：详细内容放 `references/`，可执行逻辑放 `scripts/`。
4. 目录命名用 kebab-case（如 `docs-helper`）。
5. 修改后运行 `scripts/validate.ps1` 确认结构合法。

## 维护第三方 skills 的规则

- 未经确认许可，不修改第三方 skill 内容；确需修改时，在 `SOURCE.md` 的"本地修改"小节说明。
- `SOURCE.md` 必须记录：来源仓库 URL、拉取时的 commit、许可证、拉取日期。
- 保留原仓库的 LICENSE 文件。
- 批量更新用 `scripts/pull-vendor.ps1`（按 `scripts/vendor-manifest.json` 执行），不直接手改 vendor 内容。

## 配置模板规则

- `configs/` 下文件均为模板：路径、模型名、命令等用占位符（如 `<YOUR_API_KEY>`）。
- 不得写入 token、密码、私钥。
- 新增工具配置时，在对应子目录（`codex/`、`claude/`、`mcp/`）下添加模板并更新说明。

## Git 约定

- 默认分支 `main`。
- 提交信息用简洁的祈使句，可加前缀：`feat:`、`fix:`、`docs:`、`chore:`。
- 提交前运行 `scripts/validate.ps1`。
- 不要提交 `scripts/tmp/`、`.env*`、`*.local.*` 等被忽略的文件。

## 常用命令（在本仓库根目录执行）

```powershell
.\scripts\validate.ps1        # 校验 skills 结构
.\scripts\sync.ps1            # 部署到本机 ~/.codex、~/.claude
.\scripts\sync.ps1 -DryRun    # 预览同步
.\scripts\sync.ps1 -Hooks     # 额外安装 path-memory hooks 与记录目录
.\scripts\pull-vendor.ps1     # 按 manifest 拉取第三方 skills
```
