#' Find Palette (Internal Function)
#'
#' Retrieves palette data by index/name/Chinese or English name.
#'
#' @param palette Palette identifier, supports:
#'   - Numeric index (1-20)
#'   - Element name (e.g. "seq01")
#'   - Chinese name (e.g. "樱霞晕彩")
#'   - English name (e.g. "cherry_blush")
#' @return List containing palette data with structure:
#' \describe{
#'   \item{hex}{Vector of HEX color codes}
#'   \item{name}{Vector of color names}
#'   \item{palette_name}{Chinese palette name}
#'   \item{palette_name_e}{English palette name}
#'   \item{type}{Type (sequential/diverging/qualitative)}
#'   \item{color_count}{Number of colors}
#' }
#' @keywords internal
#' @noRd

find_palette <- function(palette) {
    if (missing(palette)) {
        stop("Palette identifier required. See available options with list_palettes()",
             call. = FALSE)
    }

    # Numeric index
    if (is.numeric(palette)) {
        if (!palette %in% seq_along(palette_list)) {
            stop(sprintf(
                "Invalid index %s (valid: 1-%s). Run list_palettes() to see options",
                palette,
                length(palette_list)
            ), call. = FALSE)
        }
        return(palette_list[[palette]])
    }

    # Character input
    if (is.character(palette)) {
        # Exact name match
        idx <- match(tolower(palette), tolower(names(palette_list)))
        if (!is.na(idx)) return(palette_list[[idx]])

        # Fuzzy name match
        matches <- vapply(palette_list, function(x) {
            tolower(palette) %in% tolower(c(x$palette_name, x$palette_name_e))
        }, logical(1))

        if (any(matches)) return(palette_list[[which(matches)[1]]])
    }

    # No matches found
    stop(sprintf(
        "Palette '%s' not found. Valid identifiers:\n- Index (1-%s)\n- Element name (e.g. 'seq01')\n- Chinese/English names\nRun list_palettes() for complete reference",
        palette,
        length(palette_list)
    ), call. = FALSE)
}


#' Validate Color Values and Convert to Uniform Hexadecimal Format (Internal)
#'
#' @description Internal helper function to validate color specifications and convert them
#' to standardized uppercase hexadecimal format. Not intended for direct user interaction.
#'
#' Supports:
#' 1. Standard hex colors ("#FF0000", "#F00")
#' 2. R built-in named colors ("red")
#' 3. rgb()/hsv()/hcl() function calls ("rgb(255,0,0)")
#'
#' @param colors Character vector of color values to validate.
#'
#' @return List with two components:
#' \itemize{
#'   \item \code{valid}: Character vector of valid colors in uppercase hex format
#'   \item \code{invalid}: Data frame containing:
#'         \itemize{
#'           \item \code{position}: Input vector index
#'           \item \code{value}: Original invalid value
#'         }
#' }
#'
#' @details
#' This internal function performs strict validation:
#' 1. Hex values must match regex \code{^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$}
#' 2. Named colors must be in \code{grDevices::colors()}
#' 3. Function calls are evaluated in restricted environment (only basic math operators allowed)
#'
#' Transparency (alpha) channels are not supported. All outputs are 6-character uppercase hex.
#'
#' @noRd
#' @keywords internal
validate_colors <- function(colors) {
    valid_hex <- character(length(colors))
    invalid_pos <- integer(0)
    invalid_val <- character(0)
    valid_count <- 0

    # Create secure evaluation environment
    safe_env <- new.env(parent = emptyenv())
    safe_env$c <- base::c
    safe_env$rgb <- grDevices::rgb
    safe_env$hsv <- grDevices::hsv
    safe_env$hcl <- grDevices::hcl
    safe_env$pi <- pi
    safe_env$`(` <- base::`(`

    # Add basic math operators
    math_ops <- c("+", "-", "*", "/", "%%", "%/%", "^", "(", "{", "=")
    for (op in math_ops) safe_env[[op]] <- get(op, envir = baseenv())

    for (i in seq_along(colors)) {
        color <- trimws(colors[i])

        # Case 1: Validate hex format
        if (grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", color)) {
            hex <- ifelse(nchar(color) == 4,
                          paste0("#", substr(color,2,2), substr(color,2,2),
                                 substr(color,3,3), substr(color,3,3),
                                 substr(color,4,4), substr(color,4,4)),
                          color)
            valid_count <- valid_count + 1
            valid_hex[valid_count] <- toupper(hex)
            next
        }

        # Case 2: Validate named colors
        if (color %in% grDevices::colors()) {
            rgb_vals <- grDevices::col2rgb(color)
            valid_count <- valid_count + 1
            valid_hex[valid_count] <- toupper(grDevices::rgb(
                rgb_vals[1], rgb_vals[2], rgb_vals[3],
                maxColorValue = 255
            ))
            next
        }

        # Case 3: Validate color function calls
        if (grepl("^(rgb|hsv|hcl)\\s*\\(", color, ignore.case = TRUE)) {
            tryCatch({
                parsed <- eval(parse(text = color, n = 1), envir = safe_env)

                if (is.character(parsed) &&
                    length(parsed) == 1 &&
                    grepl("^#[A-Fa-f0-9]{6}$", parsed)) {
                    valid_count <- valid_count + 1
                    valid_hex[valid_count] <- toupper(parsed)
                    next
                }
            }, error = function(e) NULL)
        }

        # Record invalid if all checks fail
        invalid_pos <- c(invalid_pos, i)
        invalid_val <- c(invalid_val, color)
    }

    # Return optimized structure
    list(valid = valid_hex[seq_len(valid_count)],
         invalid = if (length(invalid_pos) ){
             data.frame(position = invalid_pos, value = invalid_val, stringsAsFactors = FALSE)
         } else {
             data.frame(position = integer(0), value = character(0))
         }
    )

}

#' Generate Contrast Colors
#'
#' Automatically generate black/white or analogous contrast colors based on input colors
#'
#' @param hex HEX value(s) of the original color(s)
#' @param type Type of contrast color: "mono" (black/white) or "analog" (analogous)
#' @param threshold Lightness threshold (0-1), default 0.6
#' @param delta Brightness offset value for analogous colors (0-1), default 0.4
#' @param output_format Output format: "hex" (default) or "hsl"
#'
#' @return HEX values or HSL matrix of contrast colors
#' @examples
#' # Generate black and white contrast color
#' generate_contrast_color("#3498db")
#'
#' # Generate analogous contrast color (smaller offset)
#' generate_contrast_color("#3498db", "analog", delta = 0.3)
#' @noRd
#' @keywords internal

generate_contrast_color <- function(hex, type = "mono", threshold = 0.6,
                                    delta = 0.4, output_format = "hex") {
    # Validate input
    if (!type %in% c("mono", "analog")) {
        stop("type parameter must be 'mono' or 'analog'", call. = FALSE)
    }

    if (threshold < 0 || threshold > 1) {
        stop("threshold parameter must be between 0 and 1", call. = FALSE)
    }

    if (delta < 0 || delta > 1) {
        stop("delta parameter must be between 0 and 1", call. = FALSE)
    }

    # Convert HEX to HSL
    hsl <- hex_to_hsl(hex)

    # Apply contrast color logic
    result <- t(apply(hsl, 1, function(row) {
        h <- row[1]
        s <- row[2]
        l <- row[3]

        if (type == "mono") {
            # Black and white mode
            if (l > threshold) return(c(h, s, 0))   # Use black for dark backgrounds
            else return(c(h, s, 1))                 # Use white for light backgrounds
        } else {
            # Analogous color mode
            if (l > threshold) {
                new_l <- max(l - delta, 0)  # Cannot be lower than 0
            } else {
                new_l <- min(l + delta, 1)  # Cannot be higher than 1
            }
            return(c(h, s, new_l))
        }
    }))

    # Set column names
    colnames(result) <- c("h", "s", "l")

    # Format output
    if (output_format == "hex") {
        return(apply(result, 1, hsl_to_hex))
    } else {
        return(result)
    }
}

# Helper function: HEX to HSL (corrected version)
hex_to_hsl <- function(hex) {
    # Convert HEX to RGB
    rgb_mat <- col2rgb(hex)

    # Calculate HSL
    hsl <- apply(rgb_mat, 2, function(rgb_val) {
        r <- rgb_val[1]/255
        g <- rgb_val[2]/255
        b <- rgb_val[3]/255

        max_val <- max(r, g, b)
        min_val <- min(r, g, b)
        delta <- max_val - min_val

        # Calculate lightness
        l <- (max_val + min_val)/2

        # Calculate saturation
        s <- if (delta == 0) 0 else delta/(1 - abs(2*l - 1))

        # Calculate hue
        h <- 0
        if (delta != 0) {
            if (max_val == r) h <- ((g - b)/delta) %% 6
            else if (max_val == g) h <- (b - r)/delta + 2
            else h <- (r - g)/delta + 4
            h <- h * 60
        }

        # Normalize hue
        h <- h %% 360
        if (is.nan(h)) h <- 0

        c(h, s, l)
    })

    t(hsl)  # Transpose to have one color per row
}

# Helper function: HSL to HEX
hsl_to_hex <- function(hsl) {
    h <- hsl[1]
    s <- hsl[2]
    l <- hsl[3]

    # Conversion formula
    c <- (1 - abs(2*l - 1)) * s
    x <- c * (1 - abs((h/60) %% 2 - 1))
    m <- l - c/2

    # Calculate RGB based on hue range
    if (h < 60) {
        rgb_val <- c(c, x, 0)
    } else if (h < 120) {
        rgb_val <- c(x, c, 0)
    } else if (h < 180) {
        rgb_val <- c(0, c, x)
    } else if (h < 240) {
        rgb_val <- c(0, x, c)
    } else if (h < 300) {
        rgb_val <- c(x, 0, c)
    } else {
        rgb_val <- c(c, 0, x)
    }

    # Apply lightness correction and convert to HEX
    rgb_final <- rgb_val + m
    rgb_final <- pmax(pmin(rgb_final, 1), 0)
    rgb(rgb_final[1], rgb_final[2], rgb_final[3])
}


#' Internal function: Initialize Chinese fonts
#' @importFrom showtext showtext_auto
#' @importFrom sysfonts font_add
setup_chinese_font <- function() {
    # Check if showtext is installed (prompt if not)
    if (!requireNamespace("showtext", quietly = TRUE)) {
        stop("Please install the showtext package first: install.packages('showtext')",
             call. = FALSE)
    }

    # Enable showtext automatic rendering (ensure graphics devices support Chinese)
    showtext::showtext_auto()

    # 1. Prioritize loading embedded SourceHanSansSC-Regular from the package
    font_path <- system.file("fonts", "NotoSansSC-VariableFont_wght.ttf", package = "chinacolor")

    if (font_path == "") {
        # If package font is missing (extreme case), prompt user to reinstall
        warning("Embedded font file not found. Please reinstall the package: devtools::install_github('zhiming-chen/chinacolor')",
                call. = FALSE)
        # Fallback to system default font
        font_family <- get_system_default_font()
    } else {
        # Load package font, named "chinese_font"
        sysfonts::font_add(family = "base_font", regular = font_path)
        font_family <- "base_font"
    }

    return(font_family)
}

#' Internal function: Get system default Chinese font (fallback solution)
get_system_default_font <- function() {
    sys <- Sys.info()["sysname"]
    if (sys == "Windows") {
        "SimHei"  # Windows default bold font
    } else if (sys == "Darwin") {  # macOS
        "PingFang SC"  # macOS default PingFang SC
    } else {  # Linux
        "WenQuanYi Micro Hei"  # Linux default WenQuanYi Micro Hei
    }
}



#' Ensure Hue Values Are Within the 0-360 Range
#'
#' Adjusts hue angle values to fall within the standard [0, 360) degree range
#' using modulo arithmetic. Useful in color space computations where hue
#' must be normalized.
#'
#' @param hue A numeric vector representing hue angles in degrees.
#'   Values can be any real number (positive, negative, or zero).
#'
#' @return A numeric vector of the same length as input, with each value
#'   wrapped into the [0, 360) range using modulo 360 operation.
#'
#' @examples
#' # Single values
#' .ensure_hue_range(450)  # Returns 90
#' .ensure_hue_range(-30)  # Returns 330
#'
#' # Vector input
#' .ensure_hue_range(c(720, -720, 180.5))  # Returns c(0, 0, 180.5)
#'
#' @keywords internal
#' @noRd
#'
.ensure_hue_range <- function(hue) {
    hue <- hue %% 360
    return(hue)
}


#' @title Generate a vector of random color hex codes
#' @description This function generates a vector of random colors in the
#'   polar LUV color space and converts them to hexadecimal color codes.
#'
#' @param n An integer specifying the number of random colors to generate.
#'          Defaults to 1.
#' @details The function relies on the `colorspace` package, which must be
#'   installed and loaded using `library(colorspace)`. It uses the `max_chroma()`
#'   and `polarLUV()` functions from this package to ensure the generated colors
#'   are valid and visually pleasing.
#' @return A character vector of hexadecimal color codes.
#'
#' @importFrom colorspace polarLUV hex max_chroma

#'
#' @examples
#' # Generate random colors
#' random_colors()
#'
#' # Generate 5 random colors
#' random_colors(n = 5)

#' @keywords internal
#' @noRd

random_colors <- function(n = 1){

    # Generate 'n' random hue values (h), sampled from 0 to 360 degrees.
    h <- sample(0:360, size = n)

    # Generate 'n' random luminance (l) values, sampled from 10 to 90.
    l <- sample(10:90, size = n)

    # Calculate the maximum possible chroma (c_max) for the given
    # hue and luminance to stay within the LUV color space.
    c_max <- colorspace::max_chroma(h, l)

    # Generate 'n' random chroma (c) values, uniformly distributed between 0 and c_max.
    c <- runif(n, min = 0, max = c_max)

    # Create a matrix with three columns (L, C, H) for the color data.
    color_data <- matrix(data = c(l, c, h),
                         byrow = FALSE,
                         ncol = 3)

    # Convert the LUV color data to hexadecimal color codes.
    result <- colorspace::hex(colorspace::polarLUV(color_data),
                              fixup = T)

    # Return the vector of hexadecimal color codes.
    return(result)
}

#' @title Find the closest colors in a reference palette
#' @description This function finds the closest color in a `ref_colors` palette
#'   for each color in a `target_colors` vector, using a "without replacement"
#'   matching strategy. The color difference is calculated using the CIE2000 metric.
#' @param target_colors A character vector of hexadecimal color codes to be matched.
#' @param ref_colors A character vector of hexadecimal color codes representing the
#'   reference palette to search within.
#' @return A list with three elements:
#'   \itemize{
#'     \item \strong{target:} The input `target_colors`.
#'     \item \strong{closest_ref:} A character vector of the matched hexadecimal
#'       color codes from the `ref_colors` palette.
#'     \item \strong{distance:} A numeric vector of the corresponding color difference
#'       (Delta E 2000) for each match.
#'   }
#' @importFrom farver convert_colour compare_colour

#' @examples
#' # Example usage (assuming 'chinacolor' package is installed)
#' # base_colors <- c("#F0F8FF", "#F5F5DC")
#' # ref_palette <- chinacolor::chinacolor$hex
#' # find_closest_colors(target_colors = base_colors, ref_colors = ref_palette)

#' @keywords internal
#' @noRd

find_closest_colors <- function(target_colors, ref_colors) {
    # Input Validation
    if (!is.character(target_colors) || !all(grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", target_colors))) {
        stop("`target_colors` must be a character vector of valid hex codes.")
    }
    if (!is.character(ref_colors) || !all(grepl("^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$", ref_colors))) {
        stop("`ref_colors` must be a character vector of valid hex codes.")
    }

    # 1. Convert colors to CIE Lab space using a helper function
    col2lab <- function(colors) {
        # col2rgb() is a base R function, no need to import explicitly
        farver::convert_colour(
            t(col2rgb(colors)),
            from = "rgb", to = "lab",
            white_from = "D65"
        )
    }
    target_lab <- col2lab(target_colors)
    ref_lab <- col2lab(ref_colors)

    # 2. Pre-calculate distance matrix
    # Note: This is an optional step if the target/ref lists are large
    # distances <- farver::compare_colour(target_lab, ref_lab, from_space = "lab", method = "CIE2000")

    # 3. Match without replacement: iteratively select the closest available ref color
    n_target <- length(target_colors)
    n_ref <- length(ref_colors)

    if (n_target > n_ref) {
        warning("The number of target colors exceeds the number of reference colors. Some targets may not be matched.")
    }

    result_target <- character(n_target)
    result_closest <- character(n_target)
    result_distance <- numeric(n_target)

    available_refs <- ref_colors     # Available reference colors (dynamically reduced)
    available_lab <- ref_lab        # Corresponding Lab values

    for (i in 1:n_target) {
        if (length(available_refs) == 0) {
            # No more reference colors available
            result_target[i] <- target_colors[i]
            result_closest[i] <- NA_character_
            result_distance[i] <- NA_real_
            next
        }

        # Current target color's Lab values
        current_target <- target_lab[i, , drop = FALSE]

        # Calculate distance to all available reference colors
        current_distances <- farver::compare_colour(
            current_target, available_lab,
            from_space = "lab", method = "CIE2000"
        )

        # Find the closest match
        best_idx <- which.min(current_distances)

        # Record the results
        result_target[i] <- target_colors[i]
        result_closest[i] <- available_refs[best_idx]
        result_distance[i] <- current_distances[best_idx]

        # Remove the selected reference color from the available list
        available_refs <- available_refs[-best_idx]
        available_lab <- available_lab[-best_idx, , drop = FALSE]
    }

    return(list(
        target = result_target,
        closest_ref = result_closest,
        distance = result_distance
    ))
}


#' @title Convert a hexadecimal color to HCL values
#' @description An internal helper function to convert a single hexadecimal color
#'   code to its corresponding HCL (Hue, Chroma, Luminance) values.
#' @param hex_color A character string of a hexadecimal color code (e.g., "#ECD452").
#' @return A numeric matrix with one row and three columns, named "H", "C", and "L",
#'   representing the hue, chroma, and luminance of the input color.
#' @importFrom colorspace hex2RGB polarLUV
#' @keywords internal
#' @noRd
#'
.get_hcl_values <- function(hex_color) {
    rgb_val <- colorspace::hex2RGB(hex_color)
    hcl_val <- as(rgb_val, "polarLUV")
    # coords() is an S4 method that extracts coordinates from the colorspace object
    colorspace::coords(hcl_val)
}



#' Internal: Generate lightness values for color palette
#'
#' This internal function calculates a sequence of lightness values centered around
#' a base lightness value within the specified range. It ensures the generated
#' values are evenly distributed while prioritizing the base lightness position.
#'
#' @param n Number of lightness values to generate
#' @param base_lightness The central lightness value to build the sequence around
#' @param lightness_range Numeric vector of length 2 specifying min and max lightness (0-100)
#'
#' @return A numeric vector of lightness values
#'
#' @keywords internal

get_l_val <- function(n = NULL,base_lightness = NULL,lightness_range = c(15,95)){


    l_input <- lightness_range

    lightness_interval <- diff(l_input)/n

    d <- (base_lightness- min(l_input)) %% lightness_interval

    if(base_lightness - min(l_input) < lightness_interval){
        l_val <- base_lightness + lightness_interval*c(0:(n-1))
    } else{
        if(max(l_input) - base_lightness < lightness_interval){
            l_val <- base_lightness - lightness_interval*c(0:(n-1))
        }else{
            l_val <-  min(l_input) + d + lightness_interval*c(0:(n-1))
        }
    }
    return(l_val)
}


#' Internal: Order color set by lightness
#'
#' This internal function sorts a set of colors by their lightness value in
#' either ascending or descending order.
#'
#' @param color_set Character vector of hexadecimal color codes
#' @param direction Sorting direction: 1 for light to dark, 2 for dark to light
#'
#' @return The input color set reordered by lightness
#'
#' @keywords internal

ordered_color_set <- function(color_set,direction = 1){ #1 大到小，2 小到大

    color_set_order <-  color_set %>%
        .get_hcl_values() %>%
        .[,1] %>%
        order()

    color_set <- if (direction == 1){
        color_set[color_set_order]} else{
            color_set[rev(color_set_order)]
        }


    return(color_set)
}

# Helper function: Handle NULL values
#' Null Coalescing Operator
#'
#' Returns the first argument if it is not NULL, otherwise returns the second argument.
#'
#' @param a First argument.
#' @param b Second argument (default value if `a` is NULL).
#'
#' @return The value of `a` if it is not NULL, otherwise the value of `b`.
#'
#' @keywords internal
`%||%` <- function(a, b) {
    if (is.null(a)) b else a
}


