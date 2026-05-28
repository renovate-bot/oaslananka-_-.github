# Maintenance checklist

## New repository

- [ ] Add a clear description and topics.
- [ ] Add `README.md` with install, usage, and validation commands.
- [ ] Add license when public reuse is intended.
- [ ] Add repository-local `SECURITY.md` only when the default policy is insufficient.
- [ ] Add `renovate.json` extending `github>oaslananka/.github:renovate-config`.
- [ ] Configure CI before publishing packages or releases.
- [ ] Enable branch protection when CI is stable.

## Existing repository

- [ ] Remove stale Dependabot config when Renovate is active.
- [ ] Close or triage stale dependency PRs before onboarding Renovate.
- [ ] Verify lockfile maintenance output before enabling broad automation.
- [ ] Keep major upgrades behind dashboard approval.
- [ ] Verify release workflows after dependency and runtime migrations.

## Public presentation

- [ ] Repository description explains what the project does.
- [ ] README contains a minimal runnable example.
- [ ] No private infrastructure, secrets, tokens, or personal notes are present.
- [ ] Issue templates ask for reproducible data.
- [ ] Security policy does not invite public exploit disclosure.
