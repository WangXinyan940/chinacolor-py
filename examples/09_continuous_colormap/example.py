"""示例 09：连续/发散型 colormap —— to_colormap

把连续型(seq)或发散型(div)调色板转成 matplotlib colormap，
用于热图、等高线、散点连续着色等场景。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from chinacolor import ctc_palette, to_colormap

OUT = Path(__file__).parent


def main() -> None:
    # 构造一组二维数据
    x = np.linspace(-3, 3, 200)
    y = np.linspace(-3, 3, 200)
    xx, yy = np.meshgrid(x, y)
    zz = np.exp(-(xx**2 + yy**2)) - 0.5 * np.exp(-((xx - 1) ** 2 + (yy + 1) ** 2))

    fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))

    # 1. 连续型调色板 -> LinearSegmentedColormap（热图）
    seq_cmap = to_colormap("seq06")
    im0 = axes[0].imshow(zz, cmap=seq_cmap, extent=(-3, 3, -3, 3), origin="lower")
    axes[0].set_title("seq06 -> heatmap")
    fig.colorbar(im0, ax=axes[0], fraction=0.046)

    # 2. 发散型调色板 -> colormap，配合 TwoSlopeNorm 以 0 为中心
    div_cmap = to_colormap("div01")
    norm = matplotlib.colors.TwoSlopeNorm(vmin=zz.min(), vcenter=0, vmax=zz.max())
    im1 = axes[1].imshow(zz, cmap=div_cmap, norm=norm, extent=(-3, 3, -3, 3), origin="lower")
    axes[1].set_title("div01 -> diverging (centered at 0)")
    fig.colorbar(im1, ax=axes[1], fraction=0.046)

    # 3. 自定义连续型 Palette -> 散点连续着色
    pal = ctc_palette(type="built_in", palette_name="seq11", n=8)
    rng = np.random.default_rng(42)
    px, py = rng.normal(size=300), rng.normal(size=300)
    sc = axes[2].scatter(px, py, c=px + py, cmap=to_colormap(pal), s=40)
    axes[2].set_title("seq11 Palette -> scatter")
    fig.colorbar(sc, ax=axes[2], fraction=0.046)

    fig.tight_layout()
    fig.savefig(OUT / "output_colormap.png", dpi=110)
    print("已保存 colormap 示例: output_colormap.png")
    print(f"seq06 colormap 类型: {type(seq_cmap).__name__}")
    print(f"div01 colormap 类型: {type(div_cmap).__name__}")


if __name__ == "__main__":
    main()
