# skills/vendor — 第三方 skills

按**来源仓库**分组存放：`vendor/<来源名>/<skill-name>/`。

每个来源组必须包含 `SOURCE.md`，记录：

```markdown
# SOURCE.md

- 来源仓库: <url>
- 拉取 commit: <commit hash>
- 许可证: <license name>
- 拉取日期: <date>

## 本地修改

- （无 / 列出具体改动）
```

批量拉取/更新请运行 `..\..\scripts\pull-vendor.ps1`（按 `..\..\scripts\vendor-manifest.json` 执行），不要手动编辑 vendor 内容。
