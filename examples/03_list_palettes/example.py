"""示例 03：调色板目录查询 —— list_palettes / get_palette_record

列出 60 组内置调色板，并演示按索引、标准名（seq01）、中文名、英文名查询单组调色板的元数据。
"""

from collections import Counter
from pathlib import Path

from chinacolor import get_palette_record, list_palettes

OUT = Path(__file__).parent


def main() -> None:
    # 1. 列出全部 60 组调色板
    palettes = list_palettes()
    print(f"调色板总数: {len(palettes)}")

    by_type = Counter(p["type"] for p in palettes)
    print(f"按类型统计: {dict(by_type)}")

    print("\n前 5 组调色板:")
    for p in palettes[:5]:
        print(f"  [{p['index']:>2}] {p['key']:<6} {p['palette_name']} / "
              f"{p['palette_name_e']:<16} {p['type']:<11} {p['color_count']} 色")

    # 2. 四种方式查询同一组调色板
    by_index = get_palette_record(1)
    by_key = get_palette_record("seq01")
    by_cn = get_palette_record(by_index["palette_name"])
    by_en = get_palette_record(by_index["palette_name_e"])
    print("\nget_palette_record 四种查询方式（均指向 seq01）:")
    print(f"  按索引 1            -> {by_index['key']} {by_index['hex']}")
    print(f"  按标准名 'seq01'    -> {by_key['key']}")
    print(f"  按中文名            -> {by_cn['key']}")
    print(f"  按英文名            -> {by_en['key']}")


if __name__ == "__main__":
    main()
