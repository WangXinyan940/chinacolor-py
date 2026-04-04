from dataclasses import dataclass


@dataclass(frozen=True)
class Palette:
    colors: tuple[str, ...]
    palette_type: str
    key: str | None = None
    name: str | None = None
    english_name: str | None = None
    ctc_colors: bool = True

    def __iter__(self):
        return iter(self.colors)

    def __len__(self) -> int:
        return len(self.colors)

    def __getitem__(self, index: int) -> str:
        return self.colors[index]

    @property
    def n(self) -> int:
        return len(self.colors)

    def as_list(self) -> list[str]:
        return list(self.colors)
