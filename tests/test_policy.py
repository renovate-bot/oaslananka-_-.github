from __future__ import annotations

import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


class RepositoryPolicyTests(unittest.TestCase):
    def test_validator_passes(self) -> None:
        result = subprocess.run(
            [sys.executable, str(ROOT / "scripts" / "validate_repo_policy.py")],
            cwd=ROOT,
            text=True,
            capture_output=True,
            check=False,
        )
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)

    def test_renovate_presets_match(self) -> None:
        central = json.loads((ROOT / "renovate-config.json").read_text(encoding="utf-8"))
        default = json.loads((ROOT / "default.json").read_text(encoding="utf-8"))
        self.assertEqual(central, default)

    def test_no_dependabot_config(self) -> None:
        self.assertFalse((ROOT / ".github" / "dependabot.yml").exists())
        self.assertFalse((ROOT / ".github" / "dependabot.yaml").exists())


if __name__ == "__main__":
    unittest.main()
