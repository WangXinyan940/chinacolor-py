"""示例 02：384 色网格图 —— plot_color_grid

绘制全部 384 种中国传统色的网格图，可选显示分组信息（group_id / subgroup_id）。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import plot_color_grid, setup_chinese_font

OUT = Path(__file__).parent


def main() -> None:
    # 中文字体不再自动加载，需要显示中文颜色名时显式调用一次
    setup_chinese_font()

    # 1. 默认网格：8 列布局，仅显示编号与名称
    fig1, _ = plot_color_grid(show_group=False)
    path1 = OUT / "output_grid.png"
    fig1.savefig(path1, dpi=100)
    print(f"已保存默认网格: {path1.name}")

    # 2. 分组网格：4 列布局，附带 group-subgroup 标签
    fig2, _ = plot_color_grid(show_group=True)
    path2 = OUT / "output_grid_group.png"
    fig2.savefig(path2, dpi=100)
    print(f"已保存分组网格: {path2.name}")


if __name__ == "__main__":
    main()
