#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED_FILES = [
    "README.md",
    "CODEOWNERS",
    "CODE_OF_CONDUCT.md",
    "CONTRIBUTING.md",
    "GOVERNANCE.md",
    "SECURITY.md",
    "SUPPORT.md",
    "PULL_REQUEST_TEMPLATE.md",
    "labels.yml",
    "renovate-config.json",
    "default.json",
    "renovate.json",
    "config.js",
    ".github/workflows/validate.yml",
    ".github/workflows/renovate-manual.yml",
]

FORBIDDEN_FILES = [
    ".github/dependabot.yml",
    ".github/dependabot.yaml",
]


def load_json(path: str) -> dict:
    try:
        return json.loads((ROOT / path).read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        raise SystemExit(f"invalid JSON in {path}: {exc}") from exc


def labels_from_yaml_subset() -> set[str]:
    labels: set[str] = set()
    for line in (ROOT / "labels.yml").read_text(encoding="utf-8").splitlines():
        match = re.match(r"^- name:\s*(.+)\s*$", line)
        if match:
            labels.add(match.group(1).strip().strip('"'))
    return labels


def issue_template_labels() -> dict[str, set[str]]:
    result: dict[str, set[str]] = {}
    for path in sorted((ROOT / ".github" / "ISSUE_TEMPLATE").glob("*.yml")):
        text = path.read_text(encoding="utf-8")
        match = re.search(r"(?m)^labels:\s*\[(.*?)\]\s*$", text)
        if match:
            values = {item.strip().strip('"\'') for item in match.group(1).split(',') if item.strip()}
            result[str(path.relative_to(ROOT))] = values
    return result


def main() -> int:
    missing = [path for path in REQUIRED_FILES if not (ROOT / path).is_file()]
    if missing:
        print("missing required files:", ", ".join(missing), file=sys.stderr)
        return 1

    forbidden = [path for path in FORBIDDEN_FILES if (ROOT / path).exists()]
    if forbidden:
        print("forbidden Dependabot files present:", ", ".join(forbidden), file=sys.stderr)
        return 1

    central = load_json("renovate-config.json")
    default = load_json("default.json")
    local = load_json("renovate.json")

    if central != default:
        print("default.json must stay identical to renovate-config.json", file=sys.stderr)
        return 1

    expected_extend = "github>oaslananka/.github:renovate-config"
    if expected_extend not in local.get("extends", []):
        print(f"renovate.json must extend {expected_extend}", file=sys.stderr)
        return 1

    if "config:recommended" not in central.get("extends", []):
        print("central Renovate preset must extend config:recommended", file=sys.stderr)
        return 1

    if central.get("timezone") != "Europe/Istanbul":
        print("central Renovate preset must use Europe/Istanbul timezone", file=sys.stderr)
        return 1

    labels = labels_from_yaml_subset()
    missing_template_labels: list[str] = []
    for template, template_labels in issue_template_labels().items():
        for label in template_labels:
            if label not in labels:
                missing_template_labels.append(f"{template}:{label}")
    if missing_template_labels:
        print("issue template labels missing from labels.yml:", ", ".join(missing_template_labels), file=sys.stderr)
        return 1

    for workflow in (ROOT / ".github" / "workflows").glob("*.yml"):
        text = workflow.read_text(encoding="utf-8")
        if "pull_request_target" in text:
            print(f"pull_request_target is not allowed in {workflow.relative_to(ROOT)}", file=sys.stderr)
            return 1

    print("repository policy validation passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
