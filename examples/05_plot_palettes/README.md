# 示例 05：批量预览调色板（plot_palettes）

## 功能

在一张图中纵向排列多组调色板，方便横向对比、挑选合适的配色方案。

## API

### `plot_palettes(palettes, figsize=None) -> (Figure, Axes)`

- `palettes`：可迭代对象，元素可以是标准名、索引、`Palette` 对象或颜色列表的任意组合。
- `figsize`：缺省时按调色板数量自动计算高度。
- 返回 `(Figure, Axes)`。

## 运行

```bash
pixi run python examples/05_plot_palettes/example.py
```

输出：`output_sequential.png`、`output_mixed.png`、`output_qualitative.png`。
