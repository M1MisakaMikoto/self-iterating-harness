# configs/mcp — MCP 服务配置模板

每个 MCP 服务一个文件，建议命名 `mcp-<name>.json`，字段占位示例：

```json
{
  "name": "<service-name>",
  "command": "<command>",
  "args": [],
  "env": {
    "<ENV_VAR>": "<PLACEHOLDER>"
  },
  "source": "<官方文档或仓库 URL>"
}
```

规则：

- 只记录结构模板，不写真实 token / 密钥。
- `source` 字段记录服务来源，方便日后核对版本与配置方式。
- Codex 与 Claude Code 的 MCP 配置格式可能不同，部署时参考各自官方文档转换。
