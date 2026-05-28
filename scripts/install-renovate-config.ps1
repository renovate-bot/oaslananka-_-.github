[CmdletBinding()]
param(
    [switch]$Apply,
    [switch]$Force,
    [string]$WorkDir = (Join-Path ([System.IO.Path]::GetTempPath()) ("renovate-rollout-" + [guid]::NewGuid().ToString("N")))
)

$ErrorActionPreference = "Stop"
$Owners = @("oaslananka", "oaslananka-dev", "oaslananka-mobil-dev", "sismosmart-dev")
$Preset = "github>oaslananka/.github:renovate-config"
$Branch = "chore/central-renovate-config"

foreach ($cmd in @("gh", "git")) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        throw "missing required command: $cmd"
    }
}

$config = @"
{
  "extends": ["$Preset"]
}
"@

foreach ($owner in $Owners) {
    $repos = gh repo list $owner --limit 200 --json nameWithOwner,isArchived --jq '.[] | select(.isArchived == false) | .nameWithOwner'
    foreach ($repo in $repos) {
        if ([string]::IsNullOrWhiteSpace($repo)) { continue }
        if ($repo -eq "oaslananka/.github") { continue }

        Write-Host "==> $repo"
        gh api "repos/$repo/contents/renovate.json" *> $null
        $exists = $LASTEXITCODE -eq 0
        if ($exists -and -not $Force) {
            Write-Host "    renovate.json exists; skip (use -Force to replace)"
            continue
        }

        if (-not $Apply) {
            Write-Host "    dry-run: would open/update PR adding renovate.json"
            continue
        }

        $repoDir = Join-Path $WorkDir ($repo -replace '/', '__')
        Remove-Item $repoDir -Recurse -Force -ErrorAction SilentlyContinue
        gh repo clone $repo $repoDir -- --quiet
        Push-Location $repoDir
        try {
            git switch -C $Branch
            Set-Content -Path renovate.json -Value $config -NoNewline -Encoding utf8
            git add renovate.json
            git diff --cached --quiet
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    no change"
            } else {
                git commit -m "chore: use central Renovate policy"
                git push --force-with-lease --set-upstream origin $Branch
                gh pr create --title "chore: use central Renovate policy" --body "Adds a minimal Renovate config extending ``$Preset``." --base main --head $Branch
            }
        } finally {
            Pop-Location
        }
    }
}
