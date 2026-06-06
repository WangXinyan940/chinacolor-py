# 示例 03：调色板目录查询（list_palettes / get_palette_record）

## 功能

`chinacolor` 内置 60 组调色板，分为三类，各 20 组：

- **sequential（连续型）**：`seq01`–`seq20`，索引 1–20
- **diverging（发散型）**：`div01`–`div20`，索引 21–40
- **qualitative（定性型）**：`qual01`–`qual20`，索引 41–60

每组都有标准名（如 `seq01`）、中文名、英文名。

## API

### `list_palettes() -> list[dict]`

返回全部 60 组调色板信息，每条记录包含：

- `index`：序号（1–60）
- `key`：标准名（如 `seq01`）
- `palette_name` / `palette_name_e`：中/英文名
- `type`：类型（`sequential` / `diverging` / `qualitative`）
- `color_count`：颜色数量
- `hex` / `name`：颜色值列表与颜色名列表

### `get_palette_record(identifier) -> dict`

按以下任一标识符查询单组调色板：

- 整数索引：`get_palette_record(1)`
- 标准名：`get_palette_record("seq01")`
- 中文名 / 英文名：`get_palette_record("earth_autumn")`

查询不到时抛出 `KeyError`。

## 运行

```bash
pixi run python examples/03_list_palettes/example.py
```

输出：终端打印调色板统计、类型分布，以及四种查询方式的结果。
