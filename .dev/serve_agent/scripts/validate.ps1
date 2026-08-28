<#
.SYNOPSIS
  校验仓库内 skills 结构是否合法。

.DESCRIPTION
  检查 skills/my 与 skills/vendor 下每个目录:
    - 是否包含 SKILL.md
    - SKILL.md frontmatter 是否包含 name 与 description
  vendor 额外检查 SOURCE.md 是否存在。
  同时校验项目级 hooks JSON，以及 serve_project 中不存在仍被 harness
  仓库跟踪的实例文件。
  全部通过退出码为 0，否则为 1。

.EXAMPLE
  .\scripts\validate.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $PSScriptRoot
$errors = @()

function Test-Frontmatter {
    param([string]$Path)
    $content = Get-Content -Raw -Path $Path
    if ($content -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---') {
        return $false
    }
    $fm = $Matches[1]
    ($fm -match '(?im)^name\s*:') -and ($fm -match '(?im)^description\s*:')
}

function Test-SkillDir {
    param([string]$Dir, [string]$Label)
    $skillFile = Join-Path $Dir "SKILL.md"
    if (-not (Test-Path $skillFile)) {
        $script:errors += "缺少 SKILL.md: $Label"
        return
    }
    if (-not (Test-Frontmatter $skillFile)) {
        $script:errors += "SKILL.md 缺少 name/description frontmatter: $Label"
    }
}

# skills/my: 每个子目录是一个 skill
foreach ($root in @("skills\my")) {
    $full = Join-Path $RepoRoot $root
    if (-not (Test-Path $full)) { continue }
    Get-ChildItem -Path $full -Directory | ForEach-Object {
        Test-SkillDir $_.FullName "$root/$($_.Name)"
    }
}

# skills/vendor: 每个子目录是一个来源组（要求 SOURCE.md），组内递归找 skill
$vendorRoot = Join-Path $RepoRoot "skills\vendor"
if (Test-Path $vendorRoot) {
    Get-ChildItem -Path $vendorRoot -Directory | ForEach-Object {
        $group = $_
        $sourceMd = Join-Path $group.FullName "SOURCE.md"
        if (-not (Test-Path $sourceMd)) {
            $errors += "vendor 来源组缺少 SOURCE.md: skills/vendor/$($group.Name)"
        }
        Get-ChildItem -Path $group.FullName -Directory -Recurse | Where-Object {
            Test-Path (Join-Path $_.FullName "SKILL.md")
        } | ForEach-Object {
            Test-SkillDir $_.FullName "skills/vendor/$($group.Name)/$($_.Name)"
        }
    }
}

$DevRoot = Split-Path -Parent $RepoRoot
$HarnessRoot = Split-Path -Parent $DevRoot
$hooksFile = Join-Path $HarnessRoot '.codex\hooks.json'
if (-not (Test-Path -LiteralPath $hooksFile)) {
    $errors += '缺少项目级 Codex hooks: .codex/hooks.json'
} else {
    try {
        $hooksConfig = Get-Content -LiteralPath $hooksFile -Raw -Encoding UTF8 | ConvertFrom-Json
        if (-not $hooksConfig.hooks.SessionStart -or -not $hooksConfig.hooks.Stop) {
            $errors += '.codex/hooks.json 缺少 SessionStart 或 Stop'
        }
    } catch {
        $errors += ".codex/hooks.json 不是合法 JSON: $($_.Exception.Message)"
    }
}

if (Test-Path -LiteralPath (Join-Path $HarnessRoot '.git')) {
    $trackedProjectFiles = @(& git -C $HarnessRoot ls-files -- '.dev/serve_project' | Where-Object {
        Test-Path -LiteralPath (Join-Path $HarnessRoot $_)
    })
    if ($LASTEXITCODE -ne 0) {
        $errors += '无法读取 harness Git 跟踪边界'
    } elseif ($trackedProjectFiles.Count -gt 0) {
        $errors += "serve_project 包含被 harness 跟踪的实例文件: $($trackedProjectFiles -join ', ')"
    }
}

if ($errors.Count -gt 0) {
    Write-Host "校验失败:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

Write-Host "校验通过: skills、hooks 与 serve_project 跟踪边界合法。" -ForegroundColor Green
exit 0
