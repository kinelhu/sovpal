# Internal palette data. Hex values are historically sourced and must not be
# modified. See the verification table in the package documentation.
#
# Palettes are grouped into two tiers:
#   * "archival" -- canonical, faithful to a source document or reference.
#   * "viz"      -- visualization-optimized. These NEVER introduce new hex
#                   values: they only select or reorder colors that already
#                   appear in an archival palette, for distinctness, contrast,
#                   or colorblind safety.

.sovpal_palettes <- list(

  # --- Qualitative (archival) ------------------------------------------------

  gost14202 = structure(
    c(
      water  = "#2E7D32",   # green  -- water mains
      fire   = "#C62828",   # red    -- fire suppression / superheated steam
      air    = "#5B8DB8",   # blue   -- compressed air
      gas    = "#F9A825",   # yellow -- flammable gases, acids
      toxic  = "#E64A19",   # orange -- toxic / corrosive substances
      alkali = "#8E6EAF",   # violet -- alkalis
      fuel   = "#5D4037",   # brown  -- combustibles, oils, fuel
      other  = "#78909C"    # grey   -- condensate, coolant, misc fluids
    ),
    type = "qualitative"
  ),

  soviet_military = structure(
    c(
      green_4bo  = "#51653F",  # 4BO Protective Green exterior
      turquoise  = "#5B8F8C",  # cockpit/interior turquoise
      primer     = "#C45830",  # red lead primer
      soviet_red = "#CD2500",  # flag and insignia red
      brown_6k   = "#3D2B1F",  # Dark Brown 6K camouflage
      sand_7k    = "#C9A96E"   # Yellow Earth 7K camouflage
    ),
    type = "qualitative"
  ),

  constructivist = structure(
    c(
      red    = "#CD2500",  # Soviet propaganda red
      black  = "#1A1A1A",  # near-black
      yellow = "#F9A825",  # signal/poster yellow
      cream  = "#E8DFC8",  # cream ground (evocative; low contrast on white)
      blue   = "#1565C0"   # deep propaganda blue
    ),
    type = "qualitative"
  ),

  gost_signal = structure(
    c(
      danger    = "#D32F2F",  # red    -- immediate danger, prohibition
      caution   = "#FDD835",  # yellow -- warning, hazard indication
      safe      = "#388E3C",  # green  -- safe condition, evacuation routes
      mandatory = "#1565C0"   # blue   -- mandatory action, PPE required
    ),
    type = "qualitative"
  ),

  # --- Sequential (archival) -------------------------------------------------

  # 7K, 4BO, and 6K are documented Soviet camouflage paint standards.
  steppe = structure(
    c(
      "#C9A96E",  # Yellow Earth 7K camouflage
      "#51653F",  # 4BO Protective Green
      "#3D2B1F"   # Dark Brown 6K camouflage
    ),
    type = "sequential"
  ),

  # --- Diverging (archival) --------------------------------------------------

  # Stops sourced from gost14202: water green (safe), pipe grey (neutral),
  # fire red (danger).
  hazard = structure(
    c(
      "#2E7D32",  # gost14202 water green (safe)
      "#78909C",  # gost14202 pipe grey (neutral)
      "#C62828"   # gost14202 fire red (danger)
    ),
    type = "diverging"
  ),

  # --- Qualitative (viz-optimized) -------------------------------------------

  # Lines-safe subset of gost14202: drops gas (#F9A825 yellow) and fuel
  # (#5D4037 brown). Both hex values are exactly as defined in gost14202.
  gost14202_lines = structure(
    c(
      water  = "#2E7D32",
      fire   = "#C62828",
      air    = "#5B8DB8",
      toxic  = "#E64A19",
      alkali = "#8E6EAF",
      other  = "#78909C"
    ),
    type = "qualitative"
  ),

  # constructivist without the low-contrast cream ground. All hex values are
  # exactly as defined in constructivist.
  constructivist_core = structure(
    c(
      red    = "#CD2500",
      black  = "#1A1A1A",
      yellow = "#F9A825",
      blue   = "#1565C0"
    ),
    type = "qualitative"
  ),

  # --- Diverging (viz-optimized) ---------------------------------------------

  # Colorblind-safe alternative to `hazard`. Blue-grey-red is distinguishable
  # under deuteranopia/protanopia where green-red is not. Every stop is a
  # canonical sovpal hex: blue from gost_signal `mandatory` / constructivist
  # `blue`, grey from gost14202 `other`, red from gost14202 `fire`.
  hazard_cvd = structure(
    c(
      "#1565C0",  # blue  (safe / low)
      "#78909C",  # grey  (neutral)
      "#C62828"   # red   (danger / high)
    ),
    type = "diverging"
  )
)


# Generic per-palette metadata. Plain-text only; does not alter any hex value.
# Exposed via palette_info() and show_palette(). Accessibility is NOT encoded
# by hand here -- contrast against white is computed from the hex values by
# .sovpal_contrast_on_white(). This list carries only judgments that cannot be
# derived: provenance, tier, intended use, and colorblindness caveats.

.sovpal_meta <- list(
  gost14202 = list(
    tier            = "archival",
    evocative       = FALSE,
    source          = "GOST 14202-69 industrial pipeline paint card index.",
    recommended_use = NULL,
    cvd_note        = NULL,
    derived_from    = NULL,
    white_note      = paste0(
      "8 colors at the upper edge of qualitative distinctness. For points and ",
      "lines on a white background, use the `gost14202_lines` palette (drops ",
      "the light yellow `gas` and dark `fuel` stops)."
    )
  ),
  soviet_military = list(
    tier            = "archival",
    evocative       = FALSE,
    source          = "Vallejo 70.609, AK Real Colors RC206, FS equivalents.",
    recommended_use = NULL,
    cvd_note        = NULL,
    derived_from    = NULL,
    white_note      = "Full palette is adequate on white backgrounds."
  ),
  constructivist = list(
    tier            = "archival",
    evocative       = TRUE,
    source          = "Evocative of Soviet Constructivist poster design; not standards-derived.",
    recommended_use = NULL,
    cvd_note        = NULL,
    derived_from    = NULL,
    white_note      = paste0(
      "The cream stop (#E8DFC8) is near-invisible on white. Use the ",
      "`constructivist_core` palette for a 4-color white-safe version."
    )
  ),
  gost_signal = list(
    tier            = "archival",
    evocative       = FALSE,
    source          = "GOST 12.4.026 mandatory workplace safety signal colors.",
    recommended_use = NULL,
    cvd_note        = NULL,
    derived_from    = NULL,
    white_note      = "The light `caution` yellow reads best as a fill rather than a thin line."
  ),
  steppe = list(
    tier            = "archival",
    evocative       = FALSE,
    source          = "Soviet camouflage paint standards 7K / 4BO / 6K.",
    recommended_use = paste0(
      "Themed ramp. Note: lightness is not monotonic (sand is light, green ",
      "mid, brown dark, with a hue swing), so it encodes magnitude less ",
      "cleanly than a perceptually uniform sequential scale."
    ),
    cvd_note        = NULL,
    derived_from    = NULL,
    white_note      = "All stops are adequate on white backgrounds."
  ),
  hazard = list(
    tier            = "archival",
    evocative       = FALSE,
    source          = "GOST 14202-69 green, grey, red.",
    recommended_use = paste0(
      "Diverging safe-to-danger scale for risk scores, hazard ratios, and ",
      "survival data: green (safe/low) to grey (neutral) to red (danger/high)."
    ),
    cvd_note        = paste0(
      "Green-red diverging scales are hard to read under red-green color ",
      "vision deficiency (~8% of men). For audiences where this matters, ",
      "use the `hazard_cvd` palette instead."
    ),
    derived_from    = NULL,
    white_note      = "All stops are adequate on white backgrounds."
  ),
  gost14202_lines = list(
    tier            = "viz",
    evocative       = FALSE,
    source          = "Subset of gost14202 (GOST 14202-69); no hex values altered.",
    recommended_use = "Lines/points on white backgrounds. Six maximally distinct gost14202 stops.",
    cvd_note        = NULL,
    derived_from    = "gost14202",
    white_note      = "All stops are adequate for points and lines on white."
  ),
  constructivist_core = list(
    tier            = "viz",
    evocative       = TRUE,
    source          = "Subset of constructivist; no hex values altered.",
    recommended_use = "White-safe Constructivist palette (cream ground removed).",
    cvd_note        = NULL,
    derived_from    = "constructivist",
    white_note      = "All stops are adequate on white backgrounds."
  ),
  hazard_cvd = list(
    tier            = "viz",
    evocative       = FALSE,
    source          = "Canonical sovpal hexes recombined (gost_signal blue, gost14202 grey + red).",
    recommended_use = paste0(
      "Colorblind-safe diverging safe-to-danger scale: blue (safe/low) to ",
      "grey (neutral) to red (danger/high). Use in place of `hazard` when ",
      "red-green color vision deficiency is a concern."
    ),
    cvd_note        = "Distinguishable under deuteranopia and protanopia.",
    derived_from    = "hazard",
    white_note      = "All stops are adequate on white backgrounds."
  )
)


# Relative luminance of an sRGB hex color, per WCAG 2.x.
# Returns a numeric in [0, 1].
.sovpal_luminance <- function(hex) {
  rgb  <- grDevices::col2rgb(hex)[, 1] / 255
  lin  <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * lin)
}

# WCAG contrast ratio of each hex color against a white background.
# Ranges from 1 (identical to white) to 21 (black on white). The WCAG 2.1
# minimum for non-text graphical objects (lines, markers) is 3:1.
.sovpal_contrast_on_white <- function(hex) {
  vapply(
    hex,
    function(h) {
      l <- .sovpal_luminance(h)
      (1 + 0.05) / (l + 0.05)
    },
    numeric(1)
  )
}
