# 示例 11：中国风主题样式（apply_theme / use_theme / get_theme）

## 功能

通过 matplotlib 的 rcParams 应用中国传统风格主题，统一图表的背景、网格、文字与边框配色。

内置 5 个主题：

| 主题 | 风格灵感 |
|---|---|
| `bronze` | 青铜器 |
| `dunhuang` | 敦煌 |
| `ink` | 水墨 |
| `mineral` | 矿物 |
| `paper` | 宣纸 |

## API

### `get_theme(name) -> dict`

返回主题对应的 rcParams 字典，**不改变全局状态**。`name` 可写 `"ink"` 或 `"theme_ctc_ink"`。

### `apply_theme(name) -> dict`

把主题写入全局 `matplotlib.rcParams`，影响后续所有图。

### `use_theme(name)`（上下文管理器）

仅在 `with` 块内生效，退出后自动还原，**推荐**用于避免污染全局配置。

```python
with use_theme("ink"):
    fig, ax = plt.subplots()
    ax.plot(...)
```

> 注意：主题函数**不再自动加载中文字体**。若图中含中文（标题、轴标签等），请先显式调用 `setup_chinese_font()`。

## 运行

```bash
pixi run python examples/11_themes/example.py
```

输出：`output_themes.png`，5 个主题的折线图对比。

## 用法补充

推荐用 `use_theme` 上下文管理器，仅在 `with` 块内生效：

```python
with use_theme("ink"):
    fig, ax = plt.subplots()
    ax.set_prop_cycle(to_color_cycle("qual01"))
    ax.plot(...)
```
