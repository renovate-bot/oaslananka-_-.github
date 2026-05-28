# Renovate policy

## Recommended model

Use `oaslananka/.github` as the single Renovate policy source and place the following minimal config in each managed repository:

```json
{
  "extends": ["github>oaslananka/.github:renovate-config"]
}
```

## Why this model

- A single preset keeps maintenance predictable across TypeScript, JavaScript, Python, Docker, and GitHub Actions repositories.
- Major version updates require dashboard approval.
- Runtime updates require explicit review.
- Digest-only updates may automerge through a PR when branch checks pass.
- Package updates are delayed for three days to reduce exposure to unstable or unpublished releases.

## Files

- `renovate-config.json`: named preset used by repositories as `github>oaslananka/.github:renovate-config`.
- `default.json`: standard Renovate default preset alias.
- `renovate.json`: local config for this `.github` repository.
- `config.js`: optional self-hosted Renovate global config for manual runs.

## Hosted Renovate App

For public repositories, the hosted Renovate GitHub App is the simplest operational model. It creates PRs according to repository-local `renovate.json` files.

## Self-hosted manual runner

The workflow `.github/workflows/renovate-manual.yml` is intentionally manual. Set repository secret `RENOVATE_TOKEN` before use. The token needs access to the repositories being maintained and must include workflow permission if Renovate should update workflow files.

## Private and organization repositories

The personal account `.github` repository does not automatically provide community defaults to organization repositories. The Renovate preset can still be referenced by those repositories, or each organization can get its own `.github` repository with matching files.
