#' CTC Paper Theme for ggplot2
#'
#' A theme inspired by traditional Chinese rice paper, with optimized contrast and color harmony,
#' featuring three distinct paper styles: "light" for modern readability, "aged" for vintage aesthetics,
#' and "classic" for authentic traditional colors.
#'
#' @param base_size Base font size (default: 12pt).
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param paper_type Character: "light" (light rice paper), "aged" (aged paper effect), or "classic" (authentic traditional, default: "light").
#'
#' @return A ggplot2 theme object that can be added to ggplot objects.
#'
#' @details
#' This theme emulates the aesthetic of traditional Chinese rice paper, with carefully optimized
#' color contrast to ensure readability while maintaining the subtle, elegant paper texture.
#' Three distinct styles are available:
#'
#' **Light Style (paper_type = "light")**:
#' - Optimized contrast ratios for modern readability
#' - Background: Light rice paper tones with high contrast text
#' - Features: White panels and clear grid lines for data clarity
#'
#' **Aged Style (paper_type = "aged")**:
#' - Vintage aesthetics with aged paper effects
#' - Background: Warm, yellowish tones simulating historical documents
#' - Features: Subtle grid lines and traditional color harmony
#'
#' **Classic Style (paper_type = "classic")**:
#' - Authentic traditional colors from the 384-color list
#' - Background: Classic "Ning Zhi" (#F5F2E9) and "Yu Se" (#EAE4D1) paper tones
#' - Features: Warm browns and sepia tones with cultural authenticity
#'
#' Recommended color combinations (carefully selected from 384 colors):
#' - **Discrete categories**: Qing Li (#422517), Shan Hu He (#C12C1F), Bi Shan (#779649), Qie Lan (#88ABDA)
#' - **Continuous gradients**:
#'   - Warm-toned gradient: Huang Bai You (#FFF799) → Xiang Ye (#ECD452) → Cang Huang (#B6A014) → Li Ke (#775039)
#'   - Cool-toned gradient: Tian Piao (#D5EBE1) → Cang Lang (#B1D5C8) → Piao Bi (#80A492) → Qing Li (#422517)
#'
#' The color names in comments (e.g., 凝脂, 玉色) are traditional Chinese color terms, preserving cultural connotations.
#'
#' @seealso
#' \code{\link{scale_color_ctc_d}},\code{\link{scale_fill_ctc_d}}
#' \code{\link{scale_color_ctc_c}}, \code{\link{scale_fill_ctc_c}}
#' \code{\link{scale_clor_ctc_m}}, \code{\link{scale_fill_ctc_m}}
#' for color or fill scales that pair well with this theme.
#'
#' @importFrom ggplot2 theme_bw element_rect element_text element_line margin
#' @import ggplot2
#'
#' @examples
#' \dontrun{
#' # Example with light style (optimized contrast)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'     geom_point(size = 3) +
#'     scale_color_ctc_d(palette_name = 52, name = "品种图例") +
#'     theme_ctc_paper(paper_type = "light") +
#'     labs(title = "鸢尾花数据可视化", subtitle = "基于萼片尺寸的分类")
#'
#' # Example with aged style (vintage aesthetics)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'     geom_point(size = 3) +
#'     scale_color_ctc_d(palette_name = 52, name = "品种图例") +
#'     theme_ctc_paper(paper_type = "aged") +
#'     labs(title = "鸢尾花数据可视化", subtitle = "基于萼片尺寸的分类")
#'
#' # Example with classic style (authentic traditional)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'     geom_point(size = 3) +
#'     scale_color_ctc_d(palette_name = 52, name = "品种图例") +
#'     theme_ctc_paper(paper_type = "classic") +
#'     labs(title = "鸢尾花数据可视化", subtitle = "基于萼片尺寸的分类")
#' }
#'
#' @note For optimal Chinese display, it is recommended to use the \code{showtext} package to manage fonts.
#' @export
theme_ctc_paper <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        paper_type = "light"
) {
    if (is.null(base_family)) {
        base_family <- setup_chinese_font()
    }


    if (!paper_type %in% c("light", "aged", "classic")) {
        warning("Invalid paper_type. Using 'light' instead.")
        paper_type <- "light"
    }


    if (paper_type == "light") {

        colors <- list(
            plot_bg = "#F5F2E9",
            panel_bg = "#FFFFFF",
            border_color = "#775039",
            title_color = "#422517",
            subtitle_color = "#5F4321",
            caption_color = "#775039",
            axis_title_color = "#422517",
            axis_text_color = "#5F4321",
            grid_major_color = "#D5D1AE",
            grid_minor_color = "#EAE4D1",
            strip_bg_color = "#5F4321",
            strip_text_color = "#F5F2E9",
            legend_bg_color = "#F5F2E9",
            legend_key_color = "#FFFFFF"
        )
    } else if (paper_type == "aged") {

        colors <- list(
            plot_bg = "#E8DFCA",      # 黄润 - 古旧宣纸
            panel_bg = "#F5F2E9",     # 凝脂 - 浅色面板
            border_color = "#5F4321", # 龙战 - 深色边框
            title_color = "#422517",  # 青骊
            subtitle_color = "#5F4321", # 龙战
            caption_color = "#775039", # 栗壳
            axis_title_color = "#422517", # 青骊
            axis_text_color = "#5F4321",  # 龙战
            grid_major_color = "#C7C6B6", # 霜地 - 古旧网格
            grid_minor_color = "#D5D1AE", # 筠雾 - 浅色网格
            strip_bg_color = "#422517",   # 青骊 - 深色分面
            strip_text_color = "#F5F2E9", # 凝脂 - 浅色文字
            legend_bg_color = "#E8DFCA",  # 黄润 - 图例背景
            legend_key_color = "#F5F2E9"  # 凝脂 - 图例键
        )
    } else {

        colors <- list(
            plot_bg = "#F5F2E9",      # 凝脂 - 传统宣纸背景
            panel_bg = "#EAE4D1",     # 玉色 - 宣纸面板底色
            border_color = "#C7C6B6", # 霜地 - 浅色边框
            title_color = "#422517",  # 青骊 - 深褐色标题
            subtitle_color = "#A46244", # 老僧衣 - 赭石色副标题
            caption_color = "#C7C6B6", # 霜地 - 浅色图注
            axis_title_color = "#422517", # 青骊 - 深褐色坐标标题
            axis_text_color = "#775039",  # 栗壳 - 褐色坐标文字
            grid_major_color = "#E0E0D0", # 韶粉 - 协调的网格色
            grid_minor_color = "#EBEDDF", # 吉量 - 浅色辅助网格
            strip_bg_color = "#E0E0D0",   # 韶粉 - 分面背景
            strip_text_color = "#422517",  # 青骊 - 深色分面文字
            legend_bg_color = "#F5F2E9",  # 凝脂 - 图例背景
            legend_key_color = "#EAE4D1"  # 玉色 - 图例键
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
