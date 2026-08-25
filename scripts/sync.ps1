<#
.SYNOPSIS
  将本仓库的 skills 与配置模板部署到本机 Codex / Claude 目录。

.DESCRIPTION
  - skills: 将 skills/my 与 skills/vendor 下含 SKILL.md 的目录复制到
    ~/.codex/skills 与 ~/.claude/skills（覆盖同名目录）。
  - 配置: configs/codex、configs/claude 下的模板只在目标文件不存在时复制，
    避免覆盖你本机已修改的配置。
  - 使用 -DryRun 可只预览不执行。

.EXAMPLE
  .\scripts\sync.ps1 -DryRun
  .\scripts\sync.ps1
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
    Get-ChildItem -Path $Root -Directory | Where-Object {
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

$allSkillDirs = @()
$allSkillDirs += Get-SkillDirs $MySkillsRoot
$allSkillDirs += Get-SkillDirs $VendorSkillsRoot

Write-Step "同步 skills ($($allSkillDirs.Count) 个) 到 Codex 与 Claude"
Copy-Skills $allSkillDirs $CodexSkillsDir
Copy-Skills $allSkillDirs $ClaudeSkillsDir

Write-Step "同步配置模板 (不覆盖已存在的本地配置)"
Copy-Templates (Join-Path $RepoRoot "configs\codex") $CodexConfigDir
Copy-Templates (Join-Path $RepoRoot "configs\claude") $ClaudeConfigDir

if ($DryRun) {
    Write-Host "`n[dry-run] 以上为预览，未做任何修改。" -ForegroundColor Cyan
} else {
    Write-Host "`n完成。如使用 Claude Code，重启会话后生效。" -ForegroundColor Green
}
