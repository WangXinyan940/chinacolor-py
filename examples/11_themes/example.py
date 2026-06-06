"""示例 11：中国风主题样式 —— apply_theme / use_theme / get_theme

通过 matplotlib rcParams 应用中国传统风格主题（背景、网格、文字、边框配色）。
内置 5 款主题：bronze / dunhuang / ink / mineral / paper。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

from chinacolor import get_theme, setup_chinese_font, to_color_cycle, use_theme

OUT = Path(__file__).parent
THEMES = ["bronze", "dunhuang", "ink", "mineral", "paper"]


def _demo_plot(ax) -> None:
    ax.set_prop_cycle(to_color_cycle("qual01"))
    x = np.linspace(0, 10, 50)
    for i in range(4):
        ax.plot(x, np.sin(x + i), linewidth=2, label=f"L{i+1}")
    ax.grid(True)
    ax.set_xlabel("x 轴")
    ax.set_ylabel("y 轴")
    ax.legend(fontsize=7)


def main() -> None:
    # 图中含中文轴标签，主题函数已不再自动加载字体，需显式调用
    setup_chinese_font()

    # 1. get_theme：取出某主题的 rcParams 字典（不改全局状态）
    ink = get_theme("ink")
    print(f"get_theme('ink') 键: {list(ink.keys())}")

    # 2. use_theme：上下文管理器，仅在 with 块内生效（推荐，避免污染全局）
    fig, axes = plt.subplots(2, 3, figsize=(16, 9))
    flat = axes.ravel()
    for ax, theme_name in zip(flat, THEMES):
        with use_theme(theme_name):
            new_ax = fig.add_subplot(ax.get_subplotspec())
            ax.remove()
            new_ax.set_title(f"theme_ctc_{theme_name}", fontsize=12)
            _demo_plot(new_ax)
    flat[-1].axis("off")
    fig.suptitle("chinacolor matplotlib 主题样式", fontsize=16)
    fig.tight_layout()
    fig.savefig(OUT / "output_themes.png", dpi=100)
    print("已保存主题对比图: output_themes.png")

    # 3. apply_theme：直接修改全局 rcParams（影响后续所有图）
    #    这里演示后随即用 rcdefaults 还原，避免影响其它示例。
    from chinacolor import apply_theme

    apply_theme("dunhuang")
    print("apply_theme('dunhuang') 已写入全局 rcParams")
    matplotlib.rcdefaults()


if __name__ == "__main__":
    main()
