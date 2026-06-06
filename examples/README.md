# chinacolor 示例与用法文档

本目录用 Python + matplotlib 演示 `chinacolor` 包的全部公开能力。每个示例都包含：

- 一个可独立运行的 Python 脚本（`example.py`）
- 一份说明文档（`README.md`），讲解功能、参数与输出

## 运行方式

所有脚本都使用 matplotlib 的 `Agg` 后端，运行后会在各自目录生成 `output*.png`：

```bash
# 运行单个示例
pixi run python examples/01_list_colors/example.py

# 运行全部示例
pixi run python examples/run_all.py
```

## 示例索引

| # | 示例 | 演示的 API |
|---|------|-----------|
| 01 | [颜色目录查询](01_list_colors/README.md) | `list_colors`, `get_color` |
| 02 | [384 色网格图](02_plot_color_grid/README.md) | `plot_color_grid` |
| 03 | [调色板目录查询](03_list_palettes/README.md) | `list_palettes`, `get_palette_record` |
| 04 | [预览单个调色板](04_plot_palette/README.md) | `plot_palette` |
| 05 | [批量预览调色板](05_plot_palettes/README.md) | `plot_palettes` |
| 06 | [构建调色板](06_ctc_palette/README.md) | `ctc_palette` |
| 07 | [自定义抓色规则](07_create_color_pick/README.md) | `create_color_pick`, `ctc_palette` |
| 08 | [自动配色算法](08_auto_palettes/README.md) | 10 个 `*_palette` 函数 |
| 09 | [连续/发散型 colormap](09_continuous_colormap/README.md) | `to_colormap` |
| 10 | [定性型颜色循环](10_qualitative_cycle/README.md) | `to_color_cycle`, `to_listed_colormap` |
| 11 | [中国风主题样式](11_themes/README.md) | `apply_theme`, `use_theme`, `get_theme` |

> 说明：自动配色算法（案例 08）基于色彩理论用 HLS 重写；给定相同 `base_color` 时结果确定可复现。

## 中文显示（可选）

为保持轻量、不污染全局 matplotlib 配置，本包**默认不加载中文字体**——所有绘图函数都不会自动改动你的字体设置。

如果图中包含中文（如调色板中文名、颜色名、中文轴标签），请在绘图前**显式**调用一次工具函数：

```python
from chinacolor import setup_chinese_font

setup_chinese_font()   # 加载内置 NotoSansSC 字体；返回字体名，找不到时返回 None
```

不调用则保持 matplotlib 默认字体，中文可能显示为方框——但纯数值/英文图表完全不受影响。
