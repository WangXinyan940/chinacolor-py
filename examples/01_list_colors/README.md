# 示例 01：颜色目录查询（list_colors / get_color）

## 功能

`chinacolor` 内置 384 种中国传统色，源自《中国传统色：故宫里的色彩美学》。本示例演示如何列出全部颜色、查询单个颜色，并绘制色卡缩略图。

## API

### `list_colors() -> list[dict]`

返回全部 384 条颜色记录。每条记录包含字段：

- `color_id`：颜色编号（1–384）
- `name`：中文名（如 `黄白游`）
- `hex`：十六进制色值（如 `#FFF799`）
- `group_id` / `subgroup_id`：分组与子组编号
- `solar_term_c` / `solar_term_e`：所属节气（中/英）
- 以及 `CMYK_*`、`RGB_*`、`HSV_*`、`LAB_*`、`LUV_*`、`HSL_*` 等色彩空间数值

### `get_color(identifier) -> dict`

按以下任一标识符查询单个颜色：

- 整数：按 `color_id`，如 `get_color(1)`
- 中文名：如 `get_color("黄白游")`
- HEX：如 `get_color("#FFF799")`
- 节气名（中/英）：如 `get_color("立春")`

查询不到时抛出 `KeyError`。

## 运行

```bash
pixi run python examples/01_list_colors/example.py
```

输出：终端打印颜色统计与查询结果，并生成 `output_colors.png`（前 64 色的色卡）。
