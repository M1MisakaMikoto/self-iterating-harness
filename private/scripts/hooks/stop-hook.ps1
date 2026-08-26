<#
.SYNOPSIS
    path-memory Stop hook：会话启用了路径记忆（存在 .staging/.flag-<session_id>）
    且未总结过时，输出 {"decision":"block","reason":"<总结指令>"} 触发续写总结；
    否则放行（无输出）。
#>
$ErrorActionPreference = 'Stop'
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Find-ProjectRoot {
    param([string]$StartDir)
    $dir = $StartDir
    while ($dir) {
        if (Test-Path (Join-Path $dir '.dev')) { return $dir }
        $parent = Split-Path -Parent $dir
        if ($parent -eq $dir) { return $null }
        $dir = $parent
    }
    return $null
}

function Find-RecordsDir {
    param([string]$StartDir)
    $root = Find-ProjectRoot -StartDir $StartDir
    if (-not $root) { return $null }
    $records = Join-Path $root '.dev\private\records'
    if (Test-Path -LiteralPath $records) { return $records }
    return $null
}

function Get-PathSlug {
    param([string]$Cwd, [string]$ProjectRoot)
    $rel = $Cwd
    if ($ProjectRoot -and $Cwd.StartsWith($ProjectRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        $rel = $Cwd.Substring($ProjectRoot.Length).TrimStart('\', '/')
    }
    if (-not $rel) { return 'root' }
    $slug = [regex]::Replace($rel, '[^a-zA-Z0-9_.-]+', '-').Trim('-')
    if (-not $slug) { return 'root' }
    return $slug
}

$raw = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($raw)) { exit 0 }
try { $evt = $raw | ConvertFrom-Json } catch { exit 0 }
if (-not $evt) { exit 0 }

$sessionId = [string]$evt.session_id
if (-not $sessionId) { exit 0 }
$cwd = [string]$evt.cwd
if (-not $cwd) { $cwd = [string]$evt.working_directory }
if (-not $cwd) { $cwd = (Get-Location).Path }

$recordsDir = Find-RecordsDir -StartDir $cwd
if (-not $recordsDir) { exit 0 }
$staging = Join-Path $recordsDir '.staging'
if (-not (Test-Path -LiteralPath $staging)) { exit 0 }

$flag = Join-Path $staging ".flag-$sessionId"
if (-not (Test-Path -LiteralPath $flag)) { exit 0 }

$done = Join-Path $staging ".done-$sessionId"
if (Test-Path -LiteralPath $done) { exit 0 }

# 触发次数兜底：最多续写总结 2 次，防止死循环
$attemptFile = Join-Path $staging ".attempt-$sessionId"
$attempts = 0
if (Test-Path -LiteralPath $attemptFile) {
    $attempts = [int]((Get-Content -LiteralPath $attemptFile -Raw).Trim())
}
if ($attempts -ge 2) { exit 0 }
Set-Content -LiteralPath $attemptFile -Value ($attempts + 1) -Encoding UTF8

$projectRoot = Find-ProjectRoot -StartDir $cwd
$slug = Get-PathSlug -Cwd $cwd -ProjectRoot $projectRoot
$donePath = Join-Path $staging ".done-$sessionId"

$reason = @"
任务已结束，本次会话启用了路径记忆。请先向用户确认是否记录本次探索（不要先生成草稿）：
1. 用 2-3 行要点向用户说明将记录的内容：目标方向、关键探索/碰壁/跑通、建议 tags（从 records/README.md 词表选择，不要自创新 tag）、以及将写入 records\$slug.md 是新增还是更新。
2. 询问后立即创建完成标记：$donePath（避免 hook 重复询问）。
3. 用户确认后：直接按 path-memory skill 模板写入 records\$slug.md，并向用户报告文件位置；用户拒绝则跳过，不写入、不创建任何草稿。
4. 不要生成完整草稿、不要展示完整内容、不要二次确认。
结构细节见 path-memory skill。
"@

[pscustomobject]@{
    decision      = 'block'
    reason        = $reason
    systemMessage = 'path-memory: 正在生成探索记录草稿，请稍后确认'
} | ConvertTo-Json -Compress
exit 0
