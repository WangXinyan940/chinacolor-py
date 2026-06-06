"""示例 06：构建调色板 —— ctc_palette

从内置调色板构建任意长度的颜色序列，
支持数量插值/裁剪、方向反转，并保留调色板类型（sequential/diverging/qualitative）。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import ctc_palette, plot_palettes, setup_chinese_font

OUT = Path(__file__).parent


def main() -> None:
    # 对比图标题使用调色板中文名，需显式加载中文字体
    setup_chinese_font()

    # 1. 原始内置调色板（不指定 n）
    base = ctc_palette(type="built_in", palette_name="seq01")
    print(f"seq01 原始: type={base.palette_type}, n={base.n}")
    print(f"  颜色: {base.as_list()}")

    # 2. 连续型扩展：n 大于原色数时平滑插值
    expanded = ctc_palette(type="built_in", palette_name="seq01", n=12)
    print(f"\nseq01 扩展到 12 色（插值）: n={expanded.n}")

    # 3. 连续型裁剪：n 小于原色数时取前 n 个
    shrunk = ctc_palette(type="built_in", palette_name="seq01", n=3)
    print(f"seq01 裁剪到 3 色: {shrunk.as_list()}")

    # 4. 方向反转
    reversed_pal = ctc_palette(type="built_in", palette_name="seq01", n=6, direction=-1)
    print(f"\nseq01 反向: {reversed_pal.as_list()}")

    # 5. 发散型按中心向两侧裁剪，保留类型元数据
    div = ctc_palette(type="built_in", palette_name="div01", n=5)
    print(f"\ndiv01 裁剪到 5 色: type={div.palette_type}, n={div.n}")

    # 6. 定性型扩展时循环取色（而非插值）
    qual = ctc_palette(type="built_in", palette_name="qual01", n=12)
    print(f"qual01 扩展到 12 色（循环）: type={qual.palette_type}, n={qual.n}")

    # 可视化对比
    fig, _ = plot_palettes([base, expanded, shrunk, reversed_pal, div, qual])
    fig.savefig(OUT / "output_ctc_palette.png", dpi=110)
    print("\n已保存对比图: output_ctc_palette.png")


if __name__ == "__main__":
    main()
