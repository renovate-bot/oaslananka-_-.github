#!/usr/bin/env bash
set -euo pipefail

OWNER_LIST=("oaslananka" "oaslananka-dev" "oaslananka-mobil-dev" "sismosmart-dev")
PRESET='github>oaslananka/.github:renovate-config'
BRANCH='chore/central-renovate-config'
APPLY="${APPLY:-0}"
FORCE="${FORCE:-0}"
WORKDIR="${WORKDIR:-$(mktemp -d)}"

require() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

require gh
require git

config_content=$(cat <<RENOVATE_JSON
{
  "extends": ["${PRESET}"]
}
RENOVATE_JSON
)

for owner in "${OWNER_LIST[@]}"; do
  gh repo list "$owner" --limit 200 --json nameWithOwner,isArchived --jq '.[] | select(.isArchived == false) | .nameWithOwner' |
  while IFS= read -r repo; do
    [[ -z "$repo" ]] && continue
    [[ "$repo" == "oaslananka/.github" ]] && continue

    echo "==> $repo"
    if gh api "repos/${repo}/contents/renovate.json" >/dev/null 2>&1 && [[ "$FORCE" != "1" ]]; then
      echo "    renovate.json exists; skip (set FORCE=1 to replace)"
      continue
    fi

    if [[ "$APPLY" != "1" ]]; then
      echo "    dry-run: would open/update PR adding renovate.json"
      continue
    fi

    repo_dir="${WORKDIR}/${repo//\//__}"
    rm -rf "$repo_dir"
    gh repo clone "$repo" "$repo_dir" -- --quiet
    pushd "$repo_dir" >/dev/null
      git switch -C "$BRANCH"
      printf '%s\n' "$config_content" > renovate.json
      git add renovate.json
      if git diff --cached --quiet; then
        echo "    no change"
      else
        git commit -m "chore: use central Renovate policy"
        git push --force-with-lease --set-upstream origin "$BRANCH"
        gh pr create \
          --title "chore: use central Renovate policy" \
          --body "Adds a minimal Renovate config extending \`${PRESET}\`." \
          --base main \
          --head "$BRANCH" || true
      fi
    popd >/dev/null
  done
done
