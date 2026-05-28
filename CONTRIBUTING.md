# Contributing

Contributions are handled with a low-overhead process suitable for repositories maintained primarily by one person.

## Before opening an issue

- Search existing issues and pull requests.
- Verify the behavior on the default branch when practical.
- Include the operating system, runtime version, package manager, and exact command used.
- Reduce examples to the smallest reproducible case.

## Pull requests

A pull request should include:

- A focused scope.
- Tests or a clear reason tests are not applicable.
- Documentation updates when behavior, configuration, or public API changes.
- No unrelated formatting churn.
- No generated artifacts unless the repository explicitly tracks them.

## Commit style

Use Conventional Commits where practical:

- `feat:` user-visible feature
- `fix:` bug fix
- `docs:` documentation-only change
- `test:` test-only change
- `refactor:` behavior-preserving code change
- `chore:` repository maintenance
- `ci:` workflow and automation change
- `security:` security hardening or vulnerability fix

## Dependency updates

Dependency updates should normally be opened by Renovate. Manual dependency PRs are acceptable when they unblock a security fix, runtime migration, or broken release pipeline.

Major dependency updates require explicit review because they can alter API behavior, runtime support, or generated artifacts.

## Security fixes

Do not open public issues for exploitable vulnerabilities. Use the process in `SECURITY.md`.
