[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Repository
)

$ErrorActionPreference = "Stop"
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "missing required command: gh"
}

$raw = Get-Content labels.yml -Raw
$blocks = [regex]::Split($raw, '(?m)^- name: ')
foreach ($block in $blocks | Select-Object -Skip 1) {
    $lines = $block -split "`r?`n"
    $name = $lines[0].Trim()
    $color = ""
    $description = ""
    foreach ($line in $lines | Select-Object -Skip 1) {
        if ($line.StartsWith("  color:")) { $color = ($line -split ':', 2)[1].Trim().Trim('"') }
        if ($line.StartsWith("  description:")) { $description = ($line -split ':', 2)[1].Trim().Trim('"') }
    }
    if ($name -and $color) {
        gh label create $name --repo $Repository --color $color --description $description --force
    }
}
