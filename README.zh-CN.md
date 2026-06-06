| 语言 / Language | 版本                               |
|-----------------|------------------------------------|
| 🇨🇳 中文         | [README.zh-CN.md](README.zh-CN.md) |
| 🇺🇸 English      | [README.md](README.md)             |

# chinacolor：中国传统色（Python / matplotlib）

> 本仓库基于纸质书籍《中国传统色：故宫里的色彩美学》制作，并参考了以下两个开源项目：
>
> - [zhiming-chen/chinacolor](https://github.com/zhiming-chen/chinacolor)
> - [daodaolee/china-color](https://github.com/daodaolee/china-color)
>
> 在此向原书作者与上述项目致谢。本仓库是面向 Python + matplotlib 生态的实现。

将 384 种中国传统色与 60 组内置调色板带入 Python，配合 matplotlib 提供调色板构建、自动配色、colormap/颜色循环、预览与主题样式等能力。

## 功能概览

- **384 种中国传统色目录**：完整的颜色数据（中文名、HEX、分组、节气与多种色彩空间数值）
- **60 组内置调色板**：连续型（`seq01`–`seq20`）、发散型（`div01`–`div20`）、定性型（`qual01`–`qual20`）各 20 组
- **调色板构建**：`ctc_palette()` 支持内置调色板与自定义抓色，含数量插值/裁剪、方向反转与类型元数据
- **10 个自动配色函数**：基于色彩理论从基色衍生配色方案，可映射到中国传统色
- **matplotlib 集成**：`to_colormap()` / `to_color_cycle()` / `to_listed_colormap()`
- **可视化预览**：`plot_color_grid()` / `plot_palette()` / `plot_palettes()`
- **中国风主题**：5 款 matplotlib 主题（青铜、敦煌、水墨、矿物、宣纸）

## 安装

```bash
pip install -e .
# 或在 pixi 环境中
pixi install
```

依赖：Python ≥ 3.10、matplotlib ≥ 3.10、numpy ≥ 2.4。

## 快速开始

```python
from chinacolor import list_colors, list_palettes, ctc_palette, to_colormap, plot_palette

# 颜色与调色板目录
colors = list_colors()         # 384 条颜色记录
palettes = list_palettes()     # 60 组调色板信息

# 构建调色板并转成 matplotlib colormap
seq01 = ctc_palette(type="built_in", palette_name="seq01", n=6)
cmap = to_colormap(seq01)

# 预览单个调色板
fig, ax = plot_palette("seq01")
```

## 主要 API

| 类别 | 函数 |
|------|------|
| 颜色目录 | `list_colors()`、`get_color()` |
| 调色板目录 | `list_palettes()`、`get_palette_record()` |
| 调色板构建 | `ctc_palette()`、`create_color_pick()` |
| 自动配色 | `monochromatic_palette()`、`analogous_palette()`、`harmonic_palette()`、`triadic_palette()`、`complementary_palette()`、`split_complementary_palette()`、`compound_antipodal_palette()`、`compound_concyclic_palette()`、`diverging_palette()`、`intermediate_palette()` |
| matplotlib 集成 | `to_colormap()`、`to_color_cycle()`、`to_listed_colormap()` |
| 可视化 | `plot_color_grid()`、`plot_palette()`、`plot_palettes()` |
| 主题样式 | `apply_theme()`、`use_theme()`、`get_theme()` |
| 中文字体（可选） | `setup_chinese_font()` |

## 中文显示（可选）

为保持轻量、不污染全局 matplotlib 配置，本包**默认不加载中文字体**。若图中包含中文（颜色名、调色板中文名、中文轴标签等），请在绘图前显式调用一次：

```python
from chinacolor import setup_chinese_font

setup_chinese_font()   # 加载内置 NotoSansSC 字体
```

不调用则保持 matplotlib 默认字体，纯数值/英文图表不受影响。

## 示例

`examples/` 目录下提供 11 个完整示例，每个都含可独立运行的 Python 脚本与说明文档：

```bash
# 运行单个示例
pixi run python examples/01_list_colors/example.py

# 运行全部示例
pixi run python examples/run_all.py
```

详见 [examples/README.md](examples/README.md)。

## 调色板预览

<img src="image/palettes/palette_3.png" width="600" />

<img src="image/palettes/palette_33.png" width="600" />

<img src="image/palettes/palette_59.png" width="600" />

内置调色板分三种类型，各 20 组：

- 连续型（sequential）：`seq01`–`seq20`，索引 1–20
- 发散型（diverging）：`div01`–`div20`，索引 21–40
- 定性型（qualitative）：`qual01`–`qual20`，索引 41–60

每组调色板都有标准名、中文名与英文名，可用任一标识符查询。

## 致谢与来源

- 纸质书籍：《中国传统色：故宫里的色彩美学》
- 参考项目：[zhiming-chen/chinacolor](https://github.com/zhiming-chen/chinacolor)、[daodaolee/china-color](https://github.com/daodaolee/china-color)
