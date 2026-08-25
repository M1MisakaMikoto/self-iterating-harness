<#
.SYNOPSIS
  按 scripts/vendor-manifest.json 拉取/更新第三方 skills 到 skills/vendor。

.DESCRIPTION
  manifest 每条记录:
    name   - 来源名，对应 skills/vendor/<name>/
    url    - 上游 git 仓库地址
    commit - 分支名或 commit hash；留空表示上游默认分支最新
    skills - 上游仓库内要复制的 skill 相对路径列表

  拉取后自动写入 SOURCE.md（来源、commit、日期），并保留上游 LICENSE。

.EXAMPLE
  .\scripts\pull-vendor.ps1
  .\scripts\pull-vendor.ps1 -Name example-skill-pack
#>
[CmdletBinding()]
param(
    [string]$Name
)

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$ManifestPath = Join-Path $PSScriptRoot "vendor-manifest.json"
$VendorRoot = Join-Path $RepoRoot "skills\vendor"

if (-not (Test-Path $ManifestPath)) {
    throw "找不到 manifest: $ManifestPath"
}

$manifest = Get-Content -Raw -Path $ManifestPath | ConvertFrom-Json
$entries = @($manifest)
if ($Name) {
    $entries = @($entries | Where-Object { $_.name -eq $Name })
    if ($entries.Count -eq 0) {
        throw "manifest 中不存在 name=$Name 的记录"
    }
}

foreach ($entry in $entries) {
    if (-not $entry.name -or -not $entry.url) {
        Write-Warning "跳过无效条目: name=$($entry.name) url=$($entry.url)"
        continue
    }

    $dest = Join-Path $VendorRoot $entry.name
    Write-Host "==> 拉取 $($entry.name) <- $($entry.url)" -ForegroundColor Cyan

    $temp = Join-Path ([System.IO.Path]::GetTempPath()) ("vendor-" + [guid]::NewGuid().ToString("N"))
    try {
        git clone --quiet --filter=blob:none --no-checkout $entry.url $temp
        if ($LASTEXITCODE -ne 0) { throw "git clone 失败: $($entry.url)" }

        if ($entry.commit) {
            git -C $temp checkout --quiet $entry.commit
            if ($LASTEXITCODE -ne 0) { throw "checkout 失败: $($entry.commit)" }
        } else {
            git -C $temp checkout --quiet
            if ($LASTEXITCODE -ne 0) { throw "checkout 默认分支失败" }
        }

        $commitHash = (git -C $temp rev-parse HEAD).Trim()
        New-Item -ItemType Directory -Force -Path $dest | Out-Null

        foreach ($skill in @($entry.skills)) {
            $src = Join-Path $temp $skill
            if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
                Write-Warning "  [跳过] $skill 不是有效 skill（缺少 SKILL.md）"
                continue
            }
            $skillName = Split-Path $skill -Leaf
            Copy-Item -LiteralPath $src -Destination (Join-Path $dest $skillName) -Recurse -Force
            Write-Host "  [ok] $skillName"
        }

        if (Test-Path (Join-Path $temp "LICENSE")) {
            Copy-Item -LiteralPath (Join-Path $temp "LICENSE") -Destination $dest -Force
        }

        $sourceMd = @(
            "# SOURCE.md"
            ""
            "- 来源仓库: $($entry.url)"
            "- 拉取 commit: $commitHash"
            "- 许可证: 见本目录 LICENSE（如上游未提供，需人工确认）"
            "- 拉取日期: $(Get-Date -Format 'yyyy-MM-dd')"
            ""
            "## 本地修改"
            ""
            "- 无"
        ) -join "`r`n"
        Set-Content -LiteralPath (Join-Path $dest "SOURCE.md") -Value $sourceMd -Encoding UTF8
    }
    finally {
        if (Test-Path $temp) {
            Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host "`n完成。运行 .\scripts\validate.ps1 校验结果。" -ForegroundColor Green
