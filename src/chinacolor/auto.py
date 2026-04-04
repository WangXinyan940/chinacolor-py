import numpy as np

from ._models import Palette
from ._utils import (
    choose_base_color,
    distribute_across_anchors,
    ensure_hue_range,
    find_closest_colors,
    get_lightness_values,
    hex_to_hls,
    hls_to_hex,
    ordered_color_set,
    validate_colors,
)
from .catalog import list_colors


def _ctc_hexes() -> list[str]:
    return [record["hex"] for record in list_colors()]


def _map_to_ctc(colors: list[str], ctc_colors: bool) -> list[str]:
    normalized = validate_colors(colors)
    if not ctc_colors:
        return normalized
    return find_closest_colors(normalized, _ctc_hexes())


def _palette(colors: list[str], palette_type: str, ctc_colors: bool, name: str) -> Palette:
    return Palette(colors=tuple(_map_to_ctc(colors, ctc_colors)), palette_type=palette_type, name=name, ctc_colors=ctc_colors)


def monochromatic_palette(
    base_color: str | None = None,
    lightness_range: tuple[float, float] = (15.0, 95.0),
    n: int = 6,
    ctc_colors: bool = False,
) -> Palette:
    base = choose_base_color(base_color, _ctc_hexes())
    hue, lightness, saturation = hex_to_hls(base)
    values = get_lightness_values(n=n, base_lightness=lightness * 100.0, lightness_range=lightness_range)
    colors = [hls_to_hex(hue * 360.0, value, saturation) for value in values]
    return _palette(colors, "sequential", ctc_colors, "monochromatic")


def analogous_palette(
    base_color: str | None = None,
    spread: float = 15.0,
    n: int = 6,
    ctc_colors: bool = False,
) -> Palette:
    base = choose_base_color(base_color, _ctc_hexes())
    hue, lightness, saturation = hex_to_hls(base)
    offsets = np.linspace(-spread * max(n - 1, 1) / 2.0, spread * max(n - 1, 1) / 2.0, n)
    colors = [hls_to_hex(ensure_hue_range(hue * 360.0 + offset), lightness, saturation) for offset in offsets]
    return _palette(colors, "sequential", ctc_colors, "analogous")


def harmonic_palette(base_color: str | None = None, n: int = 4, ctc_colors: bool = False) -> Palette:
    base = choose_base_color(base_color, _ctc_hexes())
    hue, lightness, saturation = hex_to_hls(base)
    colors = [hls_to_hex(ensure_hue_range(hue * 360.0 + index * 360.0 / n), lightness, saturation) for index in range(n)]
    return _palette(colors, "qualitative", ctc_colors, "harmonic")


def _anchor_palette(
    base_color: str | None,
    anchor_offsets: list[float],
    n: int,
    palette_type: str,
    name: str,
    ctc_colors: bool,
) -> Palette:
    base = choose_base_color(base_color, _ctc_hexes())
    hue, lightness, saturation = hex_to_hls(base)
    counts = distribute_across_anchors(len(anchor_offsets), n)
    colors: list[str] = []
    for offset, count in zip(anchor_offsets, counts):
        if count <= 0:
            continue
        anchor_hue = ensure_hue_range(hue * 360.0 + offset)
        values = np.linspace(max(lightness - 0.18, 0.12), min(lightness + 0.18, 0.88), count)
        colors.extend(hls_to_hex(anchor_hue, float(value), saturation) for value in values)
    if palette_type == "sequential":
        colors = ordered_color_set(colors)
    return _palette(colors[:n], palette_type, ctc_colors, name)


def triadic_palette(base_color: str | None = None, n: int = 6, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 120.0, 240.0], n, "qualitative", "triadic", ctc_colors)


def complementary_palette(base_color: str | None = None, n: int = 6, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 180.0], n, "qualitative", "complementary", ctc_colors)


def split_complementary_palette(base_color: str | None = None, n: int = 6, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 150.0, 210.0], n, "qualitative", "split_complementary", ctc_colors)


def antipodal_palette(base_color: str | None = None, n: int = 8, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 45.0, 180.0, 225.0], n, "qualitative", "antipodal", ctc_colors)


def concyclic_palette(base_color: str | None = None, n: int = 8, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 45.0, 135.0, 180.0], n, "qualitative", "concyclic", ctc_colors)


def intermediate_palette(base_color: str | None = None, n: int = 8, ctc_colors: bool = False) -> Palette:
    return _anchor_palette(base_color, [0.0, 90.0, 180.0, 270.0], n, "qualitative", "intermediate", ctc_colors)


def diverging_palette(
    base_color: str | None = None,
    lightness_range: tuple[float, float] = (15.0, 95.0),
    n: int = 7,
    angle: float = 180.0,
    ctc_colors: bool = False,
) -> Palette:
    base = choose_base_color(base_color, _ctc_hexes())
    hue, lightness, saturation = hex_to_hls(base)
    left_n = max(1, n // 2)
    right_n = max(1, n - left_n - 1)
    left_values = get_lightness_values(left_n, lightness * 100.0, lightness_range)
    right_values = get_lightness_values(right_n, lightness * 100.0, lightness_range)
    left = [hls_to_hex(hue * 360.0, value, saturation) for value in left_values]
    right = [hls_to_hex(ensure_hue_range(hue * 360.0 + angle), value, saturation) for value in right_values]
    center = [hls_to_hex(hue * 360.0, 0.96, min(saturation * 0.12, 0.1))]
    colors = ordered_color_set(left, direction=1) + center + ordered_color_set(right, direction=2)
    return _palette(colors[:n], "diverging", ctc_colors, "diverging")


def compound_antipodal_palette(base_color: str | None = None, n: int = 8, ctc_colors: bool = False) -> Palette:
    return antipodal_palette(base_color=base_color, n=n, ctc_colors=ctc_colors)


def compound_concyclic_palette(base_color: str | None = None, n: int = 8, ctc_colors: bool = False) -> Palette:
    return concyclic_palette(base_color=base_color, n=n, ctc_colors=ctc_colors)
