# Matplotlib 版中国传统色 Spec

## Why
当前仓库是一个面向 R 与 ggplot 的中国传统色调色盘包，核心价值在于颜色数据、内置调色板、自动配色算法与绘图集成。为了让 Python 用户在 matplotlib 生态中获得同等能力，需要把现有能力迁移为 Python API、matplotlib colormap/style 接口以及对应的可视化工具。

## What Changes
- 将项目从 R 包主导的交付形态扩展为 Python 包主导的交付形态，提供可安装、可测试、可文档化的 matplotlib 集成能力
- 迁移 384 种中国传统色基础数据与 60 组内置调色板，并在 Python 中提供查询、列出、获取与预览接口
- 迁移 `ctc_palette()` 对应的调色板构建能力，支持内置调色板、自定义抓色、方向调整、数量插值/裁剪与调色板类型元数据
- 迁移 10 个自动生成调色板函数，使其在 Python 中输出可直接用于 matplotlib 的颜色序列或 colormap
- 提供 matplotlib 适配层，覆盖连续型、发散型、定性型三类调色板的常见使用方式
- 提供与 `plot_color_grid()`、`plot_palette()`、`plot_palettes()` 语义等价的 Python 可视化函数
- 提供与 `theme_ctc_*()` 目标等价的 matplotlib style/rcParams 配置能力
- 更新仓库文档与示例，展示从 R/ggplot 使用方式迁移到 Python/matplotlib 的方式
- **BREAKING** 对外主使用方式从 R 函数调用迁移为 Python 模块调用
- **BREAKING** `scale_*_ctc_*()` 的 ggplot 专属接口将改为 matplotlib colormap、cycler、norm 与 style 接口

## Impact
- Affected specs: 颜色目录能力、调色板目录能力、自定义调色板能力、自动配色能力、绘图集成能力、主题样式能力、文档与示例能力
- Affected code: `data/chinacolor.json`、`data/palette_list.rds` 的可迁移数据源，`R/utils.R`、`R/7.ctc_palette.R`、`R/7.*.R` 自动配色函数、`R/4.plot_palette.R`、`R/5.plot_palettes.R`、`R/8.scale_fill_color_ctc_c.R`、`R/9.scale_fill_color_ctc_d.R`、`R/10.scale_fill_color_ctc_m.R`、`R/11-15.theme_ctc_*.R`、README 与示例文档

## ADDED Requirements
### Requirement: Python 颜色与调色板目录
系统 SHALL 提供 Python API 以加载、查询和列出中国传统色数据与内置调色板，并保持与当前数据内容一致。

#### Scenario: 列出全部颜色
- **WHEN** 用户调用颜色列表接口
- **THEN** 系统返回包含颜色名称、中文名、英文名、HEX、分组信息的结构化结果

#### Scenario: 获取单个内置调色板
- **WHEN** 用户按索引、标准名称或中英文名称请求调色板
- **THEN** 系统返回颜色序列及其调色板类型元数据

### Requirement: Python 自定义调色板构建
系统 SHALL 提供与 `ctc_palette()` 等价的 Python 调色板构建接口，支持内置调色板、自定义抓色与调色板类型声明。

#### Scenario: 使用内置调色板调整颜色数
- **WHEN** 用户指定内置调色板、颜色数量和方向
- **THEN** 系统返回长度符合要求的颜色序列，并保留 `sequential`、`diverging`、`qualitative` 类型信息

#### Scenario: 使用抓色规则创建调色板
- **WHEN** 用户提供颜色分组、子组、颜色编号或顺序规则
- **THEN** 系统生成自定义调色板，并可显式声明调色板类型

### Requirement: 自动生成调色板
系统 SHALL 在 Python 中提供与现有 10 个自动配色函数等价的能力，并支持输出 matplotlib 可直接消费的颜色结果。

#### Scenario: 生成同色系调色板
- **WHEN** 用户提供基色、颜色数量及是否映射到中国传统色
- **THEN** 系统生成对应颜色序列，并可选择映射到内置颜色集合

#### Scenario: 生成结构化配色方案
- **WHEN** 用户调用类比色、三元群、互补色、分裂补色、方形、混合或发散调色板接口
- **THEN** 系统按照相同配色原理生成对应方案，并返回稳定可复用的结果

### Requirement: Matplotlib 集成
系统 SHALL 提供面向 matplotlib 的集成接口，以替代原 ggplot `scale_*_ctc_*()` 的主要使用场景。

#### Scenario: 连续或发散型着色
- **WHEN** 用户将内置或自定义连续型/发散型调色板应用到图像、热图或散点图
- **THEN** 系统可生成并返回兼容 matplotlib 的 colormap 对象

#### Scenario: 定性型分类着色
- **WHEN** 用户将定性型调色板应用到条形图、折线图或分类散点图
- **THEN** 系统可生成兼容 matplotlib 的颜色循环或离散 colormap

### Requirement: 可视化与预览
系统 SHALL 提供与现有预览函数语义等价的 Python 可视化接口，支持颜色网格、单个调色板与多个调色板预览。

#### Scenario: 预览单个调色板
- **WHEN** 用户请求绘制某个调色板
- **THEN** 系统返回 matplotlib Figure/Axes，并展示颜色块、标题与必要标签

#### Scenario: 预览多个调色板
- **WHEN** 用户请求批量绘制多个调色板
- **THEN** 系统按稳定布局输出可比较的调色板图

### Requirement: Matplotlib 主题样式
系统 SHALL 提供与现有 `theme_ctc_*()` 目标等价的 matplotlib style 接口，用于统一字体、背景、网格、配色与视觉风格。

#### Scenario: 应用主题样式
- **WHEN** 用户启用某个中国传统风格主题
- **THEN** 后续 matplotlib 图表应用对应 rcParams 或 style 配置

### Requirement: 文档与迁移示例
系统 SHALL 提供 Python 安装方式、API 示例与从 R 使用方式迁移到 matplotlib 的对照说明。

#### Scenario: 用户查阅仓库首页
- **WHEN** 用户阅读 README
- **THEN** 文档展示 Python 安装、基础 API、matplotlib 集成与典型绘图示例

## MODIFIED Requirements
### Requirement: 绘图后端集成
系统 SHALL 将原本面向 ggplot scale/theme 的集成能力迁移为面向 matplotlib colormap、颜色循环、norm 与 style 的集成能力，同时保留“内置调色板 + 自定义调色板 + 自动配色”三类输入的一致体验。

## REMOVED Requirements
### Requirement: RStudio Viewer 专属预览依赖
**Reason**: Python matplotlib 交付不依赖 RStudio Viewer，继续保留该依赖无法服务目标用户。
**Migration**: 以返回 Figure/Axes、在 notebook 中显示、或显式保存图片文件的方式替代 Viewer 预览流程。
