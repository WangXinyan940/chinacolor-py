from chinacolor import (
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


def test_all_auto_palettes_return_expected_lengths():
    functions = [
        monochromatic_palette,
        analogous_palette,
        harmonic_palette,
        triadic_palette,
        complementary_palette,
        split_complementary_palette,
        compound_antipodal_palette,
        compound_concyclic_palette,
        diverging_palette,
        intermediate_palette,
    ]
    for function in functions:
        palette = function(base_color="#DB9C53", n=6)
        assert palette.n == 6
        assert all(color.startswith("#") for color in palette.colors)


def test_ctc_color_mapping_returns_builtin_colors():
    palette = analogous_palette(base_color="#DB9C53", n=6, ctc_colors=True)
    assert all(color.startswith("#") for color in palette.colors)
    assert palette.ctc_colors is True
