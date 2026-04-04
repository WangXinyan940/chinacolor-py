from collections.abc import Iterable

import matplotlib.pyplot as plt
import numpy as np
from cycler import cycler
from matplotlib.colors import LinearSegmentedColormap, ListedColormap

from ._models import Palette
from ._utils import validate_colors
from .catalog import get_palette_record, list_colors
from .palettes import ctc_palette
from .themes import setup_chinese_font


def _resolve_palette(palette: Palette | Iterable[str] | int | str) -> Palette:
    if isinstance(palette, Palette):
        return palette
    if isinstance(palette, (int, str)):
        record = get_palette_record(palette)
        return ctc_palette(type="built_in", palette_name=record["key"])
    colors = validate_colors(palette)
    return Palette(colors=tuple(colors), palette_type="qualitative", ctc_colors=False)


def to_colormap(palette: Palette | Iterable[str] | int | str, name: str | None = None):
    resolved = _resolve_palette(palette)
    cmap_name = name or resolved.key or resolved.name or "chinacolor"
    if resolved.palette_type == "qualitative":
        return ListedColormap(list(resolved.colors), name=cmap_name)
    return LinearSegmentedColormap.from_list(cmap_name, list(resolved.colors))


def to_listed_colormap(palette: Palette | Iterable[str] | int | str, name: str | None = None) -> ListedColormap:
    resolved = _resolve_palette(palette)
    cmap_name = name or resolved.key or resolved.name or "chinacolor"
    return ListedColormap(list(resolved.colors), name=cmap_name)


def to_color_cycle(palette: Palette | Iterable[str] | int | str):
    resolved = _resolve_palette(palette)
    return cycler(color=list(resolved.colors))


def plot_color_grid(show_group: bool = False, figsize: tuple[float, float] = (14, 18)):
    setup_chinese_font()
    records = list_colors()
    columns = 4 if show_group else 8
    rows = int(np.ceil(len(records) / columns))
    fig, axes = plt.subplots(rows, columns, figsize=figsize)
    flat_axes = np.atleast_1d(axes).ravel()
    for axis, record in zip(flat_axes, records):
        axis.set_facecolor(record["hex"])
        label = f'{record["color_id"]} {record["name"]}'
        if show_group:
            label = f'{label}\nG{record["group_id"]}-{record["subgroup_id"]}'
        axis.text(0.5, 0.5, label, ha="center", va="center", fontsize=8)
        axis.set_xticks([])
        axis.set_yticks([])
    for axis in flat_axes[len(records):]:
        axis.axis("off")
    fig.tight_layout()
    return fig, axes


def plot_palette(palette: Palette | Iterable[str] | int | str, title: str | None = None, figsize: tuple[float, float] = (8, 1.6)):
    setup_chinese_font()
    resolved = _resolve_palette(palette)
    fig, ax = plt.subplots(figsize=figsize)
    matrix = np.arange(len(resolved.colors)).reshape(1, -1)
    ax.imshow(matrix, aspect="auto", cmap=to_listed_colormap(resolved))
    ax.set_xticks(range(len(resolved.colors)))
    ax.set_xticklabels(range(1, len(resolved.colors) + 1))
    ax.set_yticks([])
    ax.set_title(title or resolved.name or resolved.key or "Palette")
    return fig, ax


def plot_palettes(palettes: Iterable[Palette | Iterable[str] | int | str], figsize: tuple[float, float] | None = None):
    setup_chinese_font()
    resolved = [_resolve_palette(palette) for palette in palettes]
    fig_height = max(1.6 * len(resolved), 2.0)
    fig, axes = plt.subplots(len(resolved), 1, figsize=figsize or (8, fig_height))
    flat_axes = np.atleast_1d(axes).ravel()
    for axis, palette in zip(flat_axes, resolved):
        matrix = np.arange(len(palette.colors)).reshape(1, -1)
        axis.imshow(matrix, aspect="auto", cmap=to_listed_colormap(palette))
        axis.set_xticks(range(len(palette.colors)))
        axis.set_xticklabels(range(1, len(palette.colors) + 1))
        axis.set_yticks([])
        axis.set_title(palette.name or palette.key or "Palette")
    fig.tight_layout()
    return fig, axes
