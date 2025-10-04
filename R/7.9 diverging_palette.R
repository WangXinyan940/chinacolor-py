#' @title Generate a diverging color palette
#' @description This function creates a diverging color palette based on a specified
#'   or randomly selected base color, with colors diverging in hue while maintaining
#'   lightness variations.
#'
#' @details The function generates a diverging palette by creating two monochromatic
#'   sequences from complementary hues and combining them. It leverages the HCL color
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
#'   Defaults to 6. Must be at least 3.
#' @param angle A numeric value specifying the hue divergence angle in degrees.
#'   Positive values rotate clockwise, negative values counterclockwise.
#'   Must be between -360 and 360. Defaults to 120.
#' @param ctc_colors A logical value. If `TRUE`, the generated colors are mapped
#'   to the closest "Chinese traditional colors" from the `chinacolor` dataset.
#' @param show_pal A logical value. If `TRUE`, the generated palette will be
#'   plotted.
#'
#' @return A character vector of hexadecimal color codes with the following attributes:
#' \itemize{
#' \item \code{type}: Character string indicating the palette type, always "diverging"
#' \item \code{n}: Number of colors in the palette
#' \item \code{ctc_colors}: Logical indicating if Chinese traditional color correction was applied
#' }
#'
#' @importFrom colorspace max_chroma
#' @importFrom grDevices hcl
#'
#' @examples
#' \dontrun{
#' # Generate a diverging palette based on a specific color
#' diverging_palette(base_color = "#ECD452",
#'                   n = 6,
#'                   angle = 120,
#'                   lightness_range = c(30, 85),
#'                   show_pal = TRUE)
#'
#' # Generate a diverging palette using a random base color
#' diverging_palette(n = 7,
#'                   angle = 90,
#'                   lightness_range = c(30, 95),
#'                   show_pal = TRUE)
#'
#' # Generate a palette with custom divergence angle
#' diverging_palette(base_color = "#3498DB",
#'                   n = 5,
#'                   angle = 180,  # Complementary colors
#'                   ctc_colors = FALSE,
#'                   show_pal = TRUE)
#'
#' }
#'
#' @export
#'
diverging_palette <- function(base_color = NULL,
                                  lightness_range = c(25,85),
                                  n = 6,
                                  angle =120,
                                  ctc_colors = TRUE,
                                  show_pal = TRUE){

    data("chinacolor")

    if (!is.numeric(lightness_range) || length(lightness_range) != 2 ||
        lightness_range[1] >= lightness_range[2] ||
        any(lightness_range < 0 | lightness_range > 100)) {
        stop("`lightness_range` must be a numeric vector of length 2, with min < max, and values between 0 and 100.")
    }

    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }
    if (n < 3 ) {
        stop("The number of colors must not less than 3.")
    }

    if(abs(angle) > 360){
        stop("The angle  must between -360 and 360.")
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

    c_max <-  max_chroma(base_hue, base_lightness)
    ratio <- base_chroma / max_chroma(base_hue, base_lightness)

    hue_2 <- (base_hue +  angle) %% 360
    chroma_2 <- max_chroma(hue_2, base_lightness) * ratio
    color_2 <- hcl(hue_2, chroma_2,base_lightness,fixup = T)

    color_3 <- hcl(base_hue,0,max(lightness_range),fixup = T)

    color_set_1 <- monochromatic_palette(base_color = base_color,
                                 lightness_range = lightness_range,
                                 n = floor(n/2),
                                 ctc_colors = F,
                                 show_pal = F) %>%
        ordered_color_set(direction = 1)

    color_set_2 <- monochromatic_palette(base_color = color_2,
                                 lightness_range = lightness_range,
                                 n = floor(n/2),
                                 ctc_colors = F,
                                 show_pal = F)%>%
        ordered_color_set(direction = 2)



    if(n%%2 ==0){
        colors_result <- c(color_set_1,color_set_2)
    } else{
        colors_result <- c(color_set_1,color_3,color_set_2)
    }

    # Map to closest Chinese traditional colors if requested
    if (!ctc_colors) {
        palette_colors <- colors_result
    } else {
        palette_ctc_colors <-  find_closest_colors(
            target_colors = colors_result,
            ref_colors = chinacolor$hex
        )
        palette_colors <- palette_ctc_colors$closest_ref
    }

    # Display the palette
    if (show_pal) {
        plot_palette(x = palette_colors, type = "custom", show_text = TRUE)
    }
    attr(palette_colors, "type") <- "diverging"
    attr(palette_colors, "n") <- n
    attr(palette_colors, "ctc_colors") <- ctc_colors

    return(palette_colors)

}
