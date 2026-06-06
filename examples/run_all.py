"""一次性运行 examples/ 下的全部示例脚本。

用法:
    pixi run python examples/run_all.py
"""

import runpy
import sys
from pathlib import Path

ROOT = Path(__file__).parent


def main() -> int:
    scripts = sorted(ROOT.glob("[0-9][0-9]_*/example.py"))
    failures = []
    for script in scripts:
        print(f"\n{'=' * 60}\n运行 {script.relative_to(ROOT)}\n{'=' * 60}")
        try:
            runpy.run_path(str(script), run_name="__main__")
        except Exception as exc:  # noqa: BLE001
            failures.append((script, exc))
            print(f"[失败] {script.name}: {exc}")

    print(f"\n{'=' * 60}\n汇总: {len(scripts) - len(failures)}/{len(scripts)} 个示例运行成功")
    if failures:
        for script, exc in failures:
            print(f"  - {script.relative_to(ROOT)}: {exc}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
