#' @title Generate an Analogous Color Palette
#' @description This function creates an analogous color palette based on a specified
#'   or randomly selected base color.
#'
#' @param base_color A character string specifying the base hexadecimal color code
#'   (e.g., "#ECD452"). If `NULL`, a random color is selected from the `chinacolor`
#'   dataset.
#' @param spread A numeric value specifying the angular spread of the hues on the
#'   color wheel in degrees. Defaults to 10.
#' @param n An integer specifying the number of colors in the palette.
#'   It is highly recommended to be between 3 and 7. Defaults to 6.
#' @param ctc_colors A logical value. If `TRUE`, the generated colors are mapped
#'   to the closest  "Chinese traditional colors" from the `chinacolor` dataset.
#' @param show_pal A logical value. If `TRUE`, the generated palette will be
#'   plotted.
#'
#'
#' @return A character vector of hexadecimal color codes with the following attributes:
#' \itemize{
#' \item \code{type}: Character string indicating the palette type, always "analogous"
#' \item \code{n}: Number of colors in the palette
#' \item \code{ctc_colors}: Logical indicating if Chinese traditional color correction was applied
#' }
#'
#' @importFrom colorspace max_chroma
#' @importFrom grDevices hcl
#' @examples
#'  \dontrun{
#' # Generate a palette based on a specific color
#'analogous_palette (base_color = "#779649",
#'          spread = 30,
#'          n = 7,
#'          show_pal = TRUE,
#'          ctc_colors = T)

#' # Generate a palette using a random base color
#'analogous_palette (n = 6,
#'          spread = 35,
#'          show_pal = TRUE,
#'          ctc_colors = T)
#'}
#' @export
analogous_palette <-  function(base_color = NULL,
                       spread = 15,
                       n = 6,
                       ctc_colors = TRUE,
                       show_pal = TRUE) {

    data("chinacolor")

    if (!is.numeric(spread) || length(spread) != 1 || spread <= 0) {
        stop("`spread` must be a single positive number.")
    }

    if (!is.numeric(n) || length(n) != 1 || n < 1 || round(n) != n) {
        stop("`n` must be a single positive integer.")
    }

    if(n < 3|| n > 7){
        warning("It is highly recommended that the number of colors is no less than 3 and no more than 7.")

    }

    if(floor(n/2)*spread < 10|| floor(n/2)*spread  > 45){
        warning("This setting might not produce the expected analogous colors")

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

    if(n%%2 == 1){

        hues <- .ensure_hue_range(seq(-(n-1)/2 , (n-1)/2, by = 1)*spread + base_hue)

        lightness <- base_lightness

        chroma <- max_chroma(hues,lightness)*ratio

    }else{
        lightness_2 <- if( base_lightness <= 50){
            base_lightness * 1.15
        }else{
            base_lightness * 0.85
        }

        hues <- .ensure_hue_range(c(seq(-(n/2-1) ,0 ,by = 1),
                                    seq(0, (n/2-1), by = 1))*spread + base_hue)

        lightness <- c(
            rep(base_lightness,n/2),
            lightness_2,
            rep(base_lightness,(n/2-1))
                       )
        chroma <- max_chroma(hues,lightness)*ratio
    }

    colors_result <- hcl(h = hues,
                         c = chroma,
                         l = lightness,
                         fixup = TRUE)


    if (!ctc_colors) {
        palette_colors <- colors_result
    } else {
        palette_ctc_colors <-  find_closest_colors(target_colors = colors_result,
                                                  ref_colors = chinacolor$hex)
        palette_colors <- palette_ctc_colors$closest_ref
    }


    if (show_pal) {
        plot_palette(x = rev(palette_colors),
                     type = "custom",
                     show_text = TRUE)
    }




    attr(palette_colors, "type") <- "sequential"
    attr(palette_colors, "n") <- n
    attr(palette_colors, "ctc_colors") <- ctc_colors



    return(palette_colors)
}

