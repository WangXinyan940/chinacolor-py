# 示例 02：384 色网格图（plot_color_grid）

## 功能

将全部 384 种中国传统色绘制成网格色卡，每个色块标注颜色编号与中文名，便于整体浏览与挑色。

## API

### `plot_color_grid(show_group=False, figsize=(14, 18)) -> (Figure, Axes)`

- `show_group`：是否显示分组信息。
  - `False`（默认）：8 列布局，每个色块显示 `color_id` 与中文名。
  - `True`：4 列布局，额外标注 `G{group_id}-{subgroup_id}`。
- `figsize`：画布尺寸。
- 返回 matplotlib 的 `(Figure, Axes)`，可进一步保存或在 notebook 中显示。

本函数**不会自动加载中文字体**。色块标注包含中文颜色名，若要正确显示，请在绘图前显式调用一次 `setup_chinese_font()`（参见示例脚本）。否则中文会显示为方框。

## 运行

```bash
pixi run python examples/02_plot_color_grid/example.py
```

输出：`output_grid.png`（默认网格）与 `output_grid_group.png`（带分组标签）。
