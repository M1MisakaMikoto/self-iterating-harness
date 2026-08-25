# ai-coding-configs

个人 AI 编程配置仓库：AGENTS/CLAUDE 全局规则、自研与第三方 skills、工具配置模板与配套脚本。

> 本文件只是仓库入口（GitHub 主页展示）。详细说明、目录结构与使用方式见 [.dev/README.md](.dev/README.md)。

## 一句话结构

```text
.
├─ README.md / AGENTS.md / CLAUDE.md / .gitignore   # 根只留入口
└─ .dev/                                            # 所有内容
   ├─ lab/       # Agent Lab 框架（规范、词汇表、ADR）
   ├─ preview/   # 前端 preview 模板（门户页）
   ├─ plans/     # 计划目录
   ├─ rules/     # 全局工作规范（完整）+ 模板
   ├─ skills/    # 自研 + 第三方 skills（完整）
   ├─ configs/   # Codex / Claude / MCP 配置模板
   ├─ scripts/   # sync / validate / pull-vendor（零安装）
   └─ docs/      # usage / changelog
```

快速开始：`.\\.dev\\scripts\\validate.ps1` 校验，`.\\.dev\\scripts\\sync.ps1` 一键部署到本机。
