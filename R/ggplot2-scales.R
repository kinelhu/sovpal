#' ggplot2 color scale for sovpal palettes
#'
#' @description
#' A ggplot2 scale for the `colour` aesthetic using sovpal palettes.
#'
#' The scale uses the named palette as defined. No colors are dropped or
#' interpolated for a discrete scale. See [sovpal_palettes()] for the full list
#' and [palette_info()] for per-color white-background contrast.
#'
#' Requires the \pkg{ggplot2} package.
#'
#' @param palette Character. Palette name. Default `"gost14202"`.
#' @param discrete Logical. If `TRUE` (default), uses a discrete scale. If
#'   `FALSE`, uses a continuous gradient via [ggplot2::scale_color_gradientn()].
#' @param direction Integer. `1` (default, normal) or `-1` (reversed).
#' @param ... Additional arguments passed to the underlying ggplot2 scale.
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'
#'   # An artwork-derived qualitative palette
#'   ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
#'     geom_point() +
#'     scale_color_sovpal("malevich")
#'
#'   # GOST pipeline palette
#'   ggplot(iris, aes(Sepal.Length, Sepal.Width, colour = Species)) +
#'     geom_point() +
#'     scale_color_sovpal("gost14202")
#'
#'   # Continuous steppe gradient
#'   ggplot(faithfuld, aes(waiting, eruptions, colour = density)) +
#'     geom_point() +
#'     scale_color_sovpal("steppe", discrete = FALSE)
#' }
#'
#' @export
scale_color_sovpal <- function(palette = "gost14202", discrete = TRUE,
                                direction = 1, ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop(
      "ggplot2 is required for scale_color_sovpal(). ",
      "Install it with: install.packages('ggplot2')",
      call. = FALSE
    )
  }

  if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "colour",
      palette    = function(n) unname(sovpal(palette, n = n, direction = direction)),
      ...
    )
  } else {
    ggplot2::scale_color_gradientn(
      colours = sovpal(palette, n = 256, type = "continuous", direction = direction),
      ...
    )
  }
}


#' @rdname scale_color_sovpal
#' @export
scale_colour_sovpal <- function(...) scale_color_sovpal(...)


#' ggplot2 fill scale for sovpal palettes
#'
#' @description
#' A ggplot2 scale for the `fill` aesthetic using sovpal palettes. Uses the
#' named palette exactly as defined.
#'
#' Requires the \pkg{ggplot2} package.
#'
#' @param palette Character. Palette name. Default `"gost14202"`.
#' @param discrete Logical. If `TRUE` (default), uses a discrete scale. If
#'   `FALSE`, uses a continuous gradient via [ggplot2::scale_fill_gradientn()].
#' @param direction Integer. `1` (default, normal) or `-1` (reversed).
#' @param ... Additional arguments passed to the underlying ggplot2 scale.
#'
#' @return A ggplot2 scale object.
#'
#' @examples
#' if (requireNamespace("ggplot2", quietly = TRUE)) {
#'   library(ggplot2)
#'
#'   # Full GOST pipeline palette as bar fill
#'   ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
#'     geom_bar() +
#'     scale_fill_sovpal("gost14202")
#'
#'   # Colorblind-safe diverging heatmap
#'   ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'     geom_tile() +
#'     scale_fill_sovpal("hazard_cvd", discrete = FALSE)
#'
#'   # An artwork-derived palette as fill
#'   ggplot(iris, aes(Species, Sepal.Length, fill = Species)) +
#'     geom_boxplot() +
#'     scale_fill_sovpal("popova")
#' }
#'
#' @export
scale_fill_sovpal <- function(palette = "gost14202", discrete = TRUE,
                               direction = 1, ...) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop(
      "ggplot2 is required for scale_fill_sovpal(). ",
      "Install it with: install.packages('ggplot2')",
      call. = FALSE
    )
  }

  if (discrete) {
    ggplot2::discrete_scale(
      aesthetics = "fill",
      palette    = function(n) unname(sovpal(palette, n = n, direction = direction)),
      ...
    )
  } else {
    ggplot2::scale_fill_gradientn(
      colours = sovpal(palette, n = 256, type = "continuous", direction = direction),
      ...
    )
  }
}
