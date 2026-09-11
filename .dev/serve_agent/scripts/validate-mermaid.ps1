<#
.SYNOPSIS
    Validate every ```mermaid code block in a Markdown file.

.DESCRIPTION
    Extracts mermaid blocks from the given Markdown file and parses each one
    with mermaid's official parser (mermaid + jsdom in Node; no browser
    required). Reports block index and starting line; exits 1 if any block
    fails.

    The parser package is installed on first use into
    %LOCALAPPDATA%\agentsupport-harness\mermaid-validator (needs npm and a
    one-time network access). If node/npm or the install is unavailable,
    prints a fallback warning (special-char quoting self-check) and exits 0.

.EXAMPLE
    .\.dev\serve_agent\scripts\validate-mermaid.ps1 -Path docs\plan.md
#>
param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

$ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Write-Fallback {
    param([string]$Message)
    Write-Host "[mermaid] 工具不可用：$Message" -ForegroundColor Yellow
    Write-Host '[mermaid] 请按特殊字符规则自查：标签含 {} [] () | 等必须加引号（如 A["..."]、-->|"..."|）' -ForegroundColor Yellow
}

$mdPath = (Resolve-Path -LiteralPath $Path -ErrorAction SilentlyContinue)
if (-not $mdPath) {
    Write-Error "文件不存在: $Path"
    exit 2
}
$content = Get-Content -LiteralPath $mdPath.Path -Raw -Encoding UTF8
if ([string]::IsNullOrWhiteSpace($content)) {
    Write-Host "[mermaid] 未发现 mermaid 代码块（文件为空）"
    exit 0
}

$pattern = '(?s)```mermaid(?:\s+([A-Za-z0-9_-]+))?\s*\r?\n(.*?)\r?\n```'
$matches = [regex]::Matches($content, $pattern)
if ($matches.Count -eq 0) {
    Write-Host "[mermaid] 未发现 mermaid 代码块"
    exit 0
}

$blocks = @()
foreach ($m in $matches) {
    $type = if ($m.Groups[1].Success) { $m.Groups[1].Value } else { 'flowchart' }
    $line = 1 + ([regex]::Matches($content.Substring(0, $m.Index), "`n")).Count
    $blocks += [pscustomobject]@{
        index = $blocks.Count + 1
        line  = $line
        type  = $type
        code  = $m.Groups[2].Value
    }
}

$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Fallback "未找到 node"
    exit 0
}

$toolDir = Join-Path $env:LOCALAPPDATA "agentsupport-harness\mermaid-validator"
$mermaidDir = Join-Path $toolDir "node_modules\mermaid"
$jsdomDir = Join-Path $toolDir "node_modules\jsdom"
if (-not (Test-Path -LiteralPath $mermaidDir) -or -not (Test-Path -LiteralPath $jsdomDir)) {
    $npm = Get-Command npm.cmd -ErrorAction SilentlyContinue
    if (-not $npm) {
        Write-Fallback "未找到 npm.cmd"
        exit 0
    }
    New-Item -ItemType Directory -Force -Path $toolDir | Out-Null
    & $npm.Source install --prefix $toolDir mermaid jsdom *> $null
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $mermaidDir)) {
        Write-Fallback "npm install mermaid jsdom 失败（首次安装需要网络）"
        exit 0
    }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item -LiteralPath (Join-Path $scriptDir "validate-mermaid.mjs") -Destination (Join-Path $toolDir "validate-mermaid.mjs") -Force

$tmp = Join-Path $env:TEMP ("mermaid-blocks-" + [guid]::NewGuid().ToString('N') + ".json")
# 单元素数组会被 ConvertTo-Json 序列化成对象（Windows PowerShell 5.1 无 -AsArray），
# 这里手工拼数组，保证 1 个块也是合法 JSON 数组。
$json = "[" + (($blocks | ForEach-Object { $_ | ConvertTo-Json -Depth 6 -Compress }) -join ",") + "]"
[System.IO.File]::WriteAllText($tmp, $json, (New-Object System.Text.UTF8Encoding($false)))
try {
    & $node.Source (Join-Path $toolDir "validate-mermaid.mjs") $tmp
    $code = $LASTEXITCODE
} finally {
    Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
}
exit $code
