# 示例 10：定性型颜色循环（to_color_cycle / to_listed_colormap）

## 功能

把定性型（`qual*`）调色板用于**分类**着色：

- 折线图 / 条形图：用颜色循环（cycler）。
- 分类散点 / 分块图：用 `ListedColormap`。

## API

### `to_color_cycle(palette) -> cycler`

返回 matplotlib `cycler`，可传给 `ax.set_prop_cycle(...)`，后续每条线/每组自动取色。也可用 `[c["color"] for c in cycle]` 取出颜色列表。

### `to_listed_colormap(palette, name=None) -> ListedColormap`

返回离散 `ListedColormap`，适合按整数类别着色（`scatter(c=labels, cmap=...)`）。

两者都接受标准名、索引、`Palette` 对象或颜色列表。

## 运行

```bash
pixi run python examples/10_qualitative_cycle/example.py
```

输出：`output_qualitative.png`，含多线折线图、分组条形图、分类散点三联图。

## 用法补充

```python
# 折线/分组：用颜色循环
ax.set_prop_cycle(to_color_cycle("qual01"))

# 分类散点：用整数标签 + ListedColormap
ax.scatter(x, y, c=labels, cmap=to_listed_colormap("qual10"))
```
