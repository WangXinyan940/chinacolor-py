#' CTC Mineral Theme for ggplot2
#'
#' A theme implemented using 384 colors, emphasizing the rich saturation and vividness of traditional mineral pigments,
#' with three distinct background options: "light" for optimized contrast, "dark" for dramatic mineral aesthetics,
#' and "classic" for authentic traditional colors.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param background_type Character: "light" (optimized contrast), "dark" (dramatic mineral), or "classic" (authentic traditional, default: "light").
#'
#' @return A ggplot2 theme object.
#'
#' @details
#' This theme draws inspiration from traditional mineral pigments—naturally occurring inorganic substances
#' prized in historical Chinese art for their intense, lightfast colors. Three distinct styles are available:
#'
#' **Light Style (background_type = "light")**:
#' - Optimized contrast ratios for better readability
#' - Background: Subtle earthy greens that make mineral pigments stand out
#' - Text colors: High-contrast combinations meeting accessibility standards
#'
#' **Dark Style (background_type = "dark")**:
#' - Dramatic mineral aesthetics with deep gemstone backgrounds
#' - Background: Rich jewel tones like "Qiong Lin" (#343041) for striking visual impact
#' - Text colors: Light colors that pop against dark backgrounds
#'
#' **Classic Style (background_type = "classic")**:
#' - Authentic mineral pigment aesthetics from the 384-color list
#' - Background: Traditional "Jia Tan" (#CAD7C5) and "Bing Tai" (#BECAB7) creating a neutral canvas
#' - Text colors: Warm browns and sepia tones providing clear contrast
#'
#' Key design features:
#' - **Background layers**: Carefully selected backgrounds that make mineral pigments stand out
#' - **Recommended color schemes** (all from the 384-color list):
#'   - Discrete data: High-saturation mineral color combinations such as "Qun Qing" (#2E59A7, lapis lazuli blue) + "Shan Hu He" (#C12C1F, cinnabar red) + "Bi Shan" (#779649, malachite green)
#'   - Continuous data: Monochromatic gradients within mineral families
#' - **Accessibility focus**: Color combinations meet basic readability standards while preserving cultural authenticity
#'
#' @seealso
#' \code{\link{scale_color_ctc_d}},\code{\link{scale_fill_ctc_d}}
#' \code{\link{scale_color_ctc_c}}, \code{\link{scale_fill_ctc_c}}
#' \code{\link{scale_clor_ctc_m}}, \code{\link{scale_fill_ctc_m}}
#' for color or fill scales that pair well with this theme.
#'
#' @importFrom ggplot2 theme_bw element_rect element_text element_line margin
#' @import ggplot2
#' @examples
#' \dontrun{
#' # Example with light style (optimized contrast)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_ctc_d(palette_name = 25) +
#'   theme_ctc_mineral(background_type = "light") +
#'   labs(title = "矿物色彩主题数据可视化")
#'
#' # Example with dark style (dramatic mineral aesthetics)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_ctc_d(palette_name = 25) +
#'   theme_ctc_mineral(background_type = "dark") +
#'   labs(title = "矿物色彩主题数据可视化")
#'
#' # Example with classic style (authentic traditional colors)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   scale_color_ctc_d(palette_name = 25) +
#'   theme_ctc_mineral(background_type = "classic") +
#'   labs(title = "矿物色彩主题数据可视化")
#' }
#'
#' @export
theme_ctc_mineral <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        background_type = "light"
) {
    if (is.null(base_family)) {
        base_family <- setup_chinese_font()
    }

    # 验证参数
    if (!background_type %in% c("light", "dark", "classic")) {
        warning("Invalid background_type. Using 'light' instead.")
        background_type <- "light"
    }


    if (background_type == "light") {

        colors <- list(
            plot_bg = "#BEC2B3",      # 冻缥 - 矿石基质背景
            panel_bg = "#D4D3CA",     # 明月珰 - 矿物底色面板
            border_color = "#2E59A7", # 群青 - 青金石边框
            title_color = "#1A2847",  # 花青 - 深蓝色标题
            subtitle_color = "#535164", # 曾青 - 中蓝色副标题
            caption_color = "#535164", # 曾青 - 中蓝色图注
            axis_title_color = "#1A2847", # 花青 - 深蓝色坐标标题
            axis_text_color = "#535164",  # 曾青 - 中蓝色坐标文字
            grid_major_color = "#9D9D82", # 春碧 - 协调的网格色
            grid_minor_color = "#BEC2B3", # 冻缥 - 浅色辅助网格
            strip_bg_color = "#5F4321",   # 龙战 - 深色分面背景
            strip_text_color = "#F8F4E9", # 凝脂 - 浅色分面文字
            legend_bg_color = "#D4D3CA",  # 明月珰 - 图例背景
            legend_key_color = "#F5F2E9"  # 凝脂 - 浅色图例键
        )
    } else if (background_type == "dark") {

        colors <- list(
            plot_bg = "#343041",      # 璆琳 - 深宝石背景
            panel_bg = "#535164",     # 曾青 - 深矿物面板
            border_color = "#C7C6B6", # 霜地 - 浅色边框
            title_color = "#F8F4E9",  # 凝脂 - 浅色标题
            subtitle_color = "#E8DFCA", # 黄润 - 米色副标题
            caption_color = "#D5D1AE", # 筠雾 - 浅色图注
            axis_title_color = "#F8F4E9", # 凝脂
            axis_text_color = "#E8DFCA",  # 黄润
            grid_major_color = "#6B7D73", # 千山翠 - 协调的网格色
            grid_minor_color = "#555F4D", # 结绿 - 深色辅助网格
            strip_bg_color = "#C7C6B6",   # 霜地 - 浅色分面背景
            strip_text_color = "#1A2847",  # 花青 - 深色分面文字
            legend_bg_color = "#535164",   # 曾青 - 深色图例背景
            legend_key_color = "#6B7D73"   # 千山翠 - 中色图例键
        )
    } else {

        colors <- list(
            plot_bg = "#CAD7C5",      # 葭菼 - 传统矿物背景
            panel_bg = "#BECAB7",     # 冰台 - 矿物面板底色
            border_color = "#C7C6B6", # 霜地 - 浅色边框
            title_color = "#422517",  # 青骊 - 深褐色标题
            subtitle_color = "#A46244", # 老僧衣 - 赭石色副标题
            caption_color = "#C7C6B6", # 霜地 - 浅色图注
            axis_title_color = "#422517", # 青骊 - 深褐色坐标标题
            axis_text_color = "#775039",  # 栗壳 - 褐色坐标文字
            grid_major_color = "#B3BDA9", # 青古 - 协调的网格色
            grid_minor_color = "#C0AD5E", # 栾华 - 浅色辅助网格
            strip_bg_color = "#B3BDA9",   # 青古 - 分面背景
            strip_text_color = "#422517",  # 青骊 - 深色分面文字
            legend_bg_color = "#CAD7C5",  # 葭菼 - 图例背景
            legend_key_color = "#BECAB7"  # 冰台 - 图例键
        )
    }

    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(

            plot.background = element_rect(fill = colors$plot_bg, color = NA),
            panel.background = element_rect(
                fill = colors$panel_bg,
                color = colors$border_color,
                linewidth = 0.4
            ),


            plot.title = element_text(
                color = colors$title_color,
                size = base_size * 1.3,
                face = "bold",
                hjust = 0.5,
                margin = margin(b = 12),
                lineheight = 1.2
            ),
            plot.subtitle = element_text(
                color = colors$subtitle_color,
                size = base_size * 1.1,
                hjust = 0.5,
                margin = margin(b = 10)
            ),
            plot.caption = element_text(
                color = colors$caption_color,
                size = base_size * 0.9,
                hjust = 1,
                margin = margin(t = 8)
            ),
            axis.title = element_text(
                color = colors$axis_title_color,
                size = base_size * 1.1,
                face = "bold"
            ),
            axis.text = element_text(
                color = colors$axis_text_color,
                size = base_size * 0.95
            ),


            panel.grid.major = if (grid_major) element_line(
                color = colors$grid_major_color,
                linetype = "dashed",
                linewidth = 0.3
            ) else element_blank(),
            panel.grid.minor = if (grid_minor) element_line(
                color = colors$grid_minor_color,
                linetype = "dotted",
                linewidth = 0.2
            ) else element_blank(),

            legend.background = element_rect(
                fill = colors$legend_bg_color,
                color = colors$border_color,
                linewidth = 0.3
            ),
            legend.title = element_text(
                color = colors$title_color,
                size = base_size * 1.05,
                face = "bold"
            ),
            legend.text = element_text(
                color = colors$axis_text_color,
                size = base_size * 0.95
            ),
            legend.key = element_rect(
                fill = colors$legend_key_color,
                color = NA
            ),


            strip.background = element_rect(
                fill = colors$strip_bg_color,
                color = colors$border_color,
                linewidth = 0.4
            ),
            strip.text = element_text(
                color = colors$strip_text_color,
                size = base_size * 1.0,
                face = "bold",
                margin = margin(4, 4, 4, 4)
            ),


            axis.line = element_line(
                color = colors$border_color,
                linewidth = 0.4
            ),
            axis.ticks = element_line(
                color = colors$border_color,
                linewidth = 0.3
            ),


            plot.margin = margin(15, 15, 15, 15),
            panel.spacing = unit(10, "points")
        )
}
