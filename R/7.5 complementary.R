#' @title Generate a Complementary Color Palette
#' @description This function creates a color palette based on complementary colors
#'   (180 degrees apart on the hue wheel) derived from a base color. Starting from
#'   a specified or randomly selected base color, it generates a pair of complementary
#'   hues, then expands the palette by adding monochromatic variants of these two main
#'   colors to achieve the desired total number of colors (`n`). Optionally, the resulting
#'   colors can be mapped to the closest traditional Chinese colors from the \code{chinacolor} dataset.
#'
#' @param base_color A character string specifying the base hexadecimal color code
#'   (e.g., "#ECD452"). If \code{NULL}, a random color is selected from the \code{chinacolor} dataset.
#' @param n An integer specifying the total number of colors in the palette.
#'   Must be between 2 and 8. Defaults to 6.
#' @param ctc_colors A logical value. If \code{TRUE}, the generated colors are mapped
#'   to the closest "Chinese traditional colors" from the \code{chinacolor} dataset.
#' @param show_pal A logical value. If \code{TRUE}, the generated palette will be plotted
#'   using \code{\link[chinacolor]{plot_palette}}.
#'
#' @return A character vector of hexadecimal color codes with the following attributes:
#' \itemize{
#' \item \code{type}: Character string indicating the palette type, always "qualitative"
#' \item \code{n}: Number of colors in the palette
#' \item \code{ctc_colors}: Logical indicating if Chinese traditional color correction was applied
#' }
#'
#' @importFrom colorspace max_chroma
#' @importFrom grDevices hcl
#'
#' @examples
#' \dontrun{
#' # Generate a 5-color complementary-based palette from a specific base color
#' complementary_palette(base_color = "#779649", n = 5, ctc_colors = TRUE, show_pal = TRUE)
#'
#' # Generate a 6-color palette using a random base color
#' complementary_palette(n = 6, ctc_colors = TRUE, show_pal = TRUE)
#'}
#' @export
complementary_palette <- function(base_color = NULL,
                            n = 6,
                            ctc_colors = TRUE,
                            show_pal = TRUE) {

    data("chinacolor")

    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }

    if (n < 2 || n > 8) {
        stop("The number of colors must be between 2 and 8 for this function.")
    }

    if (!is.logical(ctc_colors) || length(ctc_colors) != 1) {
        stop("`ctc_colors` must be a single logical value (TRUE or FALSE).")
    }

    if (!is.logical(show_pal) || length(show_pal) != 1) {
        stop("`show_pal` must be a single logical value (TRUE or FALSE).")
    }

    if(is.null(base_color)) {
        base_color <- chinacolor$hex[sample(1:384, size = 1)]
    } else{
        color_check <- validate_colors(base_color)
        if (nrow(color_check$invalid) > 0) {
            warning("Invalid color values found,random color from chinacolor data set will be used")
            base_color <- chinacolor$hex[sample(1:384, size = 1)]
        }
    }

    # Helper function to convert hex to HCL (assumed to exist in your environment)
    base_hcl <- .get_hcl_values(base_color)
    base_hue <- base_hcl[,"H"]
    base_chroma <- base_hcl[,"C"]
    base_lightness <- base_hcl[,"L"]
    c_max <- max_chroma(base_hue, base_lightness)
    ratio <- base_chroma / c_max

    # Generate three base hues separated by ~120 degrees (triadic contrast)
    contrast_angle <- 180
    hues <- (base_hue + contrast_angle * (0:1)) %% 360

    # Adjust chroma based on max possible for each hue at base lightness
    lightness <- base_lightness
    chroma_1 <- max_chroma(hues, lightness) * ratio

    # Create the three main colors in HCL space
    main_color <- hcl(h = hues, c = chroma_1, l = lightness, fixup = TRUE)

    if (n == 2){
        colors_result <- main_color
    } else {
        k <- n %/% 2
        l <- n %% 2
        color_list <- list()
        for(i in seq_along(main_color)){
            color_list[[i]] <- monochromatic_palette(base_color = main_color[[i]],
                                             lightness_range = c(25,90),
                                             n = k + sign(l),
                                             ctc_colors = F,
                                             show_pal = F)
        }

        # Flatten list and remove any exact matches to main colors
        color_vec <- unlist(color_list)
        color_vec <- color_vec[!color_vec %in% main_color]

        # Interleave colors from different groups for visual balance
        odd_idx <- seq(1, length(color_vec), by = 2)
        even_idx <- seq(2, length(color_vec), by = 2)
        order_idx <- c(odd_idx, even_idx)
        color_vec <- color_vec[order_idx]

        # Combine main colors with variants and take first `n`
        colors_result <- c(main_color, color_vec)[1:n]
    }

    # Map to closest Chinese traditional colors if requested
    if (!ctc_colors) {
        palette_colors <- colors_result
    } else {
        palette_ctc_colors <- find_closest_colors(
            target_colors = colors_result,
            ref_colors = chinacolor$hex
        )
        palette_colors <- palette_ctc_colors$closest_ref
    }

    # Display the palette
    if (show_pal) {
        plot_palette(x = palette_colors, type = "custom", show_text = TRUE)
    }

    attr(palette_colors, "type") <- "qualitative"
    attr(palette_colors, "n") <- n
    attr(palette_colors, "ctc_colors") <- ctc_colors
    return(palette_colors)
}


