#' CTC Bronze Theme for ggplot2
#'
#' A theme inspired by ancient Chinese bronze ware, featuring carefully selected colors from the
#' 384-color traditional palette with optimized contrast and accessibility.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param oxidation_level Character: "fresh" (minimal oxidation), "light" (mild oxidation),
#'   "medium" (moderate oxidation), or "heavy" (heavy oxidation, default: "heavy").
#'
#' @return A ggplot2 theme object.
#'
#' @details
#' This theme emulates the aesthetic of ancient Chinese bronze ware, using exclusively colors from
#' the 384-color traditional palette. Four oxidation levels are provided:
#'
#' - **Fresh oxidation**: Minimal oxidation with soft contrast
#' - **Light oxidation**: Mild oxidation with balanced colors
#' - **Medium oxidation**: Moderate oxidation with good readability
#' - **Heavy oxidation**: Heavy patina with authentic aged appearance
#'

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
#' # Example 1: Heavy oxidation mode (authentic aged appearance)
#' ggplot(iris, aes(x = Sepal.Length, y = Petal.Length, color = Species)) +
#'    geom_point(size = 3) +
#'    scale_color_ctc_d(palette_name = 52, direction = 1) +
#'    theme_ctc_bronze(oxidation_level = "heavy") +
#'    labs(title = "青铜器风格: 重度氧化效果", color = "种类")
#'
#' # Example 2: Fresh oxidation mode (minimal oxidation)
#' ggplot(mtcars, aes(x = wt, y = mpg, fill = factor(cyl))) +
#'    geom_point(pch = 21, size = 3) +
#'    scale_fill_ctc_d(palette_name = 45) +
#'    theme_ctc_bronze(oxidation_level = "fresh") +
#'    labs(title = "青铜器风格: 新鲜青铜效果", fill = "气缸数")
#' }
#' @export
theme_ctc_bronze <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        oxidation_level = "heavy"
) {
    if (is.null(base_family)) {
        base_family <- setup_chinese_font()
    }


    valid_levels <- c("fresh", "light", "medium", "heavy")
    if (!oxidation_level %in% valid_levels) {
        warning("Invalid oxidation_level. Using 'heavy' instead. Valid options: 'fresh', 'light', 'medium', 'heavy'")
        oxidation_level <- "heavy"
    }


    color_schemes <- list(
        fresh = list(

            plot_bg = "#DFD6B8",      # 黄润 - 浅米色背景
            panel_bg = "#C4B798",     # 自定义青铜色面板
            title_color = "#422517",  # 青骊 - 深褐色标题
            text_color = "#422517",   # 青骊 - 深褐色文字
            accent_color = "#422517", # 青骊 - 强调色
            grid_color = "#756C4B",   # 自定义青铜网格
            border_color = "#3D8E86"  # 铜青 - 青铜边框
        ),
        light = list(

            plot_bg = "#F5F2E9",      # 凝脂 - 浅米色背景，高对比度
            panel_bg = "#E8DFCA",     # 黄润 - 古铜色面板
            title_color = "#5B3222",  # 目童子 - 青铜深色标题
            text_color = "#81663B",   # 远志 - 青铜褐色文字
            accent_color = "#81663B", # 远志 - 青铜强调色
            grid_color = "#C4B39B",   # 古铜色 - 青铜网格线
            border_color = "#8B7042"  # 流黄 - 深褐色边框
        ),
        medium = list(

            plot_bg = "#E8DFCA",      # 黄润 - 古铜色背景
            panel_bg = "#D5C8A0",     # 缣缃 - 氧化青铜面板
            title_color = "#4C1E1A",  # 麒麟竭 - 氧化深色标题
            text_color = "#72453A",   # 椒褐 - 氧化褐色文字
            accent_color = "#8B7042", # 流黄 - 青铜绿强调色
            grid_color = "#A99275",   # 古铜色 - 氧化青铜网格线
            border_color = "#7C623F"  # 射干 - 深褐色边框
        ),
        heavy = list(

            plot_bg = "#E6D9BE",      # 浅褐黄 - 优化过渡的背景
            panel_bg = "#D4BE98",     # 青铜基色 - 青铜基底
            title_color = "#301A12",  # 极深褐 - 深褐色标题
            text_color = "#301A12",   # 极深褐 - 深褐色文字
            accent_color = "#301A12", # 极深褐 - 强调色
            grid_color = "#4A9E96",   # 深青 - 青铜蓝网格
            border_color = "#3D8E86"  # 铜青 - 青铜边框
        )
    )

    colors <- color_schemes[[oxidation_level]]

    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(

            plot.background = element_rect(fill = colors$plot_bg, color = NA),
            panel.background = element_rect(fill = colors$panel_bg, color = colors$border_color, linewidth = 0.4),


            plot.title = element_text(
                color = colors$title_color,
                size = base_size * 1.3,
                face = "bold",
                hjust = 0.5,
                margin = margin(b = 10)
            ),
            plot.subtitle = element_text(
                color = colors$text_color,
                size = base_size * 0.95,
                hjust = 0.5,
                margin = margin(b = 15)
            ),
            plot.caption = element_text(
                color = colors$text_color,
                size = base_size * 0.75,
                hjust = 1,
                margin = margin(t = 10)
            ),
            axis.title = element_text(
                color = colors$title_color,
                size = base_size * 0.95,
                face = "bold"
            ),
            axis.text = element_text(
                color = colors$text_color,
                size = base_size * 0.85
            ),


            legend.background = element_rect(fill = colors$plot_bg, color = colors$border_color, linewidth = 0.2),
            legend.title = element_text(
                color = colors$title_color,
                size = base_size * 0.9,
                face = "bold"
            ),
            legend.text = element_text(
                color = colors$text_color,
                size = base_size * 0.85
            ),
            legend.key = element_rect(fill = "transparent", color = NA),


            panel.grid.major = if (grid_major) {
                element_line(color = colors$grid_color, linetype = "dashed", linewidth = 0.25)
            } else {
                element_blank()
            },
            panel.grid.minor = if (grid_minor) {
                element_line(color = adjustcolor(colors$grid_color, alpha.f = 0.6),
                             linetype = "dotted", linewidth = 0.15)
            } else {
                element_blank()
            },


            strip.background = element_rect(
                fill = colors$border_color,
                color = colors$text_color,
                linewidth = 0.3
            ),
            strip.text = element_text(
                color = colors$plot_bg,
                size = base_size * 0.9,
                face = "bold"
            ),
            axis.line = element_line(color = colors$text_color, linewidth = 0.35),


            plot.margin = margin(12, 12, 10, 12)
        )
}
