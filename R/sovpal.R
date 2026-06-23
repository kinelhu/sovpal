#' sovpal: Soviet and Industrial Color Palettes
#'
#' @description
#' Color palettes drawn from the Soviet industrial world. Each palette has a
#' thematic `domain` and a functional `type` (qualitative / sequential /
#' diverging):
#'
#' * `industrial`: GOST civil and industrial standards (`gost14202`, `gost_signal`).
#' * `military`: Soviet military paint and camouflage (`soviet_military`, `steppe`).
#' * `artistic`: palettes color-sampled from specific artworks, named for the
#'   artist (`lissitzky`, `popova`, `stepanova`, `malevich`).
#' * `composite`: diverging scales assembled from the others (`hazard`,
#'   `hazard_warm`, `hazard_cvd`).
#'
#' To subset or slice a palette, index the returned named vector with base R,
#' e.g. `sovpal("gost14202")[c("water", "fire")]` or `sovpal("steppe")[2:3]`.
#'
#' @name sovpal-package
#' @docType package
#' @keywords internal
"_PACKAGE"


#' Retrieve a sovpal color palette
#'
#' @description
#' Returns a vector of hex color codes from a named Soviet/industrial color
#' palette. All hex values are historically sourced and unmodified.
#'
#' To select or reorder colors, index the returned named vector with base R
#' (e.g. `sovpal("gost14202")[c("water", "fire")]`). For a colorblind-safe
#' diverging scale, use `"hazard_cvd"`.
#'
#' @param name Character. Palette name (case-insensitive). See
#'   [sovpal_palettes()] for the full list, grouped by domain:
#'   industrial (`"gost14202"`, `"gost_signal"`), military
#'   (`"soviet_military"`, `"steppe"`), artistic (`"lissitzky"`, `"popova"`,
#'   `"stepanova"`, `"malevich"`), and composite (`"hazard"`, `"hazard_warm"`,
#'   `"hazard_cvd"`).
#' @param n Integer or NULL. Number of colors to return. If `NULL`, returns all
#'   defined stops. If `n` exceeds the number of available stops, colors are
#'   interpolated (type is inferred as continuous).
#' @param type Character or NULL. `"discrete"` or `"continuous"`. If `NULL`,
#'   inferred: discrete when `n <= stops`, continuous otherwise.
#' @param direction Integer. `1` (default, normal order) or `-1` (reversed).
#'
#' @return A named character vector of hex codes (discrete) or an unnamed
#'   character vector (continuous).
#'
#' @examples
#' # Full 8-color GOST pipeline palette
#' sovpal("gost14202")
#'
#' # First 3 colors
#' sovpal("gost14202", n = 3)
#'
#' # Select colors by name with base R indexing
#' sovpal("gost14202")[c("water", "fire", "air")]
#'
#' # Slice a sequential palette to skip a light anchor stop
#' sovpal("steppe")[2:3]
#'
#' # An artwork-derived palette
#' sovpal("malevich")
#'
#' # Interpolate 100 colors from steppe
#' sovpal("steppe", n = 100, type = "continuous")
#'
#' # Reversed hazard palette
#' sovpal("hazard", direction = -1)
#'
#' @importFrom grDevices colorRampPalette
#' @export
sovpal <- function(name, n = NULL, type = NULL, direction = 1) {
  name <- .sovpal_match_name(name)
  pal  <- .sovpal_palettes[[name]]

  n_avail <- length(pal)
  if (is.null(n)) n <- n_avail
  n <- as.integer(n)

  if (is.null(type)) {
    type <- if (n <= n_avail) "discrete" else "continuous"
  }

  if (type == "discrete") {
    if (n > n_avail) {
      stop(
        sprintf(
          paste0("Cannot return %d discrete colors from '%s': only %d ",
                 "available. Use type = 'continuous' to interpolate."),
          n, name, n_avail
        ),
        call. = FALSE
      )
    }
    result <- pal[seq_len(n)]
  } else {
    result <- grDevices::colorRampPalette(as.character(pal))(n)
  }

  if (direction == -1) result <- rev(result)
  result
}


#' List available sovpal palettes
#'
#' @description
#' Returns a data frame describing every palette: its name, domain (industrial,
#' military, artistic, or composite), type, and number of color stops. Useful
#' for programmatic discovery and for tools that ingest the package (e.g.
#' \pkg{paletteer}).
#'
#' @return A data frame with columns `palette`, `domain`, `type`, and
#'   `n_colors`, ordered as the palettes are defined.
#'
#' @examples
#' sovpal_palettes()
#'
#' @export
sovpal_palettes <- function() {
  nms <- names(.sovpal_palettes)
  data.frame(
    palette  = nms,
    domain   = vapply(nms, function(nm) .sovpal_meta[[nm]]$domain %||% NA_character_,
                      character(1)),
    type     = vapply(.sovpal_palettes, function(p) attr(p, "type"), character(1)),
    n_colors = vapply(.sovpal_palettes, length, integer(1)),
    row.names = NULL,
    stringsAsFactors = FALSE
  )
}


#' Display a single sovpal palette
#'
#' @description
#' Renders a horizontal color swatch bar with color names and hex codes using
#' base R graphics. When `notes = TRUE`, any white-background, recommended-use,
#' or colorblindness notes for the palette are printed to the console.
#'
#' @param name Character. Palette name (case-insensitive).
#' @param notes Logical. If `TRUE` (default), print palette usage notes to the
#'   console when available.
#'
#' @return Invisibly returns `NULL`. Called for its side effects.
#'
#' @examples
#' \donttest{
#' show_palette("gost14202")
#' show_palette("hazard")
#' show_palette("hazard_cvd")
#' }
#'
#' @importFrom graphics par image axis
#' @export
show_palette <- function(name, notes = TRUE) {
  name  <- .sovpal_match_name(name)
  pal   <- .sovpal_palettes[[name]]
  ptype <- attr(pal, "type")
  cols  <- as.character(pal)
  nms   <- if (!is.null(names(pal))) names(pal) else paste0("stop", seq_along(cols))
  n     <- length(cols)

  op <- graphics::par(mar = c(5.5, 0.5, 2, 0.5), no.readonly = TRUE)
  on.exit(graphics::par(op))

  graphics::image(
    seq_len(n), 1, matrix(seq_len(n), ncol = 1),
    col  = cols,
    axes = FALSE,
    main = sprintf("%s  [%s]", name, ptype),
    xlab = "", ylab = ""
  )
  graphics::axis(
    side     = 1,
    at       = seq_len(n),
    labels   = paste0(nms, " ", cols),
    tick     = FALSE,
    cex.axis = 0.6,
    las      = 2
  )

  if (isTRUE(notes)) {
    meta <- .sovpal_meta[[name]]
    if (!is.null(meta)) {
      for (field in c("white_note", "recommended_use", "cvd_note")) {
        if (!is.null(meta[[field]])) message(meta[[field]])
      }
    }
  }
  invisible(NULL)
}


#' Display all sovpal palettes
#'
#' @description
#' Renders palettes stacked vertically using base R graphics, one row per
#' palette labeled with its name and type. Filter by color type and/or domain.
#'
#' @param type Character or NULL. If specified, show only palettes of this
#'   type: `"qualitative"`, `"sequential"`, or `"diverging"`.
#' @param domain Character or NULL. If specified, show only palettes of this
#'   domain: `"industrial"`, `"military"`, `"artistic"`, or `"composite"`.
#'
#' @return Invisibly returns `NULL`. Called for its side effects.
#'
#' @examples
#' \donttest{
#' show_all_palettes()
#' show_all_palettes(type = "qualitative")
#' show_all_palettes(domain = "artistic")
#' }
#'
#' @importFrom graphics par image mtext
#' @export
show_all_palettes <- function(type = NULL, domain = NULL) {
  pals <- .sovpal_palettes

  if (!is.null(type)) {
    keep <- vapply(pals, function(p) identical(attr(p, "type"), type), logical(1))
    pals <- pals[keep]
  }
  if (!is.null(domain)) {
    keep <- vapply(names(pals), function(nm) identical(.sovpal_meta[[nm]]$domain, domain),
                   logical(1))
    pals <- pals[keep]
  }
  if (length(pals) == 0) {
    stop("No palettes match the requested type/domain filter.", call. = FALSE)
  }

  n_pals    <- length(pals)
  pal_names <- names(pals)

  op <- graphics::par(
    mfrow = c(n_pals, 1),
    mar   = c(0.3, 9, 0.3, 0.5),
    oma   = c(0, 0, 2, 0),
    no.readonly = TRUE
  )
  on.exit(graphics::par(op))

  for (nm in pal_names) {
    pal   <- pals[[nm]]
    ptype <- attr(pal, "type")
    cols  <- as.character(pal)
    n     <- length(cols)
    graphics::image(
      seq_len(n), 1, matrix(seq_len(n), ncol = 1),
      col  = cols,
      axes = FALSE,
      xlab = "", ylab = ""
    )
    graphics::mtext(
      sprintf("%s  [%s]", nm, ptype),
      side = 2, las = 1, line = 0.5, cex = 0.7
    )
  }
  graphics::mtext("sovpal palettes", outer = TRUE, cex = 1, line = 0.5)
  invisible(NULL)
}


#' Retrieve palette metadata
#'
#' @description
#' Returns a list describing a palette: its domain, type, color stops,
#' provenance, intended use, colorblindness caveats, and computed
#' white-background contrast. Contrast is derived from the hex values (WCAG
#' relative luminance), not hand-maintained.
#'
#' @param name Character. Palette name (case-insensitive).
#'
#' @return A named list with elements: `name`, `domain`, `type`, `n_colors`,
#'   `color_names`, `hex_values`, `source`, `recommended_use`, `cvd_note`,
#'   `contrast_white` (WCAG contrast ratio of each color against white),
#'   `low_contrast_on_white` (colors below the WCAG 3:1 non-text threshold),
#'   and `white_note`.
#'
#' @examples
#' palette_info("gost14202")
#' palette_info("hazard")
#' palette_info("hazard_cvd")
#'
#' @export
palette_info <- function(name) {
  name  <- .sovpal_match_name(name)
  pal   <- .sovpal_palettes[[name]]
  meta  <- .sovpal_meta[[name]]
  hex   <- as.character(pal)
  nms   <- names(pal)

  contrast <- .sovpal_contrast_on_white(hex)
  low      <- if (!is.null(nms)) nms[contrast < 3] else hex[contrast < 3]

  list(
    name                  = name,
    domain                = meta$domain %||% NA_character_,
    type                  = attr(pal, "type"),
    n_colors              = length(pal),
    color_names           = nms,
    hex_values            = hex,
    source                = meta$source %||% NA_character_,
    recommended_use       = meta$recommended_use,
    cvd_note              = meta$cvd_note,
    contrast_white        = round(unname(contrast), 2),
    low_contrast_on_white = low,
    white_note            = meta$white_note
  )
}


# --- internal helpers --------------------------------------------------------

# Validate and normalize a palette name, with an informative error.
.sovpal_match_name <- function(name) {
  name      <- tolower(as.character(name))
  available <- names(.sovpal_palettes)
  if (!name %in% available) {
    stop(
      sprintf(
        "'%s' is not a valid palette name. Available palettes: %s",
        name, paste(available, collapse = ", ")
      ),
      call. = FALSE
    )
  }
  name
}

`%||%` <- function(x, y) if (is.null(x)) y else x
