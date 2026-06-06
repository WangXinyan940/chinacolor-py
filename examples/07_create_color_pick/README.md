# 示例 07：自定义抓色规则（create_color_pick + ctc_palette custom）

## 功能

`create_color_pick()` 构造一个"抓色规则"字典，再交给 `ctc_palette(type="custom")` 从 384 色中挑选颜色，组成完全自定义的调色板。

384 色按 `group_id`（分组）和 `subgroup_id`（子组，每组 1–4）组织，配合具体 `color_id` 可灵活挑色。

## API

### `create_color_pick(color_id=None, groups=None, subgroups=None, order_rule=1) -> dict`

- `color_id`：直接指定的颜色编号列表。
- `groups`：分组编号列表。
- `subgroups`：每个分组对应的子组列表。
  - 与 `groups` 等长，逐组对应；或只给一组用于复用。
  - 缺省为每组取全部子组 `[1, 2, 3, 4]`。
  - 用 `[-1]` 表示子组逆序 `[4, 3, 2, 1]`。
- `order_rule`：排序规则。`1`=保留输入顺序，`0`=按编号升序，`-1`=按编号降序。

### `ctc_palette(type="custom", color_pick=..., palette_type=..., palette_title=...)`

- `color_pick`：上一步构造的规则。
- `palette_type`：声明类型（`sequential` / `diverging` / `qualitative`），非法值归一化为 `qualitative`。

## 运行

```bash
pixi run python examples/07_create_color_pick/example.py
```

输出：终端打印各抓色结果，并生成 `output_color_pick.png`。
