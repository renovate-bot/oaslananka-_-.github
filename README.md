# oaslananka repository defaults

This repository contains account-level community health files, shared GitHub Actions workflows, label definitions, and the central Renovate policy for repositories maintained by `oaslananka`.

## Scope

GitHub automatically applies supported default community health files from this public `.github` repository to repositories owned by `oaslananka` when a repository does not define its own file. Organization repositories under `oaslananka-dev`, `oaslananka-mobil-dev`, and `sismosmart-dev` do not inherit these files from the personal account repository; they should either use their own organization-level `.github` repository or keep repository-local policy files.

## Renovate model

Repository dependency automation is centralized through `renovate-config.json`:

```json
{
  "extends": ["github>oaslananka/.github:renovate-config"]
}
```

The file `default.json` is intentionally kept in sync with `renovate-config.json` so the repository can also be consumed as a standard GitHub-hosted Renovate preset.

## Operating principles

- Keep repository defaults small and boring.
- Prefer explicit review for major upgrades and runtime jumps.
- Do not broadly automerge package updates.
- Pin GitHub Actions digests while preserving semver tags.
- Delay npm, PyPI, Docker, and GitHub Actions updates for three days before PR creation.
- Keep public governance documents neutral, factual, and maintainable by one person.

## Files

| Path | Purpose |
| --- | --- |
| `renovate-config.json` | Main Renovate preset consumed by all repositories. |
| `default.json` | Standard shareable preset alias for Renovate. |
| `renovate.json` | Local Renovate config for this `.github` repository. |
| `.github/workflows/validate.yml` | Validates JSON, policy invariants, and tests. |
| `.github/workflows/renovate-manual.yml` | Manual self-hosted Renovate runner entry point. |
| `.github/workflows/reusable-*.yml` | Reusable CI workflows for downstream repositories. |
| `labels.yml` | Canonical issue and PR labels. |
| `scripts/install-renovate-config.*` | Dry-run by default; can open rollout PRs across repositories. |
| `scripts/validate_repo_policy.py` | Local policy validation without third-party Python dependencies. |

## Local validation

Linux/macOS:

```bash
python3 scripts/validate_repo_policy.py
python3 -m unittest discover -s tests
```

Windows 11 PowerShell:

```powershell
py scripts\validate_repo_policy.py
py -m unittest discover -s tests
```

## Renovate rollout

Dry-run across visible repositories:

```bash
scripts/install-renovate-config.sh
```

Apply via pull requests:

```bash
APPLY=1 scripts/install-renovate-config.sh
```

PowerShell:

```powershell
.\scripts\install-renovate-config.ps1
.\scripts\install-renovate-config.ps1 -Apply
```
