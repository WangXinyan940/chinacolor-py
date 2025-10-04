#' @title Generate a Harmonically Distributed Color Palette
#' @description This function creates a color palette with hues evenly distributed around the color wheel,
#' starting from a specified or randomly selected base color. Colors can be mapped to closest Chinese
#' traditional colors for cultural consistency.
#'
#' @param base_color A character string specifying the base hexadecimal color code (e.g., "#ECD452").
#' If NULL, a random color is selected from the chinacolor dataset. Defaults to NULL.
#' @param n An integer specifying the number of colors in the palette. Recommended to be between 5 and 12.
#' Defaults to 6.
#' @param ctc_colors A logical value. If TRUE, the generated colors are mapped to the closest
#' "Chinese traditional colors" from the chinacolor dataset. Defaults to TRUE.
#' @param show_pal A logical value. If TRUE, the generated palette will be plotted. Defaults to TRUE.
#'
#' @return A character vector of hexadecimal color codes with the following attributes:
#' \itemize{
#' \item \code{type}: Character string indicating the palette type, always "qualitative"
#' \item \code{n}: Number of colors in the palette
#' \item \code{ctc_colors}: Logical indicating if Chinese traditional color correction was applied
#' }
#' @details
#' The function generates colors by evenly distributing hues around the 360-degree color wheel starting from
#' the base color's hue value. Chroma and lightness are maintained relative to the base color's characteristics.
#' When ctc_colors = TRUE, each generated color is mapped to the closest match in the Chinese traditional
#' color palette for cultural authenticity.
#'
#' @importFrom colorspace max_chroma
#' @importFrom grDevices hcl
#'
#' @examples
#' \dontrun{
#' # Generate a palette based on a specific color
#' harmonic_palette(base_color = "#779649",
#' n = 7,
#' show_pal = TRUE,
#' ctc_colors = TRUE)
#'
#' # Generate a palette using a random base color
#' harmonic_palette(n = 6,
#' show_pal = TRUE,
#' ctc_colors = TRUE)
#'}

#' @export
harmonic_palette <- function(base_color = NULL,
                      n = 6,
                      ctc_colors = TRUE,
                      show_pal = TRUE) {


    data("chinacolor")

    # Input validation
    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }

    if (n < 5 || n > 12) {
        warning("It is highly recommended that the number of colors is between 5 and 12 for optimal results.")
    }

    if (!is.logical(ctc_colors) || length(ctc_colors) != 1) {
        stop("`ctc_colors` must be a single logical value (TRUE or FALSE).")
    }

    if (!is.logical(show_pal) || length(show_pal) != 1) {
        stop("`show_pal` must be a single logical value (TRUE or FALSE).")
    }

    # Set base color (random if not provided)
    if(is.null(base_color)) {
        base_color <- chinacolor$hex[sample(1:384, size = 1)]
    } else{
        color_check <- validate_colors(base_color)
        if (nrow(color_check$invalid) > 0) {
            warning("Invalid color values found,random color from chinacolor data set will be used")
            base_color <- chinacolor$hex[sample(1:384, size = 1)]
        }
    }

    # Get HCL values of base color
    base_hcl <- .get_hcl_values(base_color)
    base_hue <- base_hcl[,"H"]
    base_chroma <- base_hcl[,"C"]
    base_lightness <- base_hcl[,"L"]

    # Calculate maximum chroma and ratio for consistency
    c_max <- max_chroma(base_hue, base_lightness)
    ratio <- base_chroma / c_max

    # Generate evenly distributed hues
    hue_interval <- 360 / n
    hues <- (base_hue + hue_interval * (0:(n-1))) %% 360

    # Maintain consistent chroma and lightness
    lightness <- base_lightness
    chroma <- max_chroma(hues, lightness) * ratio

    # Generate colors in HCL color space
    colors_result <- hcl(h = hues,
                         c = chroma,
                         l = lightness,
                         fixup = TRUE)

    # Map to Chinese traditional colors if requested
    if (ctc_colors) {
        palette_ctc_colors <- chinacolor:::find_closest_colors(
            target_colors = colors_result,
            ref_colors = chinacolor$hex
        )
        palette_colors <- palette_ctc_colors$closest_ref
    } else {
        palette_colors <- colors_result
    }

    # Display palette if requested
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

