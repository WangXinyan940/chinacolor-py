| 语言 / Language | 版本                               |
|-----------------|------------------------------------|
| 🇨🇳 中文         | [README.zh-CN.md](README.zh-CN.md) |
| 🇺🇸 English      | [README.md](README.md)             |

# chinacolor: Chinese Traditional Colors (Python / matplotlib)

> This repository is built from the printed book *Chinese Traditional Colors: Color Aesthetics in the Forbidden City* (《中国传统色：故宫里的色彩美学》), and references the following open-source projects:
>
> - [zhiming-chen/chinacolor](https://github.com/zhiming-chen/chinacolor)
> - [daodaolee/china-color](https://github.com/daodaolee/china-color)
>
> Many thanks to the original author and the projects above. This repository is a Python + matplotlib implementation.

Brings 384 traditional Chinese colors and 60 built-in palettes into Python, with matplotlib helpers for palette construction, automatic color generation, colormaps/color cycles, previews, and themes.

## Features

- **384 traditional colors**: full data (Chinese name, HEX, grouping, solar term, and multiple color-space values)
- **60 built-in palettes**: sequential (`seq01`–`seq20`), diverging (`div01`–`div20`), qualitative (`qual01`–`qual20`), 20 each
- **Palette construction**: `ctc_palette()` for built-in and custom palettes, with interpolation/cropping, direction reversal, and type metadata
- **10 automatic palette generators**: derive schemes from a base color via color theory, optionally mapped to traditional colors
- **matplotlib integration**: `to_colormap()` / `to_color_cycle()` / `to_listed_colormap()`
- **Previews**: `plot_color_grid()` / `plot_palette()` / `plot_palettes()`
- **Chinese-style themes**: 5 matplotlib themes (bronze, dunhuang, ink, mineral, paper)

## Installation

```bash
pip install -e .
# or, within a pixi environment
pixi install
```

Requirements: Python ≥ 3.10, matplotlib ≥ 3.10, numpy ≥ 2.4.

## Quick Start

```python
from chinacolor import list_colors, list_palettes, ctc_palette, to_colormap, plot_palette

# Color and palette catalogs
colors = list_colors()         # 384 color records
palettes = list_palettes()     # 60 palette records

# Build a palette and convert to a matplotlib colormap
seq01 = ctc_palette(type="built_in", palette_name="seq01", n=6)
cmap = to_colormap(seq01)

# Preview a single palette
fig, ax = plot_palette("seq01")
```

## Main API

| Category | Functions |
|----------|-----------|
| Color catalog | `list_colors()`, `get_color()` |
| Palette catalog | `list_palettes()`, `get_palette_record()` |
| Palette construction | `ctc_palette()`, `create_color_pick()` |
| Automatic palettes | `monochromatic_palette()`, `analogous_palette()`, `harmonic_palette()`, `triadic_palette()`, `complementary_palette()`, `split_complementary_palette()`, `compound_antipodal_palette()`, `compound_concyclic_palette()`, `diverging_palette()`, `intermediate_palette()` |
| matplotlib integration | `to_colormap()`, `to_color_cycle()`, `to_listed_colormap()` |
| Visualization | `plot_color_grid()`, `plot_palette()`, `plot_palettes()` |
| Themes | `apply_theme()`, `use_theme()`, `get_theme()` |
| Chinese font (optional) | `setup_chinese_font()` |

## Chinese Text Rendering (Optional)

To stay lightweight and avoid mutating global matplotlib config, this package **does not load a Chinese font by default**. If your figure contains Chinese text (color names, Chinese palette names, Chinese axis labels), call this once before plotting:

```python
from chinacolor import setup_chinese_font

setup_chinese_font()   # loads the bundled NotoSansSC font
```

Without it, matplotlib keeps its default font; numeric/English-only charts are unaffected.

## Examples

The `examples/` directory contains 11 complete examples, each with a standalone Python script and documentation:

```bash
# Run a single example
pixi run python examples/01_list_colors/example.py

# Run all examples
pixi run python examples/run_all.py
```

See [examples/README.md](examples/README.md).

## Palette Preview

<img src="image/palettes/palette_3.png" width="600" />

<img src="image/palettes/palette_33.png" width="600" />

<img src="image/palettes/palette_59.png" width="600" />

Built-in palettes come in three types, 20 each:

- sequential: `seq01`–`seq20`, index 1–20
- diverging: `div01`–`div20`, index 21–40
- qualitative: `qual01`–`qual20`, index 41–60

Each palette has a standard name, a Chinese name, and an English name, and can be queried by any of them.

## Credits & Sources

- Printed book: *Chinese Traditional Colors: Color Aesthetics in the Forbidden City*
- Reference projects: [zhiming-chen/chinacolor](https://github.com/zhiming-chen/chinacolor), [daodaolee/china-color](https://github.com/daodaolee/china-color)
