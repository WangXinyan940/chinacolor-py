"""示例 08：自动配色算法 —— 10 个 *_palette 函数

包含 monochromatic_palette / analogous_palette / harmonic_palette /
triadic_palette / complementary_palette / split_complementary_palette /
compound_antipodal_palette / compound_concyclic_palette / diverging_palette /
intermediate_palette。

这些函数基于色彩理论（HLS 色相环）从一个基色自动衍生配色方案，
可选 ctc_colors=True 将结果映射到最接近的中国传统色。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import (
    analogous_palette,
    complementary_palette,
    compound_antipodal_palette,
    compound_concyclic_palette,
    diverging_palette,
    harmonic_palette,
    intermediate_palette,
    monochromatic_palette,
    plot_palettes,
    split_complementary_palette,
    triadic_palette,
)

OUT = Path(__file__).parent
BASE = "#DB9C53"  # 固定基色，保证结果可复现


def main() -> None:
    generators = [
        ("monochromatic", monochromatic_palette),
        ("analogous", analogous_palette),
        ("harmonic", harmonic_palette),
        ("triadic", triadic_palette),
        ("complementary", complementary_palette),
        ("split_complementary", split_complementary_palette),
        ("compound_antipodal", compound_antipodal_palette),
        ("compound_concyclic", compound_concyclic_palette),
        ("diverging", diverging_palette),
        ("intermediate", intermediate_palette),
    ]

    # 1. 直接生成（HLS 计算色，不映射到传统色）
    palettes = []
    for name, fn in generators:
        pal = fn(base_color=BASE, n=6)
        palettes.append(pal)
        print(f"{name:<22} type={pal.palette_type:<11} colors={pal.as_list()}")

    fig, _ = plot_palettes(palettes)
    fig.savefig(OUT / "output_auto.png", dpi=100)
    print("\n已保存自动配色对比图: output_auto.png")

    # 2. 映射到最接近的中国传统色（ctc_colors=True）
    mapped = [fn(base_color=BASE, n=6, ctc_colors=True) for _, fn in generators]
    fig2, _ = plot_palettes(mapped)
    fig2.savefig(OUT / "output_auto_ctc.png", dpi=100)
    print("已保存映射到传统色的对比图: output_auto_ctc.png")


if __name__ == "__main__":
    main()
