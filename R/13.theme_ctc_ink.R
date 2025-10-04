#' CTC Ink Theme for ggplot2
#'
#' A theme inspired by traditional Chinese ink wash painting aesthetic, using colors exclusively from
#' the 384-color Chinese traditional palette, with optimized contrast for readability.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param background_type Type of background: "light" (light rice paper), "medium" (aged paper), or "dark" (ink wash). Default: "light".
#'
#' @return A ggplot2 theme object.
#'
#' @details
#' This theme uses only colors from the 384 Chinese traditional color palette, carefully selected to
#' emulate the subtle tonal variations of traditional Chinese ink wash painting while ensuring text readability.
#'
#' @seealso
#' \code{\link{scale_color_ctc_d}},\code{\link{scale_fill_ctc_d}}
#' \code{\link{scale_color_ctc_c}}, \code{\link{scale_fill_ctc_c}}
#' \code{\link{scale_clor_ctc_m}}, \code{\link{scale_fill_ctc_m}}
#' for color or fill scales that pair well with this theme.
#' @importFrom ggplot2 theme_bw element_rect element_text element_line margin
#' @import ggplot2
#' @examples
#' \dontrun{
#' # Example with light background (default)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 3) +
#'   theme_ctc_ink() +
#'   labs(title = "鸢尾花数据分布")
#'
#' # Example with dark ink wash background
#' ggplot(mtcars, aes(x = wt, y = mpg)) +
#'   geom_point(color = "#C4A661", size = 3) +  # 金笺色
#'   theme_ctc_ink(background_type = "dark") +
#'   labs(title = "汽车性能分析")
#' }
#'
#' @export
theme_ctc_ink <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        background_type = "light"
) {
    if (is.null(base_family)) {
        base_family <- chinacolor:::setup_chinese_font()
    }

    # 定义不同背景类型对应的颜色方案 - 全部使用384色库中的颜色
    color_schemes <- list(
        light = list(
            plot_bg = "#F8F4E9",      # 凝脂 - 浅米色宣纸
            panel_bg = "#F5F2E9",     # 凝脂 - 统一色调
            title_color = "#12264F",  # 骐驎 - 深墨色
            text_color = "#45465E",   # 青黛 - 中墨色
            accent_color = "#6B798E", # 菘蓝 - 淡墨色
            grid_major = "#D3CBC5",   # 藕丝秋半
            grid_minor = "#EAE4D1",   # 玉色
            border_color = "#6B798E"  # 菘蓝 - 协调的边框
        ),
        medium = list(
            plot_bg = "#E8DFCA",      # 黄润 - 古旧宣纸
            panel_bg = "#F5F2E9",     # 凝脂 - 浅米色面板
            title_color = "#1A2847",  # 花青 - 深蓝色
            text_color = "#535164",   # 曾青 - 中蓝色
            accent_color = "#5A6B7A", # 深灰蓝
            grid_major = "#C7C6B6",   # 霜地
            grid_minor = "#D5D1AE",   # 筠雾
            border_color = "#5A6B7A"  # 深灰蓝
        ),
        dark = list(
            plot_bg = "#2C2F3B",      # 绀蝶 - 水墨背景
            panel_bg = "#45465E",     # 青黛 - 深灰蓝面板
            title_color = "#F8F4E9",  # 凝脂 - 宣纸色文字
            text_color = "#D5D1AE",   # 筠雾 - 米色文字
            accent_color = "#C4A661", # 金笺色
            grid_major = "#6B798E",   # 菘蓝 - 协调网格
            grid_minor = "#5A6B7A",   # 深灰蓝
            border_color = "#45465E"  # 青黛
        )
    )

    # 验证背景类型
    if (!background_type %in% names(color_schemes)) {
        warning("Invalid background_type. Using 'light' instead.")
        background_type <- "light"
    }

    colors <- color_schemes[[background_type]]

    # 基础主题
    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(

            plot.background = element_rect(fill = colors$plot_bg, color = NA),
            panel.background = element_rect(fill = colors$panel_bg, color = colors$border_color, linewidth = 0.5),


            plot.title = element_text(
                color = colors$title_color,
                size = base_size * 1.4,
                face = "bold",
                hjust = 0.5,
                margin = margin(b = 12),
                lineheight = 1.2
            ),
            plot.subtitle = element_text(
                color = colors$text_color,
                size = base_size * 1.1,
                hjust = 0.5,
                margin = margin(b = 10)
            ),
            plot.caption = element_text(
                color = colors$accent_color,
                size = base_size * 0.9,
                hjust = 1,
                margin = margin(t = 8)
            ),
            axis.title = element_text(
                color = colors$title_color,
                size = base_size * 1.1,
                face = "bold"
            ),
            axis.text = element_text(
                color = colors$text_color,
                size = base_size * 0.95
            ),


            panel.grid.major = if (grid_major) {
                element_line(color = colors$grid_major, linewidth = 0.3, linetype = "dashed")
            } else {
                element_blank()
            },
            panel.grid.minor = if (grid_minor) {
                element_line(color = colors$grid_minor, linewidth = 0.2, linetype = "dotted")
            } else {
                element_blank()
            },


            legend.background = element_rect(
                fill = alpha(colors$panel_bg, 0.9),
                color = colors$border_color,
                linewidth = 0.3
            ),
            legend.title = element_text(
                color = colors$title_color,
                size = base_size * 1.05,
                face = "bold"
            ),
            legend.text = element_text(
                color = colors$text_color,
                size = base_size * 0.95
            ),
            legend.key = element_rect(fill = "transparent", color = NA),


            axis.line = element_line(color = colors$accent_color, linewidth = 0.5),
            axis.ticks = element_line(color = colors$accent_color, linewidth = 0.4),

            strip.background = element_rect(
                fill = colors$accent_color,
                color = colors$border_color,
                linewidth = 0.4
            ),
            strip.text = element_text(
                color = if (background_type == "dark") colors$title_color else colors$panel_bg,
                size = base_size * 1.0,
                face = "bold"
            ),


            plot.margin = margin(20, 20, 20, 20),
            panel.spacing = unit(12, "points")
        )
}

