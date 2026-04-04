from chinacolor import create_color_pick, ctc_palette


def test_built_in_palette_preserves_type_and_count():
    palette = ctc_palette(type="built_in", palette_name="seq01", n=4)
    assert palette.palette_type == "sequential"
    assert palette.n == 4


def test_diverging_palette_uses_middle_when_shrinking():
    palette = ctc_palette(type="built_in", palette_name=22, n=5)
    assert palette.palette_type == "diverging"
    assert palette.n == 5


def test_custom_palette_uses_group_and_order():
    color_pick = create_color_pick(groups=[1, 2], subgroups=[[1, 2], [1]], order_rule=1)
    palette = ctc_palette(type="custom", color_pick=color_pick, palette_type="qualitative")
    assert palette.palette_type == "qualitative"
    assert palette.n == 3


def test_qualitative_palette_cycles_when_expanded():
    palette = ctc_palette(type="built_in", palette_name="qual01", n=12)
    assert palette.palette_type == "qualitative"
    assert palette.n == 12
