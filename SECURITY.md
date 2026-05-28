# Security Policy

## Supported repositories

Security support is defined per repository. If a repository does not define its own support matrix, only the default branch is considered supported.

## Reporting a vulnerability

Use GitHub private vulnerability reporting when it is enabled for the affected repository. If that is not available, open a minimal public issue that asks for a private security contact without including exploit details.

Do not publish proof-of-concept exploit details, secrets, private data, or active target information in public issues or pull requests.

## Report content

A useful report includes:

- Affected repository, branch, package, or released version.
- Impact and exploitability conditions.
- Reproduction steps in an isolated environment.
- Relevant logs, stack traces, or dependency paths.
- Suggested remediation when known.

## Triage

Reports are prioritized by exploitability, affected surface, data exposure risk, and availability impact. False positives may be closed with a technical rationale.

## Dependency vulnerability handling

Renovate is configured to create vulnerability fix PRs immediately when supported by the platform and available advisory data.
