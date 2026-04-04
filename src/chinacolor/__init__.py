from .auto import (
    analogous_palette,
    complementary_palette,
    compound_antipodal_palette,
    compound_concyclic_palette,
    diverging_palette,
    harmonic_palette,
    intermediate_palette,
    monochromatic_palette,
    split_complementary_palette,
    triadic_palette,
)
from .catalog import get_color, get_palette_record, list_colors, list_palettes
from .mpl import plot_color_grid, plot_palette, plot_palettes, to_color_cycle, to_colormap, to_listed_colormap
from .palettes import create_color_pick, ctc_palette
from .themes import apply_theme, get_theme, use_theme

__all__ = [
    "analogous_palette",
    "apply_theme",
    "complementary_palette",
    "compound_antipodal_palette",
    "compound_concyclic_palette",
    "create_color_pick",
    "ctc_palette",
    "diverging_palette",
    "get_color",
    "get_palette_record",
    "get_theme",
    "harmonic_palette",
    "intermediate_palette",
    "list_colors",
    "list_palettes",
    "monochromatic_palette",
    "plot_color_grid",
    "plot_palette",
    "plot_palettes",
    "split_complementary_palette",
    "to_color_cycle",
    "to_colormap",
    "to_listed_colormap",
    "triadic_palette",
    "use_theme",
]
