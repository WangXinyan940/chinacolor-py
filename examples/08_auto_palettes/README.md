# 示例 08：自动配色算法（10 个 *_palette 函数）

## 功能

基于色彩理论从一个**基色**自动衍生出完整配色方案。所有函数都在 HLS 色相环上计算，可选将结果映射到最接近的中国传统色。

## API（10 个函数）

| 函数 | 配色原理 | 默认类型 |
|---|---|---|
| `monochromatic_palette` | 同色相，不同明度 | sequential |
| `analogous_palette` | 邻近色相 | sequential |
| `harmonic_palette` | 等分色相环 | qualitative |
| `triadic_palette` | 三等分（0/120/240°） | qualitative |
| `complementary_palette` | 互补（0/180°） | qualitative |
| `split_complementary_palette` | 分裂互补（0/150/210°） | qualitative |
| `compound_antipodal_palette` | 复合对位（0/45/180/225°） | qualitative |
| `compound_concyclic_palette` | 复合同环（0/45/135/180°） | qualitative |
| `diverging_palette` | 双向发散（含中性中心） | diverging |
| `intermediate_palette` | 四方（0/90/180/270°） | qualitative |

### 通用参数

- `base_color`：基色 HEX。缺省时从 384 色中随机选取。
- `n`：颜色数量。
- `ctc_colors`：`True` 时把生成色映射到最接近的中国传统色（按 RGB 距离、不重复匹配）。

部分函数有专属参数：`monochromatic_palette` / `diverging_palette` 接受 `lightness_range`，`analogous_palette` 接受 `spread`，`diverging_palette` 接受 `angle`。

返回 `Palette` 对象。

## 运行

```bash
pixi run python examples/08_auto_palettes/example.py
```

输出：`output_auto.png`（HLS 计算色）与 `output_auto_ctc.png`（映射到传统色）。

## 说明

- `compound_antipodal_palette()` / `compound_concyclic_palette()` 为对外命名（内部也保留了 `antipodal_palette` / `concyclic_palette` 别名）。
- 给定相同 `base_color` 时结果确定可复现；不指定 `base_color` 时会随机取基色。

```python
pal = analogous_palette(base_color="#DB9C53", n=6, ctc_colors=True)
```
