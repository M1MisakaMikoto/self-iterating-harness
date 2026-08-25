# skills/my — 自研 skills

每个子目录是一个独立 skill，结构如下：

```text
my/<skill-name>/
├─ SKILL.md        # 必选：frontmatter(name, description) + 工作流程正文
├─ references/     # 可选：补充文档
├─ scripts/        # 可选：辅助脚本
└─ assets/         # 可选：模板/资源
```

命名用 kebab-case。新增后运行 `..\..\scripts\validate.ps1` 校验。

示例目录（可复制后改名）：

```text
docs-helper/
├─ SKILL.md
├─ references/
│  └─ checklist.md
└─ scripts/
   └─ lint-docs.ps1
```
