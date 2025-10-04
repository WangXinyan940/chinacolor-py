
#' CTC Dunhuang Theme for ggplot2
#'
#' A theme strictly inspired by Dunhuang murals (4th-14th century), featuring traditional mineral pigments
#' used in Buddhist art, with two distinct style options: "classic" for authentic mural aesthetics and
#' "modern" for optimized contrast and readability while maintaining cultural authenticity.
#'
#' @param base_size Base font size (default: 12pt). Recommended for murals: 14pt for better readability.
#' @param base_family Font family.(default value is NotoSansSC,for broader compatibility. You can specify your preferred font.)
#' @param grid_major Logical: whether to show major grid lines (default: TRUE, mimicking the grid of mural layouts).
#' @param grid_minor Logical: whether to show minor grid lines (default: FALSE).
#' @param border_style Character: "simple" (thin border) or "ornate" (thick border, imitating mural frames, default: "ornate").
#' @param text_angle_control Logical: whether to allow automatic text angle adjustment for long labels (default: TRUE).
#' @param bg_type Character: "classic" for authentic Dunhuang mural colors or "modern" for optimized contrast (default: "modern").
#'
#' @return A ggplot2 theme object with Dunhuang mural aesthetics.
#'
#' @details
#' Two distinct color schemes inspired by Dunhuang murals:
#'
#' **Classic Style (bg_type = "classic")**:
#' - Authentic mineral pigments from the 384-color list
#' - Background: Huangrun (#DFD6B8) and Jianxiang (#D5C8A0) simulating mural ground layers
#' - Text colors: Cinnabar red (#C12C1F) and indigo blue (#1A2847) imitating mural inscriptions
#' - Grid lines: Malachite green series (#206864, #3D8E86) for faint mural divisions
#'
#' **Modern Style (bg_type = "modern")**:
#' - Optimized contrast ratios for better readability
#' - Background: Earth-yellow tones with improved text contrast
#' - Text colors: High-contrast combinations meeting accessibility standards
#' - Accent colors: Traditional mineral pigments with balanced saturation
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
#' # Example with modern style (optimized contrast)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 4, alpha = 0.9) +
#'   scale_color_ctc_d(palette_name = 25) +
#'   theme_ctc_dunhuang(bg_type = "modern", border_style = "ornate") +
#'   labs(title = "敦煌风格数据可视化", subtitle = "现代优化对比度效果")
#'
#' # Example with classic style (authentic mural colors)
#' ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
#'   geom_point(size = 4, alpha = 0.9) +
#'   scale_color_ctc_d(palette_name = 25) +
#'   theme_ctc_dunhuang(bg_type = "classic", border_style = "ornate") +
#'   labs(title = "敦煌风格数据可视化", subtitle = "经典壁画色彩效果")
#' }
#' @export
theme_ctc_dunhuang <- function(
        base_size = 12,
        base_family = NULL,
        grid_major = TRUE,
        grid_minor = FALSE,
        border_style = "ornate",
        text_angle_control = TRUE,
        bg_type = "modern"
) {

    if (is.null(base_family)) {
        base_family <- setup_chinese_font()
    }

    # 验证参数
    if (!border_style %in% c("simple", "ornate")) {
        warning("Invalid border_style. Using 'ornate' instead.")
        border_style <- "ornate"
    }

    if (!bg_type %in% c("classic", "modern")) {
        warning("Invalid bg_type. Using 'modern' instead.")
        bg_type <- "modern"
    }


    border_width <- ifelse(border_style == "ornate", 0.6, 0.3)


    if (bg_type == "classic") {

        colors <- list(

            plot_bg = "#DFD6B8",      # 黄润 - 壁画地仗层土黄色
            panel_bg = "#D5C8A0",     # 茧香 - 壁画基底褐色


            border_color = "#206864", # 石绿 - 壁画边框


            title_color = "#C12C1F",  # 珊瑚赫 - 朱砂标题
            subtitle_color = "#1A2847", # 花青 - 青蓝色副标题
            caption_color = "#775039", # 酽墨 - 深褐色图注
            axis_title_color = "#1A2847", # 花青 - 深蓝色坐标标题
            axis_text_color = "#206864",  # 石绿 - 石绿坐标文字


            grid_major_color = "#3D8E86", # 铜青 - 石绿网格
            grid_minor_color = "#5DA39D", # 二绿 - 浅色辅助网格
            strip_bg_color = "#C12C1F",   # 珊瑚赫 - 朱砂分面背景
            strip_text_color = "#DFD6B8", # 黄润 - 浅色分面文字
            legend_key_color = "#D5C8A0"  # 茧香 - 协调的图例键
        )
    } else {

        colors <- list(

            plot_bg = "#E6C8A5",      # 壁画地仗层土黄色
            panel_bg = "#D4B78B",     # 壁画基底褐色


            border_color = "#9D2A22", # 綪茷 - 深朱砂壁画边框


            title_color = "#B93A26",  # 朱殷 - 深朱砂标题
            subtitle_color = "#2E59A7", # 群青 - 青蓝色副标题
            caption_color = "#5F4321", # 龙战 - 深褐色图注
            axis_title_color = "#1A2847", # 花青 - 深蓝色坐标标题
            axis_text_color = "#5F4321",  # 龙战 - 深褐色坐标文字


            grid_major_color = "#68945C", # 庭芜绿 - 石绿网格
            grid_minor_color = "#88BFB8", # 繱犗 - 浅色辅助网格
            strip_bg_color = "#206864",   # 石绿 - 石绿分面背景
            strip_text_color = "#F8F4E9", # 凝脂 - 浅色分面文字
            legend_key_color = "#E8DFCA"  # 黄润 - 协调的图例键
        )
    }

    theme_bw(base_size = base_size, base_family = base_family) %+replace%
        theme(

            plot.background = element_rect(fill = colors$plot_bg, color = NA),
            panel.background = element_rect(
                fill = colors$panel_bg,
                color = colors$border_color,
                linewidth = border_width
            ),


            plot.title = element_text(
                color = colors$title_color,
                size = base_size * 1.4,
                face = "bold",
                hjust = 0.5,
                margin = margin(b = 12),
                lineheight = 1.2
            ),
            plot.subtitle = element_text(
                color = colors$subtitle_color,
                size = base_size * 1.05,
                hjust = 0.5,
                margin = margin(b = 10)
            ),
            plot.caption = element_text(
                color = colors$caption_color,
                size = base_size * 0.8,
                hjust = 1,
                margin = margin(t = 8)
            ),
            axis.title = element_text(
                color = colors$axis_title_color,
                size = base_size * 1.0,
                face = "bold",
                margin = margin(r = 5, t = 5)
            ),
            axis.text = element_text(
                color = colors$axis_text_color,
                size = base_size * 0.9,
                margin = margin(5, 5, 5, 5)
            ),


            axis.text.x = if (text_angle_control) {
                element_text(angle = 0, hjust = 0.5)
            } else {
                element_text(angle = 45, hjust = 1, vjust = 1)
            },


            panel.grid.major = if (grid_major) element_line(
                color = colors$grid_major_color,
                linetype = "dashed",
                linewidth = 0.25
            ) else element_blank(),
            panel.grid.minor = if (grid_minor) element_line(
                color = colors$grid_minor_color,
                linetype = "dotted",
                linewidth = 0.15
            ) else element_blank(),


            legend.background = element_rect(
                fill = if (bg_type == "classic") colors$plot_bg else alpha(colors$plot_bg, 0.9),
                color = colors$border_color,
                linewidth = 0.3
            ),
            legend.title = element_text(
                color = colors$title_color,
                size = base_size * 0.95,
                face = "bold"
            ),
            legend.text = element_text(
                color = colors$axis_text_color,
                size = base_size * 0.85
            ),
            legend.key = element_rect(
                fill = colors$legend_key_color,
                color = NA
            ),


            strip.background = element_rect(
                fill = colors$strip_bg_color,
                color = colors$border_color,
                linewidth = border_width
            ),
            strip.text = element_text(
                color = colors$strip_text_color,
                size = base_size * 0.95,
                face = "bold",
                margin = margin(4, 4, 4, 4)
            ),


            axis.line = element_line(
                color = colors$border_color,
                linewidth = 0.35
            ),
            axis.ticks = element_line(
                color = colors$border_color,
                linewidth = 0.3
            ),


            plot.margin = margin(15, 15, 12, 15),
            panel.spacing = unit(8, "points")
        )
}

