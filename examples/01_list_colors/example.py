"""示例 01：颜色目录查询 —— list_colors / get_color

列出全部 384 种中国传统色，按多种标识符查询单个颜色，
并额外绘制一张按 24 节气分组的色卡缩略图。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

from chinacolor import get_color, list_colors, setup_chinese_font

OUT = Path(__file__).parent


def main() -> None:
    # 1. 列出全部 384 种颜色
    colors = list_colors()
    print(f"颜色总数: {len(colors)}")
    print(f"字段: {list(colors[0].keys())}")
    print("前 3 条记录:")
    for record in colors[:3]:
        print(f"  id={record['color_id']:>3}  {record['hex']}  {record['name']}"
              f"  (group {record['group_id']}-{record['subgroup_id']})")

    # 2. 按多种标识符获取单个颜色
    by_id = get_color(1)               # 按 color_id
    by_name = get_color("黄白游")       # 按中文名
    by_hex = get_color("#FFF799")      # 按 HEX
    print("\nget_color 三种查询方式:")
    print(f"  get_color(1)        -> {by_id['name']} {by_id['hex']}")
    print(f"  get_color('黄白游')  -> id={by_name['color_id']} {by_name['hex']}")
    print(f"  get_color('#FFF799') -> {by_hex['name']}")

    # 3. 绘制前 64 色的色卡缩略图，直观展示目录内容
    setup_chinese_font()  # 加载内置中文字体，保证中文名正确显示
    sample = colors[:64]
    fig, axes = plt.subplots(8, 8, figsize=(12, 12))
    for ax, record in zip(axes.ravel(), sample):
        ax.set_facecolor(record["hex"])
        ax.text(0.5, 0.5, f"{record['color_id']}\n{record['name']}",
                ha="center", va="center", fontsize=8)
        ax.set_xticks([])
        ax.set_yticks([])
    fig.suptitle("chinacolor: first 64 of 384 colors", fontsize=16)
    fig.tight_layout()
    out_path = OUT / "output_colors.png"
    fig.savefig(out_path, dpi=120)
    print(f"\n已保存色卡: {out_path.name}")


if __name__ == "__main__":
    main()
