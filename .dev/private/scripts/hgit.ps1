<#
.SYNOPSIS
    harness 仓库 git 快捷命令：在项目根执行，等价于对 .git-harness 仓库运行 git。
.EXAMPLE
    .\.dev\public\scripts\hgit.ps1 status
    .\.dev\public\scripts\hgit.ps1 add -A
    .\.dev\public\scripts\hgit.ps1 commit -m "..."
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GitArgs
)
$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
$gitDir = Join-Path $projectRoot '.git-harness'
git --git-dir=$gitDir --work-tree=$projectRoot @GitArgs
exit $LASTEXITCODE
