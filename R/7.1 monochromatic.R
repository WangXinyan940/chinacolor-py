#' @title Generate a monochromatic color palette
#' @description This function creates a continuous, monochromatic color palette
#'   based on a specified or randomly selected base color.
#'
#' @details The function generates a palette by varying the lightness of a base color
#'   while maintaining its hue and relative chroma. It leverages the HCL color
#'   space for perceptual uniformity. The palette can be directly displayed and
#'   optionally "corrected to color-true" (`ctc`) by finding the closest match
#'   in a predefined set of colors, such as those from Chinese color standards.
#'
#' @param base_color A character string specifying the base hexadecimal color code
#'   (e.g., "#ECD452"). If `NULL`, a random color is selected from the `chinacolor`
#'   dataset.
#' @param lightness_range A numeric vector of length 2 specifying the desired
#'   minimum and maximum lightness values (L in HCL, 0-100) for the palette.
#'   Defaults to `c(25, 85)`.
#' @param n An integer specifying the number of colors in the palette.
#'   Defaults to 6.
#' @param ctc_colors A logical value. If `TRUE`, the generated colors are mapped
#'   to the closest  "Chinese traditional colors" from the `chinacolor` dataset.
#' @param show_pal A logical value. If `TRUE`, the generated palette will be
#'   plotted.
#'
#' @return A character vector of hexadecimal color codes with the following attributes:
#' \itemize{
#' \item \code{type}: Character string indicating the palette type, always "sequential"
#' \item \code{n}: Number of colors in the palette
#' \item \code{ctc_colors}: Logical indicating if Chinese traditional color correction was applied
#' }
#'
#' @importFrom colorspace max_chroma
#' @importFrom grDevices hcl
#' @examples
#' \dontrun{
#' # Generate a palette based on a specific color
#' monochromatic_palette(base_color = "#ECD452",
#'              n = 6,
#'               lightness_range = c(30, 85),
#'               show_pal = TRUE)
#'
#' # Generate a palette using a random base color
#' monochromatic_palette(n = 6,
#'               lightness_range = c(30, 95),
#'               show_pal = TRUE)
#' # palette without colors in `chinacolor` dataset.
#' monochromatic_palette(n = 6,
#'               lightness_range = c(30, 95),
#'               ctc_colors = F,
#'               show_pal = TRUE)
#'}
#' @export
monochromatic_palette <- function (base_color = NULL,
                           lightness_range = c(25,85),
                           n = 6,
                           ctc_colors = FALSE,
                           show_pal = TRUE) {
   data("chinacolor")

    if (!is.numeric(lightness_range) || length(lightness_range) != 2 ||
        lightness_range[1] >= lightness_range[2] ||
        any(lightness_range < 0 | lightness_range > 100)) {
        stop("`lightness_range` must be a numeric vector of length 2, with min < max, and values between 0 and 100.")
    }

    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }

    if (!is.logical(ctc_colors) || length(ctc_colors) != 1) {
        stop("`ctc_colors` must be a single logical value (TRUE or FALSE).")
    }

    if (!is.logical(show_pal) || length(show_pal) != 1) {
        stop("`show_pal` must be a single logical value (TRUE or FALSE).")
    }

    # --- Function Logic ---

    if(is.null(base_color)) {
        base_color <- chinacolor$hex[sample(1:384, size = 1)]
    } else{
        color_check <- validate_colors(base_color)
        if (nrow(color_check$invalid) > 0) {
            warning("Invalid color values found,random color from chinacolor data set will be used")
            base_color <- chinacolor$hex[sample(1:384, size = 1)]
        }
    }

    base_hcl <- .get_hcl_values(base_color)
    base_hue <- base_hcl[,"H"]
    base_chroma <- base_hcl[,"C"]
    base_lightness <- base_hcl[,"L"]

    c_max <- max_chroma(base_hue, base_lightness)
    ratio <- base_chroma / max_chroma(base_hue, base_lightness)


    l_val <- get_l_val(n = n,
                       base_lightness = base_lightness,
                       lightness_range = lightness_range)

    c_val <- max_chroma(h = base_hue,
                        l = l_val) * ratio

    colors_result <- hcl(h = base_hue,
                         c = c_val,
                         l = l_val,
                         fixup = TRUE)


    if (!ctc_colors) {
        palette_colors <- colors_result
    } else {
        palette_ctc_colors <- find_closest_colors(target_colors = colors_result,
                                                 ref_colors = chinacolor$hex)
        palette_colors <- palette_ctc_colors$closest_ref
    }



    if (show_pal) {
        plot_palette(
                     x = ordered_color_set(palette_colors,direction = 2),
                     type = "custom",
                     show_text = TRUE)
    }



    attr(palette_colors, "type") <- "sequential"
    attr(palette_colors, "n") <- n
    attr(palette_colors, "ctc_colors") <- ctc_colors



    return(palette_colors)
}


