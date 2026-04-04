# Tasks
- [x] Task 1: 建立 Python 包骨架与基础数据访问能力
  - [x] SubTask 1.1: 选定 Python 打包方式并建立包目录、公开入口与测试目录
  - [x] SubTask 1.2: 迁移或转换 384 色数据与 60 组调色板元数据为 Python 可读取格式
  - [x] SubTask 1.3: 实现颜色列表、颜色查询、调色板列表、调色板查询的基础 API
  - [x] SubTask 1.4: 为基础数据接口补充单元测试，校验数量、字段与查询路径

- [x] Task 2: 迁移调色板构建与底层工具能力
  - [x] SubTask 2.1: 迁移颜色校验、最近色映射、插值、方向反转、类型归一化等底层工具
  - [x] SubTask 2.2: 实现 Python 版 `ctc_palette()` 等价接口，支持内置与自定义两种来源
  - [x] SubTask 2.3: 实现抓色规则构造辅助接口，覆盖 group、subgroup、id、order_rule 等输入
  - [x] SubTask 2.4: 为调色板构建补充测试，覆盖 sequential、diverging、qualitative 三类输出

- [x] Task 3: 迁移 10 个自动配色算法
  - [x] SubTask 3.1: 迁移 monochromatic、analogous、harmonic、triadic、complementary 算法
  - [x] SubTask 3.2: 迁移 split complementary、compound antipodal、compound concyclic、diverging、intermediate 算法
  - [x] SubTask 3.3: 统一这些算法的输入输出签名，使其可直接返回颜色列表或后续 colormap 输入
  - [x] SubTask 3.4: 为每类算法补充可重复的结果校验测试

- [x] Task 4: 提供 matplotlib 集成层
  - [x] SubTask 4.1: 为连续型与发散型调色板提供 colormap 构造接口
  - [x] SubTask 4.2: 为定性型调色板提供颜色循环、离散映射或 ListedColormap 接口
  - [x] SubTask 4.3: 提供将内置、自定义、自动生成调色板统一接入 matplotlib 的便捷函数
  - [x] SubTask 4.4: 通过示例或测试验证热图、散点图、分类图三类常见场景

- [x] Task 5: 迁移预览与主题能力
  - [x] SubTask 5.1: 实现颜色网格、单个调色板、多个调色板的 matplotlib 可视化函数
  - [x] SubTask 5.2: 实现与 `theme_ctc_*()` 等价目标的 matplotlib style/rcParams 能力
  - [x] SubTask 5.3: 验证可视化函数返回 Figure/Axes 且主题配置可被应用

- [x] Task 6: 更新文档、迁移说明与验收
  - [x] SubTask 6.1: 更新 README，改为 Python/matplotlib 安装与使用说明
  - [x] SubTask 6.2: 增加从 R/ggplot API 到 Python/matplotlib API 的迁移示例
  - [x] SubTask 6.3: 运行测试与必要的示例验证，补齐验收缺口

# Task Dependencies
- Task 2 depends on Task 1
- Task 3 depends on Task 2
- Task 4 depends on Task 2
- Task 5 depends on Task 1 and Task 4
- Task 6 depends on Task 1, Task 2, Task 3, Task 4, and Task 5
