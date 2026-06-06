# 示例 09：连续/发散型 colormap（to_colormap）

## 功能

把连续型（`seq*`）或发散型（`div*`）调色板转换成 matplotlib 的 colormap，用于热图、等高线、`imshow`、连续着色散点等场景。

## API

### `to_colormap(palette, name=None)`

- `palette`：标准名、索引、`Palette` 对象或颜色列表。
- 行为按调色板类型自动区分：
  - **连续型 / 发散型** → 返回 `LinearSegmentedColormap`（平滑渐变）。
  - **定性型** → 返回 `ListedColormap`（离散）。
- `name`：colormap 名称。

返回的 colormap 可直接传给 `imshow(cmap=...)`、`scatter(cmap=...)` 等。

> 发散型建议配合 `matplotlib.colors.TwoSlopeNorm(vcenter=0)` 使用，使中性色对齐数据零点。

## 运行

```bash
pixi run python examples/09_continuous_colormap/example.py
```

输出：`output_colormap.png`，含热图、发散型中心对齐热图、连续着色散点三联图。

## 用法补充

发散型建议配合 `TwoSlopeNorm` 让中性色对齐数据零点：

```python
cmap = to_colormap("div12")
norm = matplotlib.colors.TwoSlopeNorm(vcenter=0)
ax.imshow(z, cmap=cmap, norm=norm)
```
