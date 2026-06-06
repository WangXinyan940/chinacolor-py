"""示例 05：批量预览调色板 —— plot_palettes

在一张图里纵向排列多组调色板，方便对比挑选。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import plot_palettes, setup_chinese_font

OUT = Path(__file__).parent


def main() -> None:
    # 调色板标题为中文名，需显式加载中文字体
    setup_chinese_font()

    # 1. 对比同类（连续型）调色板
    seq_group = ["seq01", "seq02", "seq03", "seq04", "seq05", "seq06"]
    fig1, _ = plot_palettes(seq_group)
    fig1.savefig(OUT / "output_sequential.png", dpi=110)
    print("已保存连续型对比图: output_sequential.png")

    # 2. 跨类型对比：连续 / 发散 / 定性各取一组
    mixed = ["seq01", "div01", "qual01"]
    fig2, _ = plot_palettes(mixed)
    fig2.savefig(OUT / "output_mixed.png", dpi=110)
    print("已保存跨类型对比图: output_mixed.png")

    # 3. 用索引批量预览（41-46 = qual01-qual06）
    fig3, _ = plot_palettes(list(range(41, 47)))
    fig3.savefig(OUT / "output_qualitative.png", dpi=110)
    print("已保存定性型对比图: output_qualitative.png")


if __name__ == "__main__":
    main()
