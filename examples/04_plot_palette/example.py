"""示例 04：预览单个调色板 —— plot_palette

把内置调色板或自定义颜色序列绘制成横向色条。
plot_palette 接受多种输入：标准名 / 索引 / Palette 对象 / 颜色列表。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import ctc_palette, plot_palette, setup_chinese_font

OUT = Path(__file__).parent


def main() -> None:
    # 内置调色板标题为中文名（如“大地金秋”），需显式加载中文字体
    setup_chinese_font()

    # 1. 按标准名预览内置调色板
    fig1, _ = plot_palette("seq01")
    fig1.savefig(OUT / "output_builtin.png", dpi=120)
    print("已保存 seq01 预览: output_builtin.png")

    # 2. 按索引预览（33 = div13）
    fig2, _ = plot_palette(33)
    fig2.savefig(OUT / "output_by_index.png", dpi=120)
    print("已保存索引 33 预览: output_by_index.png")

    # 3. 预览 Palette 对象，并自定义标题
    pal = ctc_palette(type="built_in", palette_name="qual01", n=8)
    fig3, _ = plot_palette(pal, title="qual01 (n=8)")
    fig3.savefig(OUT / "output_palette_obj.png", dpi=120)
    print("已保存 Palette 对象预览: output_palette_obj.png")

    # 4. 预览任意自定义颜色列表
    fig4, _ = plot_palette(["#FF0000", "#00FF00", "#0000FF"], title="custom RGB")
    fig4.savefig(OUT / "output_custom.png", dpi=120)
    print("已保存自定义颜色预览: output_custom.png")


if __name__ == "__main__":
    main()
