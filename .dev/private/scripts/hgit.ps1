<#
.SYNOPSIS
    harness 仓库 git 快捷命令：在工作区根执行，等价于对根仓库运行 git。
.EXAMPLE
    hgit.ps1 status
    hgit.ps1 add -A
    hgit.ps1 commit -m "..."
#>
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$GitArgs
)
$ErrorActionPreference = 'Stop'
$harnessRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
git -C $harnessRoot @GitArgs
exit $LASTEXITCODE
