"""示例 07：自定义抓色规则 —— create_color_pick + ctc_palette(type="custom")

通过分组(group)、子组(subgroup)、具体颜色编号(color_id)与排序规则(order_rule)，
从 384 色中挑选颜色组成自定义调色板。
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")

from chinacolor import create_color_pick, ctc_palette, plot_palettes

OUT = Path(__file__).parent


def main() -> None:
    # 1. 按分组 + 子组抓色
    pick1 = create_color_pick(groups=[1, 2], subgroups=[[1, 2], [1]], order_rule=1)
    pal1 = ctc_palette(type="custom", color_pick=pick1,
                       palette_type="qualitative", palette_title="group 1&2")
    print(f"分组抓色: n={pal1.n}, colors={pal1.as_list()}")

    # 2. 用 -1 反转子组顺序（4,3,2,1）
    pick2 = create_color_pick(groups=[5], subgroups=[-1], order_rule=1)
    pal2 = ctc_palette(type="custom", color_pick=pick2, palette_title="group 5 reversed")
    print(f"子组反序: n={pal2.n}, colors={pal2.as_list()}")

    # 3. 按具体颜色编号抓色
    pick3 = create_color_pick(color_id=[4, 8, 12, 100, 200], order_rule=1)
    pal3 = ctc_palette(type="custom", color_pick=pick3, palette_title="by color_id")
    print(f"按编号抓色: n={pal3.n}, colors={pal3.as_list()}")

    # 4. 声明为发散型，并按编号升序排序
    pick4 = create_color_pick(groups=[10, 20], subgroups=[[1, 2, 3, 4], [1, 2, 3, 4]], order_rule=0)
    pal4 = ctc_palette(type="custom", color_pick=pick4,
                       palette_type="diverging", palette_title="diverging custom")
    print(f"发散型自定义: type={pal4.palette_type}, n={pal4.n}")

    fig, _ = plot_palettes([pal1, pal2, pal3, pal4])
    fig.savefig(OUT / "output_color_pick.png", dpi=110)
    print("\n已保存对比图: output_color_pick.png")


if __name__ == "__main__":
    main()
