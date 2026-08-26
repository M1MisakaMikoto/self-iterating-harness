<#
.SYNOPSIS
    path-memory SessionStart hook：注入会话 ID、待确认草稿、本路径已有记录摘要，
    并指导 agent 在探索性任务开始时启用路径记忆（创建会话标记文件）。
.DESCRIPTION
    由 ~/.codex/hooks.json 或 ~/.claude/settings.json 的 SessionStart 事件调用，
    从 stdin 读取 JSON（session_id / cwd），向 stdout 输出注入上下文。
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

$projectRoot = Find-ProjectRoot -StartDir $cwd
if (-not $projectRoot) { exit 0 }

$recordsDir = Join-Path $projectRoot '.dev\private\records'
$staging = Join-Path $recordsDir '.staging'
$slug = Get-PathSlug -Cwd $cwd -ProjectRoot $projectRoot

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("[path-memory] 会话ID=$sessionId 工作路径=$slug")

$recordFile = Join-Path $recordsDir "$slug.md"
if (Test-Path -LiteralPath $recordFile) {
    $lines.Add("本路径已有探索记录 records\$slug.md，要点：")
    $head = @(Get-Content -LiteralPath $recordFile -Encoding UTF8 -TotalCount 80)
    $body = [System.Collections.Generic.List[string]]::new()
    $inFrontmatter = $false
    foreach ($line in $head) {
        if ($line.Trim() -eq '---') { $inFrontmatter = -not $inFrontmatter; continue }
        if ($inFrontmatter) { continue }
        $t = $line.Trim()
        if ($t -and $t -notmatch '^```') { $body.Add($t) }
        if ($body.Count -ge 18) { break }
    }
    if ($body.Count -gt 0) {
        $text = $body -join ' '
        if ($text.Length -gt 1200) { $text = $text.Substring(0, 1200) + '…' }
        $lines.Add($text)
    }
}

$lines.Add("若本任务带探索性质（新领域/方案未定/需多路径尝试/预期碰壁），请启用路径记忆：创建标记文件 $staging\.flag-$sessionId（目录不存在就创建，内容任意）。启用后专注工作、不边干边记；任务结束时 hook 会提醒你总结。无需沉淀时不要创建。详见 path-memory skill。")

$text = $lines -join "`n"
if ($env:CLAUDE_PROJECT_DIR) {
    # Claude Code：SessionStart 的 stdout 会直接加入上下文
    $text
} else {
    # Codex：需通过 hookSpecificOutput.additionalContext 注入为 developer context
    [pscustomobject]@{
        hookSpecificOutput = [pscustomobject]@{
            hookEventName    = 'SessionStart'
            additionalContext = $text
        }
    } | ConvertTo-Json -Compress
}
exit 0
