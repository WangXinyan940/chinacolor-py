import json
from functools import lru_cache
from pathlib import Path
from typing import Any


def _repo_root() -> Path:
    return Path(__file__).resolve().parents[2]


def _data_path(filename: str) -> Path:
    package_path = Path(__file__).resolve().parent / "data" / filename
    if package_path.exists():
        return package_path
    return _repo_root() / "data" / filename


@lru_cache(maxsize=1)
def load_colors() -> list[dict[str, Any]]:
    return json.loads(_data_path("chinacolor_full.json").read_text())


@lru_cache(maxsize=1)
def load_palettes() -> dict[str, dict[str, Any]]:
    raw = json.loads(_data_path("palette_list.json").read_text())
    palettes = {}
    for item in raw:
        palette = {str(field): value for field, value in item.items()}
        for field in ["palette_name", "palette_name_e", "description_cn", "description_en", "type", "color_count"]:
            if isinstance(palette.get(field), list) and len(palette[field]) == 1:
                palette[field] = palette[field][0]
        palette["hex"] = list(palette["hex"])
        palette["name"] = list(palette["name"])
        palette["color_count"] = int(palette["color_count"])
        palettes[str(palette["key"])] = palette
    return palettes
