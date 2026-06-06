# 示例 04：预览单个调色板（plot_palette）

## 功能

将单组调色板绘制成横向色条，每个色块下方标注序号，顶部显示标题，便于快速预览配色效果。

## API

### `plot_palette(palette, title=None, figsize=(8, 1.6)) -> (Figure, Axes)`

`palette` 支持多种输入：

- 标准名字符串：`"seq01"`、`"div13"`、`"qual01"`
- 整数索引：`33`（= `div13`）
- 中文名 / 英文名：`"大地金秋"` / `"earth_autumn"`
- `Palette` 对象（来自 `ctc_palette()` 或自动配色函数）
- 任意颜色列表：`["#FF0000", "#00FF00", "#0000FF"]`

参数：

- `title`：自定义标题，缺省时使用调色板名称。
- `figsize`：画布尺寸。

返回 `(Figure, Axes)`。

## 运行

```bash
pixi run python examples/04_plot_palette/example.py
```

输出：`output_builtin.png`、`output_by_index.png`、`output_palette_obj.png`、`output_custom.png`。
