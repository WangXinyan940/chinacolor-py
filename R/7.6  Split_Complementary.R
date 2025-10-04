#' @title Generate a Split-Complementary Color Palette
#' @description This function generates a color palette based on a split-complementary
#'   color scheme derived from a base color. It selects three hues: the base hue and
#'   two hues located at approximately +150° and -150° (i.e., ±150 degrees) on the
#'   color wheel, forming a split-complementary triad. For each of these three primary
#'   colors, monochromatic variants are generated to expand the palette to the desired
#'   total number of colors (`n`). Optionally, the resulting colors can be mapped to
#'   the closest traditional Chinese colors from the \code{chinacolor} dataset.
#'
#' @param base_color A character string specifying the base hexadecimal color code
#'   (e.g., "#ECD452"). If \code{NULL}, a random color is selected from the \code{chinacolor} dataset.
#' @param n An integer specifying the total number of colors in the palette.
#'   Must be between 3 and 9. Defaults to 6.
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
#' # Generate a 7-color split-complementary palette from a specific base color
#' split_complementary_palette(base_color = "#779649", n = 7, ctc_colors = TRUE, show_pal = TRUE)
#'
#' # Generate a 6-color palette using a random base color
#' split_complementary_palette(n = 6, ctc_colors = TRUE, show_pal = TRUE)
#' }
#'
#' @export
 split_complementary_palette <- function(base_color = NULL,
                                                n = 6,
                                                ctc_colors = TRUE,
                                                show_pal = TRUE) {

    data("chinacolor")

    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }

    if(n < 3 || n > 9){
        stop("The number of colors is no less than 3 and no more than 9 for this function")
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

    base_hcl <- .get_hcl_values(base_color)
    base_hue <- base_hcl[,"H"]
    base_chroma <- base_hcl[,"C"]
    base_lightness <- base_hcl[,"L"]
    c_max <- max_chroma(base_hue,base_lightness)
    ratio <- base_chroma/c_max

    # Generate three colors at ~120-degree intervals (triadic contrast)
    contrast_angle <- 150
    hues <-  (base_hue + contrast_angle * c(0,1,-1)) %% 360

    lightness <- base_lightness
    chroma_1 <- max_chroma(hues, lightness) * ratio

    # Create the three main colors
    main_color <- hcl(h = hues,
                      c = chroma_1,
                      l = lightness,
                      fixup = TRUE)

    if (n == 3){
        colors_result <- main_color
    } else {
        k <- n %/% 3
        l <- n %% 3
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

    if (!ctc_colors) {
        palette_colors <- colors_result
    } else {
        palette_ctc_colors <- find_closest_colors(target_colors = colors_result,
                                                               ref_colors = chinacolor$hex)
        palette_colors <- palette_ctc_colors$closest_ref
    }

    if (show_pal) {
        plot_palette(x = palette_colors,
                     type = "custom",
                     show_text = TRUE)
    }
    attr(palette_colors, "type") <- "qualitative"
    attr(palette_colors, "n") <- n
    attr(palette_colors, "ctc_colors") <- ctc_colors
    return(palette_colors)
}
