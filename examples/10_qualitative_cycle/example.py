"""示例 10：定性型颜色循环 —— to_color_cycle / to_listed_colormap

把定性型(qual)调色板用于分类着色：折线图/条形图用颜色循环(cycler)，
分类散点/分块图用 ListedColormap。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from chinacolor import to_color_cycle, to_listed_colormap

OUT = Path(__file__).parent


def main() -> None:
    fig, axes = plt.subplots(1, 3, figsize=(15, 4.5))

    # 1. 颜色循环 -> 多条折线
    cycle = to_color_cycle("qual01")
    axes[0].set_prop_cycle(cycle)
    x = np.linspace(0, 2 * np.pi, 100)
    for i in range(6):
        axes[0].plot(x, np.sin(x + i * 0.5), label=f"line {i+1}", linewidth=2)
    axes[0].set_title("qual01 -> color cycle (lines)")
    axes[0].legend(fontsize=8)

    # 2. 颜色循环 -> 分组条形图
    cycle2 = to_color_cycle("qual05")
    colors = [c["color"] for c in cycle2]
    cats = ["A", "B", "C", "D", "E"]
    vals = [5, 8, 3, 7, 6]
    axes[1].bar(cats, vals, color=colors[: len(cats)])
    axes[1].set_title("qual05 -> bar chart")

    # 3. ListedColormap -> 分类散点
    listed = to_listed_colormap("qual10")
    rng = np.random.default_rng(0)
    n = 200
    labels = rng.integers(0, listed.N, size=n)
    px, py = rng.normal(size=n), rng.normal(size=n)
    sc = axes[2].scatter(px, py, c=labels, cmap=listed, s=30)
    axes[2].set_title("qual10 -> categorical scatter")
    fig.colorbar(sc, ax=axes[2], fraction=0.046)

    fig.tight_layout()
    fig.savefig(OUT / "output_qualitative.png", dpi=110)
    print("已保存定性型示例: output_qualitative.png")
    print(f"qual01 cycle 颜色数: {len(list(cycle))}")
    print(f"qual10 ListedColormap N: {listed.N}")


if __name__ == "__main__":
    main()
