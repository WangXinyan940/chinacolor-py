from chinacolor import get_color, get_palette_record, list_colors, list_palettes


def test_list_colors_reads_all_records():
    records = list_colors()
    assert len(records) == 384
    assert {"color_id", "name", "hex", "group_id", "subgroup_id"} <= set(records[0])


def test_get_color_supports_id_and_name():
    first_by_id = get_color(1)
    first_by_name = get_color("黄白游")
    assert first_by_id["hex"] == "#FFF799"
    assert first_by_name["color_id"] == 1


def test_list_palettes_reads_all_records():
    records = list_palettes()
    assert len(records) == 60
    assert records[0]["key"] == "seq01"


def test_get_palette_record_supports_index_and_key():
    seq01 = get_palette_record(1)
    seq02 = get_palette_record("seq02")
    assert seq01["key"] == "seq01"
    assert seq01["type"] == "sequential"
    assert seq02["palette_name_e"] == "blooming_blush"
