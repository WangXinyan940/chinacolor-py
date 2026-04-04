import matplotlib

matplotlib.use("Agg")

from matplotlib.colors import ListedColormap

from chinacolor import apply_theme, ctc_palette, plot_color_grid, plot_palette, plot_palettes, to_color_cycle, to_colormap, to_listed_colormap


def test_matplotlib_colormap_helpers_work():
    palette = ctc_palette(type="built_in", palette_name="seq01")
    cmap = to_colormap(palette)
    listed = to_listed_colormap("qual01")
    cycle = to_color_cycle("qual01")
    assert cmap.N >= len(palette.colors)
    assert isinstance(listed, ListedColormap)
    assert "color" in cycle.keys


def test_plot_functions_return_figure_objects():
    fig1, axes1 = plot_color_grid(show_group=False)
    fig2, ax2 = plot_palette("seq01")
    fig3, axes3 = plot_palettes(["seq01", "div01", "qual01"])
    assert fig1 is not None
    assert axes1 is not None
    assert fig2 is not None
    assert ax2 is not None
    assert fig3 is not None
    assert axes3 is not None


def test_apply_theme_updates_rcparams():
    theme = apply_theme("ink")
    assert theme["axes.facecolor"] == matplotlib.rcParams["axes.facecolor"]
