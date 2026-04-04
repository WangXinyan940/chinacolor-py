from typing import Any

from ._data import load_colors, load_palettes


def list_colors() -> list[dict[str, Any]]:
    return [record.copy() for record in load_colors()]


def get_color(identifier: int | str) -> dict[str, Any]:
    colors = load_colors()
    if isinstance(identifier, int):
        for record in colors:
            if int(record["color_id"]) == identifier:
                return record.copy()
        raise KeyError(f"未找到颜色: {identifier}")
    probe = str(identifier).strip()
    lower_probe = probe.lower()
    for record in colors:
        if record["name"] == probe:
            return record.copy()
        if record["hex"].lower() == lower_probe:
            return record.copy()
        if str(record.get("solar_term_c", "")).lower() == lower_probe:
            return record.copy()
        if str(record.get("solar_term_e", "")).lower() == lower_probe:
            return record.copy()
    raise KeyError(f"未找到颜色: {identifier}")


def list_palettes() -> list[dict[str, Any]]:
    result = []
    for index, (key, palette) in enumerate(load_palettes().items(), start=1):
        result.append(
            {
                "index": index,
                "key": key,
                "palette_name": palette["palette_name"],
                "palette_name_e": palette["palette_name_e"],
                "type": palette["type"],
                "color_count": palette["color_count"],
                "hex": list(palette["hex"]),
                "name": list(palette["name"]),
            }
        )
    return result


def get_palette_record(identifier: int | str) -> dict[str, Any]:
    palettes = load_palettes()
    if isinstance(identifier, int):
        keys = list(palettes.keys())
        if 1 <= identifier <= len(keys):
            key = keys[identifier - 1]
            record = palettes[key].copy()
            record["key"] = key
            return record
        raise KeyError(f"未找到调色板: {identifier}")
    probe = str(identifier).strip()
    lower_probe = probe.lower()
    for key, palette in palettes.items():
        names = [key, palette["palette_name"], palette["palette_name_e"]]
        if any(str(name).lower() == lower_probe for name in names):
            record = palette.copy()
            record["key"] = key
            return record
    raise KeyError(f"未找到调色板: {identifier}")
