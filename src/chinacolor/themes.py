from contextlib import contextmanager
from pathlib import Path

import matplotlib as mpl
from matplotlib import font_manager


THEMES = {
    "bronze": {
        "axes.facecolor": "#F4EDE2",
        "figure.facecolor": "#FCF8F2",
        "axes.edgecolor": "#6E4B3A",
        "axes.labelcolor": "#3E2A22",
        "xtick.color": "#3E2A22",
        "ytick.color": "#3E2A22",
        "grid.color": "#C8AC8A",
        "text.color": "#3E2A22",
    },
    "dunhuang": {
        "axes.facecolor": "#FFF6E8",
        "figure.facecolor": "#FFF9F1",
        "axes.edgecolor": "#8D5B3D",
        "axes.labelcolor": "#6A3D2D",
        "xtick.color": "#6A3D2D",
        "ytick.color": "#6A3D2D",
        "grid.color": "#D8B28A",
        "text.color": "#6A3D2D",
    },
    "ink": {
        "axes.facecolor": "#F7F7F5",
        "figure.facecolor": "#FFFFFF",
        "axes.edgecolor": "#2E2E2E",
        "axes.labelcolor": "#1F1F1F",
        "xtick.color": "#1F1F1F",
        "ytick.color": "#1F1F1F",
        "grid.color": "#B8B8B8",
        "text.color": "#1F1F1F",
    },
    "mineral": {
        "axes.facecolor": "#F2F7F7",
        "figure.facecolor": "#F9FCFC",
        "axes.edgecolor": "#31525B",
        "axes.labelcolor": "#274047",
        "xtick.color": "#274047",
        "ytick.color": "#274047",
        "grid.color": "#8FB6C1",
        "text.color": "#274047",
    },
    "paper": {
        "axes.facecolor": "#FFFDF8",
        "figure.facecolor": "#FFFDF8",
        "axes.edgecolor": "#7F6A52",
        "axes.labelcolor": "#4C4032",
        "xtick.color": "#4C4032",
        "ytick.color": "#4C4032",
        "grid.color": "#DDD0BC",
        "text.color": "#4C4032",
    },
}


def setup_chinese_font() -> str | None:
    font_path = Path(__file__).resolve().parents[2] / "inst" / "fonts" / "NotoSansSC-VariableFont_wght.ttf"
    if not font_path.exists():
        return None
    font_manager.fontManager.addfont(font_path)
    font_name = font_manager.FontProperties(fname=font_path).get_name()
    mpl.rcParams["font.family"] = [font_name]
    mpl.rcParams["axes.unicode_minus"] = False
    return font_name


def get_theme(name: str) -> dict[str, object]:
    key = name.lower().replace("theme_ctc_", "")
    if key not in THEMES:
        raise KeyError(f"未找到主题: {name}")
    return THEMES[key].copy()


def apply_theme(name: str) -> dict[str, object]:
    theme = get_theme(name)
    mpl.rcParams.update(theme)
    return theme


@contextmanager
def use_theme(name: str):
    theme = get_theme(name)
    with mpl.rc_context(theme):
        yield theme
