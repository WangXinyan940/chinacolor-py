from typing import Any

from ._models import Palette
from ._utils import cycle_to_length, interpolate_colors, validate_colors
from .catalog import get_palette_record, list_colors


def create_color_pick(
    color_id: list[int] | None = None,
    groups: list[int] | None = None,
    subgroups: list[int] | list[list[int]] | None = None,
    order_rule: int = 1,
) -> dict[str, Any]:
    if order_rule not in {1, 0, -1}:
        raise ValueError("order_rule 必须是 1、0 或 -1")
    payload: dict[str, Any] = {"order": order_rule}
    if color_id is not None:
        payload["color_id"] = list(color_id)
    if groups is not None:
        if subgroups is None:
            subgroup_list = [list(range(1, 5)) for _ in groups]
        elif isinstance(subgroups, list) and subgroups and not isinstance(subgroups[0], list):
            subgroup_list = [list(subgroups) for _ in groups]
        else:
            subgroup_list = [list(item) for item in subgroups]
        if len(subgroup_list) == 1 and len(groups) > 1:
            subgroup_list = subgroup_list * len(groups)
        if len(subgroup_list) != len(groups):
            raise ValueError("subgroups 长度必须与 groups 一致，或只提供一组用于复用")
        payload["group_info"] = {"group": list(groups), "subgroup": subgroup_list}
    return payload


def _normalize_palette_type(palette_type: str) -> str:
    if palette_type not in {"sequential", "diverging", "qualitative"}:
        return "qualitative"
    return palette_type


def _resolve_subgroups(subgroups: list[int]) -> list[int]:
    if subgroups == [-1] or subgroups == [-1,]:
        return [4, 3, 2, 1]
    if not all(value in {1, 2, 3, 4} for value in subgroups):
        raise ValueError("subgroups 只支持 1-4 或单独的 -1")
    return subgroups


def _built_in_palette(palette_name: int | str, n: int | None, direction: int, palette_title: str | None) -> Palette:
    record = get_palette_record(palette_name)
    base_colors = validate_colors(record["hex"])
    base_count = int(record["color_count"])
    palette_type = record["type"]
    if n is None:
        colors = base_colors
    elif n > base_count:
        if palette_type in {"sequential", "diverging"}:
            colors = interpolate_colors(base_colors, n)
        else:
            colors = cycle_to_length(base_colors, n)
    elif palette_type == "diverging":
        mid = (base_count + 1) // 2 - 1
        if n == 1:
            colors = [base_colors[mid]]
        else:
            left_count = (n - 1) // 2
            right_count = (n - 1) - left_count
            start = max(0, mid - left_count)
            end = min(base_count, mid + right_count + 1)
            colors = base_colors[start:end]
            while len(colors) < n and start > 0:
                start -= 1
                colors = base_colors[start:end]
    else:
        colors = base_colors[:n]
    if direction not in {1, -1}:
        direction = 1
    if direction == -1:
        colors = list(reversed(colors))
    return Palette(
        colors=tuple(colors),
        palette_type=palette_type,
        key=record["key"],
        name=palette_title or record["palette_name"],
        english_name=record["palette_name_e"],
        ctc_colors=True,
    )


def _custom_palette(
    color_pick: dict[str, Any] | None,
    n: int | None,
    palette_title: str | None,
    palette_type: str,
) -> Palette:
    if not color_pick:
        raise ValueError("type='custom' 时必须提供 color_pick")
    colors = list_colors()
    selected_ids: list[int] = []
    group_info = color_pick.get("group_info", {})
    groups = group_info.get("group", [])
    subgroups = group_info.get("subgroup", [])
    if groups and not subgroups:
        subgroups = [list(range(1, 5)) for _ in groups]
    for group, subgroup_order in zip(groups, subgroups):
        resolved = _resolve_subgroups(list(subgroup_order))
        group_records = [record for record in colors if int(record["group_id"]) == int(group)]
        for subgroup in resolved:
            subgroup_ids = [int(record["color_id"]) for record in group_records if int(record["subgroup_id"]) == int(subgroup)]
            selected_ids.extend(subgroup_ids)
    explicit_ids = [int(value) for value in color_pick.get("color_id", [])]
    valid_ids = {int(record["color_id"]) for record in colors}
    selected_ids.extend([value for value in explicit_ids if value in valid_ids])
    unique_ids = []
    seen = set()
    for value in selected_ids:
        if value not in seen:
            seen.add(value)
            unique_ids.append(value)
    if not unique_ids:
        raise ValueError("没有匹配到任何颜色")
    if color_pick.get("order", 1) == 0:
        unique_ids = sorted(unique_ids)
    elif color_pick.get("order", 1) == -1:
        unique_ids = sorted(unique_ids, reverse=True)
    palette_colors = []
    for value in unique_ids:
        for record in colors:
            if int(record["color_id"]) == value:
                palette_colors.append(record["hex"])
                break
    if n is not None:
        palette_colors = cycle_to_length(palette_colors, n) if n > len(palette_colors) else palette_colors[:n]
    return Palette(
        colors=tuple(validate_colors(palette_colors)),
        palette_type=_normalize_palette_type(palette_type),
        name=palette_title or "unnamed palette",
        ctc_colors=True,
    )


def ctc_palette(
    type: str = "built_in",
    palette_name: int | str | None = None,
    n: int | None = None,
    direction: int = 1,
    color_pick: dict[str, Any] | None = None,
    palette_title: str | None = None,
    palette_type: str = "qualitative",
) -> Palette:
    if type == "built_in":
        if palette_name is None:
            raise ValueError("type='built_in' 时必须提供 palette_name")
        return _built_in_palette(palette_name=palette_name, n=n, direction=direction, palette_title=palette_title)
    if type == "custom":
        return _custom_palette(color_pick=color_pick, n=n, palette_title=palette_title, palette_type=palette_type)
    raise ValueError("type 只支持 'built_in' 或 'custom'")
