# Repository settings baseline

Recommended settings for actively maintained repositories:

- Default branch: `main`.
- Issues: enabled for public libraries and tools.
- Discussions: optional; enable only when the repository benefits from usage Q&A.
- Wiki: disabled unless the repository has a specific wiki workflow.
- Projects: optional; enable only when issues are actively triaged.
- Merge strategy: squash merge enabled, merge commits disabled, rebase merge optional.
- Delete branch on merge: enabled.
- Auto-merge: repository-specific; do not rely on it unless required checks are configured.
- Branch protection: require CI on default branch for production or published packages.
- Code scanning: enable where language and licensing allow it.
- Secret scanning and push protection: enable for public repositories and any private repository with credentials or deployment workflows.

Do not force identical settings across all repositories. A published package, security tool, template repository, and private control-plane repository have different operational risk profiles.
