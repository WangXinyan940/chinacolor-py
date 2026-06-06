# 示例 06：构建调色板（ctc_palette）

## 功能

`ctc_palette()` 是调色板构建的核心接口。它能从内置调色板（或自定义抓色，见示例 07）生成任意长度的颜色序列，并在调整数量时按调色板类型采用合适的策略。

## API

### `ctc_palette(type="built_in", palette_name=None, n=None, direction=1, color_pick=None, palette_title=None, palette_type="qualitative") -> Palette`

- `type`：`"built_in"`（内置）或 `"custom"`（自定义抓色，见示例 07）。
- `palette_name`：内置调色板标识符（标准名/索引/中文名/英文名）。
- `n`：目标颜色数量。
  - 连续型/发散型且 `n` 超过原色数 → 平滑**插值**。
  - 定性型且 `n` 超过原色数 → **循环**取色。
  - 连续型 `n` 小于原色数 → 取前 `n` 个。
  - 发散型 `n` 小于原色数 → 以中心向两侧裁剪。
- `direction`：`1` 原序，`-1` 反向。
- `palette_title`：自定义名称。

返回 `Palette` 对象，支持迭代、`len()`、索引、`.n`、`.as_list()`、`.palette_type` 等。

## 运行

```bash
pixi run python examples/06_ctc_palette/example.py
```

输出：终端打印各种构建结果，并生成对比图 `output_ctc_palette.png`。
