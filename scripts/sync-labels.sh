#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-${GITHUB_REPOSITORY:-}}"
[[ -n "$REPO" ]] || { echo "usage: $0 owner/repo" >&2; exit 1; }
command -v gh >/dev/null 2>&1 || { echo "missing required command: gh" >&2; exit 1; }

python3 - "$REPO" <<'PY'
from __future__ import annotations
import re
import subprocess
import sys
from pathlib import Path

repo = sys.argv[1]
text = Path('labels.yml').read_text(encoding='utf-8')
for block in re.split(r'(?m)^- name: ', text)[1:]:
    lines = block.splitlines()
    name = lines[0].strip()
    color = ''
    description = ''
    for line in lines[1:]:
        if line.startswith('  color:'):
            color = line.split(':', 1)[1].strip().strip('"')
        elif line.startswith('  description:'):
            description = line.split(':', 1)[1].strip().strip('"')
    subprocess.run(['gh', 'label', 'create', name, '--repo', repo, '--color', color, '--description', description, '--force'], check=True)
PY
