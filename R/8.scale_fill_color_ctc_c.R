#' Continuous Color Scale for ggplot2 Using Built-in CTC Palettes or Custom Palette Objects (Outline Colors)
#'
#' Creates a continuous outline color scale for ggplot2 using sequential or diverging palettes
#' from built-in CTC palettes (seq01-seq20, div01-div20, qual01-qual20) or custom palette  via `ctc_palette()`,
#' or custom palette objects with "sequential" or "diverging" type attributes via `monochromatic_palette()` or `analogous_palette()`,
#'  Designed for mapping continuous data with smooth gradient interpolation.
#'
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "earth_autumn",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#'  5. a custom palette object with attributes (e.g., from `ctc_palette()`,`diverging_palette()`,`monochromatic_palette()` or `analogous_palette()`)
#' You can get the built-in palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::scale_color_gradientn()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 continuous outline color scale object.
#'
#' @details
#' - Supports both built-in palettes (requires `palette_list` loaded via `data(palette_list)` first)
#' - Custom palette objects with attributes.
#' - Valid built-in palette names: sequential (seq01-seq20), diverging (div01-div20), qualitative (qual01-qual20).
#' - Custom palette objects should have a "type" attribute ("sequential", or "diverging").
#' - Warns if using qualitative palettes (designed for categorical data) with continuous data.

#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#'
#' # 1 Use sequential palette "seq05" for continuous data
#' ggplot(airquality, aes(x = Day, y = Temp, color = Ozone)) +
#'   geom_point(size = 4) +
#'   scale_colour_ctc_c(palette_name = "seq05", direction = 1)
#'
#' # 2 Use diverging palette via index (38 = div18)
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'   geom_point(size = 4) +
#'   scale_colour_ctc_c(palette_name = 38, direction = -1)

#' # 3 Use palette_name value,a Chinese name for palette
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'     geom_point(size = 4) +
#'     scale_colour_ctc_c(palette_name = "碧霄流澈", direction = 1)

#' # 4 Use palette_name_e value,a English name for palette
#' ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'     geom_point(size = 4) +
#'     scale_colour_ctc_c(palette_name = "ocean_rose", direction = -1)
#'
#'
#'  # 5. Using custom palette with attributes from monochromatic_palette()
#'custom_seq_pal <- monochromatic_palette(base_color = "#FF6B6B",
#'                                           n = 8,
#'                                          ctc_colors = FALSE)

#'ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'    geom_point(size = 4) +
#'    scale_colour_ctc_c(palette_name = custom_seq_pal, direction = 1)
#'
#' # 6. Using custom palette with attributes from ctc_palette()
#'custom_pick <- create_color_pick(
#'    groups = c(22,13,66),
#'    subgroups = list(-1,1,c(1,2,3,4)),  # -1 reverses subgroup order (4:3:2:1)
#'    order_rule = 1
#'
#'custom_div_pal <- ctc_palette(
#'    type = "custom",
#'    color_pick = custom_pick,
#'    show_colors = TRUE,
#'    palette_type = "diverging",
#'    palette_title = "diverging palette"
#')
#'ggplot(mtcars, aes(x = wt, y = mpg, color = hp)) +
#'    geom_point(size = 4) +
#'    scale_colour_ctc_c(palette_name = custom_div_pal, direction = 1)
#'
#'
#' }
#'
#' @seealso
#' `ctc_palette()`,`diverging_palette()`,`monochromatic_palette()` or `analogous_palette()`for palette generation;
#' `scale_fill_ctc_c()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#' @export


scale_colour_ctc_c <- function(palette_name, direction = 1, ...) {

    if (is.character(palette_name) && length(palette_name) == 1) {

        if (exists(palette_name, envir = parent.frame())) {
            env_object <- get(palette_name, envir = parent.frame())

            if (is.character(env_object) && length(env_object) > 1) {
                palette_name <- env_object
            }
        }
    }


    if (is.character(palette_name) && length(palette_name) > 1) {
        custom_palette <- palette_name


        color_check <- validate_colors(custom_palette)
        if (nrow(color_check$invalid) > 0) {
            stop("Invalid color values found in custom palette: ",
                 paste(color_check$invalid$value, collapse = ", "))
        }
        if (length(color_check$valid) == 0) {
            stop("No valid color values found in custom palette.")
        }


        palette_type <- attr(custom_palette, "type")


        if (is.null(palette_type)) {
            stop("Custom palette must have a 'type' attribute. Expected 'sequential' or 'diverging' for continuous scales.")
        }

        if (!palette_type %in% c("sequential", "diverging")) {
            stop("Custom palette type must be 'sequential' or 'diverging' for continuous scales. Found: '", palette_type, "'")
        }


        if (direction == -1) {
            custom_palette <- rev(custom_palette)
        }

        return(
            continuous_scale(
                aesthetics = "colour",
                scale_name = "ctc_c",
                palette = scales::gradient_n_pal(custom_palette),
                ...
            )
        )
    }


    palette_type <- find_palette(palette = palette_name)$type


    if (!palette_type %in% c("sequential", "diverging")) {
        warning(
            "Current palette type is '", palette_type, "'. For continuous data, 'sequential' or 'diverging' palettes are recommended."
        )
    }

    continuous_scale(
        aesthetics = "colour",
        scale_name = "ctc_c",
        palette = function(x) {
            ctc_palette(
                type = "built_in",
                palette_name = palette_name,
                n = length(x),
                direction = direction
            )
        },
        ...
    )
}


#' Continuous Fill Scale for ggplot2 Using Built-in CTC Palettes or Custom Palette Objects (Outline Colors)
#'
#' Creates a continuous outline fill scale for ggplot2 using sequential or diverging palettes
#' from built-in CTC palettes (seq01-seq20, div01-div20, qual01-qual20) or custom palette  via `ctc_palette()`,
#' or custom palette objects with "sequential" or "diverging" type attributes via `monochromatic_palette()` or `analogous_palette()`,
#'  Designed for mapping continuous data with smooth gradient interpolation.
#'
#'
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "earth_autumn",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#'  5. a custom palette object with attributes (e.g., from `ctc_palette()`,`diverging_palette()`,`monochromatic_palette()` or `analogous_palette()`)
#' You can get the built-in palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::scale_color_gradientn()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 continuous outline fill scale object.
#'
#' @details
#' - Supports both built-in palettes (requires `palette_list` loaded via `data(palette_list)` first)
#' - Custom palette objects with attributes.
#' - Valid built-in palette names: sequential (seq01-seq20), diverging (div01-div20), qualitative (qual01-qual20).
#' - Custom palette objects should have a "type" attribute ("sequential", or "diverging").
#' - Warns if using qualitative palettes (designed for categorical data) with continuous data.

#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#'
#' # 1 Use diverging palette for fill,
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'   geom_raster() +
#'   scale_fill_ctc_c(palette_name = "div12", direction = -1, name = "Density")
#'
#'   # 2 palette by index value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#' geom_raster() +
#'     scale_fill_ctc_c(palette_name = 33, direction = 1, name = "Density")
#'
#'   # 3 palette by Chinese palette_name value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = "海天沙影", direction = 1, name = "Density")
#'
#'   # 4 palette by English palette_name_e value
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = "ocean_rose", direction = -1, name = "Density")
#'
#'   # 5 Using custom palette with attributes from diverging_palette()
#' custom_div_pal <- diverging_palette(base_color = "#336B6B",
#'                                     n = 8,
#'                                     ctc_colors = TRUE)
#'
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = custom_div_pal, direction = -1, name = "Density")



# 6. Using custom palette with attributes from ctc_palette()
#' custom_pick <- create_color_pick(
#'     groups = c(12,13,76),
#'     subgroups = list(-1,1,c(1,2,3,4)),  # -1 reverses subgroup order (4:3:2:1)
#'     order_rule = 1)

#' custom_div_pal2 <- ctc_palette(
#'     type = "custom",
#'     color_pick = custom_pick,
#'     show_colors = TRUE,
#'     palette_type = "diverging",
#'     palette_title = "diverging palette"
#' )
#' ggplot(faithfuld, aes(x = eruptions, y = waiting, fill = density)) +
#'     geom_raster() +
#'     scale_fill_ctc_c(palette_name = custom_div_pal2, direction = 1, name = "Density")
#'
#' }
#'
#' @seealso
#' `ctc_palette()`,`diverging_palette()`,`monochromatic_palette()` or `analogous_palette()`for palette generation;
#' `scale_colour_ctc_c()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#' @export
scale_fill_ctc_c <- function(palette_name, direction = 1, ...) {

    if (is.character(palette_name) && length(palette_name) == 1) {

        if (exists(palette_name, envir = parent.frame())) {
            env_object <- get(palette_name, envir = parent.frame())

            if (is.character(env_object) && length(env_object) > 1) {
                palette_name <- env_object
            }
        }
    }


    if (is.character(palette_name) && length(palette_name) > 1) {
        custom_palette <- palette_name

        color_check <- validate_colors(custom_palette)
        if (nrow(color_check$invalid) > 0) {
            stop("Invalid color values found in custom palette: ",
                 paste(color_check$invalid$value, collapse = ", "))
        }
        if (length(color_check$valid) == 0) {
            stop("No valid color values found in custom palette.")
        }


        palette_type <- attr(custom_palette, "type")


        if (is.null(palette_type)) {
            stop("Custom palette must have a 'type' attribute. Expected 'sequential' or 'diverging' for continuous scales.")
        }

        if (!palette_type %in% c("sequential", "diverging")) {
            stop("Custom palette type must be 'sequential' or 'diverging' for continuous scales. Found: '", palette_type, "'")
        }


        if (direction == -1) {
            custom_palette <- rev(custom_palette)
        }

        return(continuous_scale(
            aesthetics = "fill",

            palette = scales::gradient_n_pal(custom_palette),
            ...
        ))
    }

    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Check palette type compatibility with continuous data
    if (palette_type %in% "qualitative") {
        warning("For continuous data, it is recommended to use 'sequential' or 'diverging' type palettes")
    }

    # Directly use scale_fill_gradientn for fill aesthetics
    scale_fill_gradientn(
        colors = ctc_palette(
            type = "built_in",
            palette_name = palette_name,
            direction = direction
        ),
        ...
    )
}


#' Alias for scale_colour_ctc_c (American English Spelling)
#'
#' Convenience alias for `scale_colour_ctc_c()` to support American English.
#'
#' @inheritParams scale_colour_ctc_c
#' @export
scale_color_ctc_c <- scale_colour_ctc_c
