<#
.SYNOPSIS
  将本仓库的 skills 与配置模板部署到本机 Codex / Claude 目录。

.DESCRIPTION
  - skills: 将 .dev/skills/my 与 .dev/skills/vendor 下含 SKILL.md 的目录复制到
    ~/.codex/skills 与 ~/.claude/skills（覆盖同名目录）。
  - 配置: .dev/configs/codex、.dev/configs/claude 下的模板只在目标文件不存在时复制，
    避免覆盖你本机已修改的配置。
  - 规则: .dev/rules/AGENTS.global.md、CLAUDE.global.md 部署到
    ~/.codex/AGENTS.md、~/.claude/CLAUDE.md（已存在时先备份）。
  - 项目: 若本仓库位于某个项目内，向项目根 .gitignore 追加
    ".dev/service/" 与 "/AGENTS.md" 忽略规则（仅当不存在时）。
  - 使用 -DryRun 可只预览不执行。

.EXAMPLE
  .\.dev\scripts\sync.ps1 -DryRun
  .\.dev\scripts\sync.ps1
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$CodexSkillsDir = (Join-Path $HOME ".codex\skills"),
    [string]$ClaudeSkillsDir = (Join-Path $HOME ".claude\skills"),
    [string]$CodexConfigDir = (Join-Path $HOME ".codex"),
    [string]$ClaudeConfigDir = (Join-Path $HOME ".claude")
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$MySkillsRoot = Join-Path $RepoRoot "skills\my"
$VendorSkillsRoot = Join-Path $RepoRoot "skills\vendor"

function Write-Step {
    param([string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Get-SkillDirs {
    param([string]$Root)
    if (-not (Test-Path $Root)) { return @() }
    Get-ChildItem -Path $Root -Directory -Recurse | Where-Object {
        Test-Path (Join-Path $_.FullName "SKILL.md")
    } | Select-Object -ExpandProperty FullName
}

function Copy-Skills {
    param(
        [string[]]$SkillDirs,
        [string]$TargetRoot
    )
    foreach ($dir in $SkillDirs) {
        $name = Split-Path $dir -Leaf
        $target = Join-Path $TargetRoot $name
        if ($DryRun) {
            Write-Host "  [dry-run] 复制 skills/$name -> $target"
            continue
        }
        New-Item -ItemType Directory -Force -Path $TargetRoot | Out-Null
        if (Test-Path $target) { Remove-Item -LiteralPath $target -Recurse -Force }
        Copy-Item -LiteralPath $dir -Destination $target -Recurse -Force
        Write-Host "  [ok] skills/$name -> $target"
    }
}

function Copy-Templates {
    param(
        [string]$TemplateRoot,
        [string]$TargetDir
    )
    if (-not (Test-Path $TemplateRoot)) { return }
    $files = Get-ChildItem -Path $TemplateRoot -File
    foreach ($f in $files) {
        $target = Join-Path $TargetDir $f.Name
        if (Test-Path $target) {
            Write-Host "  [skip] 已存在，保留本机版本: $target" -ForegroundColor Yellow
            continue
        }
        if ($DryRun) {
            Write-Host "  [dry-run] 复制模板 $($f.Name) -> $target"
            continue
        }
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        Copy-Item -LiteralPath $f.FullName -Destination $target -Force
        Write-Host "  [ok] 模板 $($f.Name) -> $target"
    }
}

function Add-ProjectGitIgnoreRules {
    param(
        [string]$ProjectRoot,
        [switch]$DryRun
    )
    $gitignore = Join-Path $ProjectRoot ".gitignore"
    if (-not (Test-Path $gitignore)) {
        Write-Host "  [skip] 项目根无 .gitignore: $ProjectRoot"
        return
    }
    $content = Get-Content -Raw -Encoding UTF8 $gitignore
    $rules = @(".dev/service/", "/AGENTS.md")
    $missing = @()
    foreach ($rule in $rules) {
        if ($content -notmatch [regex]::Escape($rule)) { $missing += $rule }
    }
    if ($missing.Count -eq 0) {
        Write-Host "  [skip] 忽略规则已存在: $gitignore"
        return
    }
    if ($DryRun) {
        Write-Host "  [dry-run] 向 $gitignore 追加: $($missing -join ', ')"
        return
    }
    $appendText = [Environment]::NewLine + [Environment]::NewLine +
        "# ai-coding-configs sync 自动追加：服务 coding agent 的内容不入库" +
        [Environment]::NewLine + ".dev/service/" + [Environment]::NewLine +
        "/AGENTS.md" + [Environment]::NewLine
    [System.IO.File]::AppendAllText($gitignore, $appendText, (New-Object System.Text.UTF8Encoding($false)))
    Write-Host "  [ok] 已追加忽略规则 -> $gitignore"
}

$allSkillDirs = @()
$allSkillDirs += Get-SkillDirs $MySkillsRoot
$allSkillDirs += Get-SkillDirs $VendorSkillsRoot

Write-Step "同步 skills ($($allSkillDirs.Count) 个) 到 Codex 与 Claude"
Copy-Skills $allSkillDirs $CodexSkillsDir
Copy-Skills $allSkillDirs $ClaudeSkillsDir

Write-Step "同步配置模板 (不覆盖已存在的本地配置)"
Copy-Templates (Join-Path $RepoRoot "configs\codex") $CodexConfigDir
Copy-Templates (Join-Path $RepoRoot "configs\claude") $ClaudeConfigDir

Write-Step "同步全局规则 (~/.codex/AGENTS.md, ~/.claude/CLAUDE.md)"
$globalRules = @(
    @{ Source = "rules\AGENTS.global.md"; Target = (Join-Path $HOME ".codex\AGENTS.md") },
    @{ Source = "rules\CLAUDE.global.md"; Target = (Join-Path $HOME ".claude\CLAUDE.md") }
)
foreach ($rule in $globalRules) {
    $src = Join-Path $RepoRoot $rule.Source
    if (-not (Test-Path $src)) {
        Write-Warning "缺少规则文件: $($rule.Source)"
        continue
    }
    if (Test-Path $rule.Target) {
        if ($DryRun) {
            Write-Host "  [dry-run] 备份并覆盖 $($rule.Target)"
            continue
        }
        $bak = "$($rule.Target).bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item -LiteralPath $rule.Target -Destination $bak -Force
        Copy-Item -LiteralPath $src -Destination $rule.Target -Force
        Write-Host "  [ok] 已备份 $($rule.Target) -> $bak 并覆盖"
    } else {
        if ($DryRun) {
            Write-Host "  [dry-run] 写入 $($rule.Target)"
            continue
        }
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $rule.Target) | Out-Null
        Copy-Item -LiteralPath $src -Destination $rule.Target -Force
        Write-Host "  [ok] $($rule.Target)"
    }
}

$ConfigRoot = Split-Path -Parent $RepoRoot
$ProjectRoot = Split-Path -Parent $ConfigRoot
if (Test-Path (Join-Path $ProjectRoot ".git")) {
    Write-Step "配置项目 .gitignore（忽略服务内容，产出内容自动记录）"
    Add-ProjectGitIgnoreRules $ProjectRoot -DryRun:$DryRun
} else {
    Write-Host "  [skip] 未检测到项目仓库（本仓库为独立部署）"
}

if ($DryRun) {
    Write-Host "`n[dry-run] 以上为预览，未做任何修改。" -ForegroundColor Cyan
} else {
    Write-Host "`n完成。如使用 Claude Code，重启会话后生效。" -ForegroundColor Green
}
