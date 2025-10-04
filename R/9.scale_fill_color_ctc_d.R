#' Discrete Color Scale for ggplot2 Using Built-in CTC Palettes or Custom Palette Objects (Outline Colors)
#'
#' Creates a discrete outline color scale for ggplot2 by retrieving colors from built-in CTC palettes
#' (seq01-seq20, div01-div20, qual01-qual20) via `ctc_palette()` or from custom palette objects with attributes.
#' Designed for mapping discrete/categorical data.
#'
#' @param palette_name
#' For built-in palette, the input as below are available:
#'  1. the name of palette(the element name for a palette in the palette_list),such as "seq01","div18",...;
#'  2. index of the palette, 01-60;
#'  3. the palette_name value in a palette, such as "vibrant_spring",for Chinese name;
#'  4. the palette_name_e value in a palette, such as "violet_bloom",for English name;
#'  5. a custom palette object with attributes (e.g., from harmonic_palette() or triadic_palette() ...functions)
#' You can get the built-in palette_name values and a quick preview the palettes by run `list_palettes()` function.
#'
#'
#' @param n Number of colors to extract from the palette. If NULL (default), uses the number of unique data categories.
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 discrete outline color scale object.
#'
#' @details
#' - Supports both built-in palettes (requires `palette_list` loaded via `data(palette_list)` first)
#' - Custom palette objects with attributes.
#' - Valid built-in palette names: sequential (seq01-seq20), diverging (div01-div20), qualitative (qual01-qual20).
#' - Custom palette objects should have a "type" attribute ("qualitative").
#' - Warns if using non-qualitative palettes (designed for continuous data) with discrete data.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#' iris$sepal_group <- cut(
#'     iris$Sepal.Length,
#'    breaks = 4,
#'    labels = paste0("组", 1:4)
#')
#'
#' # Using built-in palette
#' ggplot(iris, aes(x = Sepal.Width,
#'                       y = Petal.Width,
#'                       color = sepal_group)) +
#'    geom_point(size = 2.5) +
#'    geom_smooth(method = "lm", se = FALSE) +
#'    scale_color_ctc_d(palette_name = 60)+  # can select palette by using index, name in list,palette_name and palette_name_e values.
#'    theme_ctc_dunhuang() # use the customed theme in this package.
#'
#' # Using custom palette with attributes
#' custom_pal <-  intermediate_palette(base_color = "#ECD452", n = 6, ctc_colors = FALSE)
#' ggplot(iris, aes(x = Sepal.Width, y = Petal.Width, color = sepal_group)) +
#'    geom_point(size = 2.5) +
#'    scale_color_ctc_d(palette_name = custom_pal) +
#'    theme_ctc_dunhuang()
#' }
#'
#' @seealso
#' `ctc_palette()`,`harmonic_palette()` ...for palette generation;
#' `scale_fill_ctc_d()` for fill scales;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
scale_colour_ctc_d <- function(palette_name, n = NULL, direction = 1, ...) {


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
            stop("Custom palette must have a 'type' attribute. Expected 'qualitative', 'sequential', or 'diverging'.")
        }

        if (!palette_type %in% c("qualitative", "sequential", "diverging")) {
            stop("Custom palette type must be one of: 'qualitative', 'sequential', or 'diverging'. Found: '", palette_type, "'")
        }

        if (!palette_type %in% "qualitative") {
            warning(
                "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
            )
        }

        return(discrete_scale(
            aesthetics = "colour",
            palette = function(n_colors) {

                target_n <- n %||% n_colors
                if (length(custom_palette) >= target_n) {
                    return(custom_palette[1:target_n])
                } else {
                    warning("Custom palette has fewer colors (", length(custom_palette),
                            ") than required (", target_n, "). Some colors will be recycled.")
                    return(rep(custom_palette, length.out = target_n))
                }
            },
            ...
        ))
    }

    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Type compatibility check: Discrete functions work best with qualitative palettes
    if (!palette_type %in% "qualitative") {
        warning(
            "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
        )
    }

    discrete_scale(
        aesthetics = "colour",
        scale_name = "ctc_d",
        palette = function(n_colors) {
            ctc_palette(
                type = "built_in",
                palette_name = palette_name,
                n = n %||% n_colors,
                direction = direction
            )
        },
        ...
    )
}

# Discrete Fill Scale
#' Discrete Color Scale for ggplot2 Using Built-in CTC Palettes or Custom Palette Objects (Fill Colors)
#'
#' Creates a discrete fill color scale for ggplot2 by wrapping `scale_colour_ctc_d()` with aesthetics set to "fill".
#' Uses built-in palettes (seq20-seq20, div01-div20, qual01-qual20) via `ctc_palette()` or custom palette objects.
#'
#' @param palette_name Valid name (seq001-seq036, div001-div029, qual001-qual033) or numeric index (1-98) of a palette in `palette_list`,
#'        or a custom palette object with attributes.
#' @param n Number of colors to extract from the palette. If NULL (default), uses the number of unique data categories.
#' @param direction Numeric (1 or -1) to control color order: 1 for original order, -1 for reversed. Defaults to 1.
#' @param ... Additional arguments passed to `ggplot2::discrete_scale()` (e.g., `name` for legend title).
#'
#' @return A ggplot2 discrete fill color scale object.
#'
#' @examples
#' \dontrun{
#' data(palette_list)  # Load built-in palettes
#' # Using built-in palette
#' ggplot(mpg, aes(x = class, fill = class)) +
#'    geom_bar() +
#'    scale_fill_ctc_d(palette_name = 41)+
#'    theme_ctc_mineral()
#'
#' # Using custom palette with attributes
#' custom_pal <- concyclic_palette(base_color = "#3498DB", n = 7, ctc_colors = T)
#' ggplot(mpg, aes(x = class, fill = class)) +
#'    geom_bar() +
#'    scale_fill_ctc_d(palette_name = custom_pal) +
#'    theme_ctc_paper()
#'}
#'
#' @seealso
#' `scale_colour_ctc_d()` for outline scales;
#' `ctc_palette()`,`harmonic_palette()`and other functions for palette generation;
#' `plot_palettes()` to visualize valid palettes.
#' `list_palettes()` to display a searchable table of all available color palettes with their identifiers with color preview.
#'
#' @export
scale_fill_ctc_d <- function(palette_name, n = NULL, direction = 1, ...) {

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
            stop("Custom palette must have a 'type' attribute. Expected 'qualitative', 'sequential', or 'diverging'.")
        }

        if (!palette_type %in% c("qualitative", "sequential", "diverging")) {
            stop("Custom palette type must be one of: 'qualitative', 'sequential', or 'diverging'. Found: '", palette_type, "'")
        }


        if (!palette_type %in% "qualitative") {
            warning(
                "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
            )
        }


        return(discrete_scale(
            aesthetics = "fill",
            palette = function(n_colors) {

                target_n <- n %||% n_colors
                if (length(custom_palette) >= target_n) {
                    return(custom_palette[1:target_n])
                } else {
                    warning("Custom palette has fewer colors (", length(custom_palette),
                            ") than required (", target_n, "). Some colors will be recycled.")
                    return(rep(custom_palette, length.out = target_n))
                }
            },
            ...
        ))
    }

    # Get the type of the selected palette
    palette_type <- find_palette(palette = palette_name)$type

    # Type compatibility check: Discrete functions work best with qualitative palettes
    if (!palette_type %in% "qualitative") {
        warning(
            "Current palette type is '", palette_type, "'. For discrete data, 'qualitative' palettes are recommended for better results."
        )
    }

    discrete_scale(
        aesthetics = "fill",
        palette = function(n_colors) {
            ctc_palette(
                type = "built_in",
                palette_name = palette_name,
                n = n %||% n_colors,
                direction = direction
            )
        },
        ...
    )
}


# Alias for scale_colour_ctc_d (American English Spelling)
#' @rdname scale_colour_ctc_d
#' @export
scale_color_ctc_d <- scale_colour_ctc_d





