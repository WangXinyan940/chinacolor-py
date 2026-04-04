import colorsys
import random
from collections.abc import Iterable

import numpy as np
from matplotlib import colors as mcolors
from matplotlib.colors import LinearSegmentedColormap


def normalize_hex(value: str) -> str:
    return mcolors.to_hex(value, keep_alpha=False).upper()


def ensure_hue_range(hue: float) -> float:
    return hue % 360.0


def hex_to_hls(value: str) -> tuple[float, float, float]:
    red, green, blue = mcolors.to_rgb(normalize_hex(value))
    return colorsys.rgb_to_hls(red, green, blue)


def hls_to_hex(hue: float, lightness: float, saturation: float) -> str:
    red, green, blue = colorsys.hls_to_rgb((hue % 360.0) / 360.0, min(max(lightness, 0.0), 1.0), min(max(saturation, 0.0), 1.0))
    return mcolors.to_hex((red, green, blue), keep_alpha=False).upper()


def validate_colors(colors: Iterable[str]) -> list[str]:
    return [normalize_hex(color) for color in colors]


def get_lightness_values(n: int, base_lightness: float, lightness_range: tuple[float, float] = (15.0, 95.0)) -> list[float]:
    minimum, maximum = lightness_range
    step = (maximum - minimum) / n
    delta = (base_lightness - minimum) % step
    if base_lightness - minimum < step:
        values = [base_lightness + step * index for index in range(n)]
    elif maximum - base_lightness < step:
        values = [base_lightness - step * index for index in range(n)]
    else:
        values = [minimum + delta + step * index for index in range(n)]
    return [min(max(value, 0.0), 100.0) / 100.0 for value in values]


def ordered_color_set(color_set: Iterable[str], direction: int = 1) -> list[str]:
    colors = validate_colors(color_set)
    ordered = sorted(colors, key=lambda color: hex_to_hls(color)[1])
    return ordered if direction == 1 else list(reversed(ordered))


def interpolate_colors(colors: Iterable[str], n: int) -> list[str]:
    cmap = LinearSegmentedColormap.from_list("chinacolor", validate_colors(colors))
    return [mcolors.to_hex(cmap(value), keep_alpha=False).upper() for value in np.linspace(0.0, 1.0, n)]


def cycle_to_length(colors: Iterable[str], n: int) -> list[str]:
    base = validate_colors(colors)
    if not base:
        return []
    return [base[index % len(base)] for index in range(n)]


def rgb_distance(left: str, right: str) -> float:
    lrgb = np.array(mcolors.to_rgb(left))
    rrgb = np.array(mcolors.to_rgb(right))
    return float(np.linalg.norm(lrgb - rrgb))


def find_closest_colors(target_colors: Iterable[str], ref_colors: Iterable[str]) -> list[str]:
    available = validate_colors(ref_colors)
    matched = []
    for target in validate_colors(target_colors):
        if not available:
            matched.append(target)
            continue
        best = min(available, key=lambda candidate: rgb_distance(target, candidate))
        matched.append(best)
        available.remove(best)
    return matched


def choose_base_color(base_color: str | None, color_pool: Iterable[str]) -> str:
    if base_color is not None:
        return normalize_hex(base_color)
    colors = list(color_pool)
    if not colors:
        raise ValueError("颜色池为空")
    return normalize_hex(random.choice(colors))


def distribute_across_anchors(anchor_count: int, n: int) -> list[int]:
    counts = [n // anchor_count] * anchor_count
    for index in range(n % anchor_count):
        counts[index] += 1
    return counts
