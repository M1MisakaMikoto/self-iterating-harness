<#
.SYNOPSIS
    path-memory 检索：按 tag / 关键词在 .dev/private/records 中搜索记录。
.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File search-records.ps1 -Tag 纠正
    powershell -NoProfile -ExecutionPolicy Bypass -File search-records.ps1 -Keyword "跑通"
    powershell -NoProfile -ExecutionPolicy Bypass -File search-records.ps1 -List
#>
[CmdletBinding()]
param(
    [string]$Tag,
    [string]$Keyword,
    [string]$Path,
    [switch]$List
)
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

$recordsDir = $Path
if (-not $recordsDir) { $recordsDir = Find-RecordsDir -StartDir (Get-Location).Path }
if (-not $recordsDir) { Write-Output '未找到 records 目录（.dev/private/records）'; exit 1 }

$files = @(Get-ChildItem -LiteralPath $recordsDir -Recurse -File -Filter '*.md' | Where-Object {
    $_.Name -ne 'README.md' -and $_.Directory.Name -ne '.staging'
})
if ($files.Count -eq 0) { Write-Output '暂无记录'; exit 0 }

$results = [System.Collections.Generic.List[object]]::new()
foreach ($f in $files) {
    $content = Get-Content -LiteralPath $f.FullName -Raw -Encoding UTF8
    $matched = $false
    $hits = @()
    if ($Tag) {
        $rx = "(?im)^tags\s*:.*\b$([regex]::Escape($Tag))\b"
        if ($content -match $rx) { $matched = $true }
    }
    if ($Keyword) {
        $kw = [regex]::Escape($Keyword)
        if ($content -match $kw) {
            $matched = $true
            $hits = @(Select-String -LiteralPath $f.FullName -Pattern $kw | Select-Object -First 5 | ForEach-Object { $_.Line.Trim() })
        }
    }
    if (-not $Tag -and -not $Keyword) { $matched = $true }
    if ($matched) {
        $results.Add([pscustomobject]@{ File = $f.FullName; Lines = ($hits -join ' | ') })
    }
}

if ($List -or (-not $Tag -and -not $Keyword)) {
    $results | ForEach-Object { Write-Output $_.File }
} else {
    foreach ($r in $results) {
        Write-Output "== $($r.File)"
        if ($r.Lines) { Write-Output "   $($r.Lines)" }
    }
}
exit 0
