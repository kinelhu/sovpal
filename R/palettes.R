# Internal palette data. Each palette belongs to a thematic `domain` and has a
# functional `type`. The two axes are independent (e.g. `steppe` is military +
# sequential, `soviet_military` is military + qualitative).
#
# Domains:
#   * industrial -- GOST civil/industrial standards (faithful to the documents).
#   * military   -- Soviet military paint and camouflage references.
#   * artistic   -- avant-garde palettes sampled from specific artworks, named
#                   for the artist (cf. MetBrewer). Hex values are approximate,
#                   sampled from reproductions, not official.
#   * composite  -- functional scales assembled from colors in the other
#                   palettes (the diverging hazard family).

.sovpal_palettes <- list(

  # === industrial ============================================================

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

  gost_signal = structure(
    c(
      danger    = "#D32F2F",  # red    -- immediate danger, prohibition
      caution   = "#FDD835",  # yellow -- warning, hazard indication
      safe      = "#388E3C",  # green  -- safe condition, evacuation routes
      mandatory = "#1565C0"   # blue   -- mandatory action, PPE required
    ),
    type = "qualitative"
  ),

  # Constructed sequential ramps with monotonic lightness, anchored on canonical
  # industrial colors. rust = oxidation/decay (anchor primer #C45830);
  # steel = pipe grey (anchor gost14202 `other` #78909C).
  rust = structure(
    c("#F4ECDD", "#E0A66B", "#C45830", "#8A3415", "#4A1E0E"),
    type = "sequential"
  ),

  steel = structure(
    c("#ECEFF1", "#AEB8BE", "#78909C", "#45565F", "#1F2A30"),
    type = "sequential"
  ),

  # Constructed sequential ramp (monotonic lightness) anchored on gost14202
  # `air` compressed-air blue #5B8DB8.
  cobalt = structure(
    c("#E6EEF4", "#9FC0D8", "#5B8DB8", "#2E5A86", "#15293F"),
    type = "sequential"
  ),

  # === military ==============================================================

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

  # 7K, 4BO, and 6K are documented Soviet camouflage paint standards.
  steppe = structure(
    c(
      "#C9A96E",  # Yellow Earth 7K camouflage
      "#51653F",  # 4BO Protective Green
      "#3D2B1F"   # Dark Brown 6K camouflage
    ),
    type = "sequential"
  ),

  # Constructed sequential ramp with monotonic lightness, anchored on 4BO
  # Protective Green (#51653F). Unlike steppe, this is suitable for encoding
  # magnitude on a continuous scale.
  field = structure(
    c("#E4DCBE", "#9AA36B", "#51653F", "#33402A", "#161D12"),
    type = "sequential"
  ),

  # === artistic ==============================================================
  # Hex values sampled (k-means) from reproductions of specific works, then
  # curated. Approximate -- see data-raw/sample_artwork.R.

  # El Lissitzky, "Beat the Whites with the Red Wedge" (1919).
  lissitzky = structure(
    c(
      ground = "#EEEDDB",  # off-white paper field
      red    = "#D84F24",  # the red wedge
      black  = "#131312",  # black field / lettering
      steel  = "#8E9396"   # blue-grey geometric elements
    ),
    type = "qualitative"
  ),

  # Liubov Popova, "Architectonic Painting" (1917).
  popova = structure(
    c(
      red   = "#BF3E08",  # orange-red plane
      blue  = "#2F4672",  # blue plane
      green = "#455238",  # green plane
      ochre = "#CC8F58",  # ochre / tan plane
      black = "#1E2227"   # near-black plane
    ),
    type = "qualitative"
  ),

  # Varvara Stepanova, "Billiard Players" (1920).
  stepanova = structure(
    c(
      charcoal = "#1C1B1C",  # dark ground
      slate    = "#4E5753",  # cool grey-green
      brick    = "#772821",  # brick-red accent
      gold     = "#B9882A",  # ochre / gold
      khaki    = "#C5C7B8"   # light khaki
    ),
    type = "qualitative"
  ),

  # Kazimir Malevich, "Suprematist Composition" (1916).
  malevich = structure(
    c(
      navy  = "#161B49",  # deep blue plane
      red   = "#B9592F",  # red beam (burnt)
      gold  = "#CEA829",  # yellow / gold element
      green = "#5D8169",  # green element
      rose  = "#BB9E99"   # dusty rose plane
    ),
    type = "qualitative"
  ),

  # === composite =============================================================
  # Functional scales assembled from colors in the palettes above.

  # Diverging safe->danger from gost14202: water green, pipe grey, fire red.
  hazard = structure(
    c(
      "#2E7D32",  # gost14202 water green (safe)
      "#78909C",  # gost14202 pipe grey (neutral)
      "#C62828"   # gost14202 fire red (danger)
    ),
    type = "diverging"
  ),

  # Warm diverging palette with a light cream midpoint. Green and red from
  # gost14202; the cream is a defined light neutral used as the diverging
  # zero-point. Green-red ends are not colorblind-safe; see hazard_cvd.
  hazard_warm = structure(
    c(
      "#2E7D32",  # green (safe / low)
      "#E8DFC8",  # cream (neutral, functional zero-point)
      "#C62828"   # red   (danger / high)
    ),
    type = "diverging"
  ),

  # Colorblind-safe diverging: blue-cream-red is distinguishable under
  # deuteranopia/protanopia. blue from gost_signal, red from gost14202; cream is
  # the defined light neutral midpoint.
  hazard_cvd = structure(
    c(
      "#1565C0",  # blue  (safe / low)
      "#E8DFC8",  # cream (neutral, functional zero-point)
      "#C62828"   # red   (danger / high)
    ),
    type = "diverging"
  )
)


# Generic per-palette metadata. Plain-text only; does not alter any hex value.
# Accessibility is NOT encoded here -- contrast against white is computed from
# the hex values by .sovpal_contrast_on_white(). This list carries only
# judgments that cannot be derived: domain, provenance, intended use, and
# colorblindness caveats.

.sovpal_meta <- list(
  gost14202 = list(
    domain          = "industrial",
    source          = "GOST 14202-69 industrial pipeline paint card index.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = paste0(
      "8 colors at the upper edge of qualitative distinctness. Only the light ",
      "`gas` yellow falls below the 3:1 contrast threshold on white."
    )
  ),
  gost_signal = list(
    domain          = "industrial",
    source          = "GOST 12.4.026 mandatory workplace safety signal colors.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = "The light `caution` yellow reads best as a fill rather than a thin line."
  ),
  rust = list(
    domain          = "industrial",
    source          = "Constructed sequential ramp (monotonic lightness) evoking iron oxidation; anchored on primer #C45830.",
    recommended_use = "Sequential scale for continuous magnitude; warm.",
    cvd_note        = NULL,
    white_note      = "The pale low end is light on white, as expected for a sequential ramp."
  ),
  steel = list(
    domain          = "industrial",
    source          = "Constructed sequential ramp (monotonic lightness) evoking steel; anchored on gost14202 pipe grey #78909C.",
    recommended_use = "Sequential scale for continuous magnitude; cool/neutral.",
    cvd_note        = NULL,
    white_note      = "The pale low end is light on white, as expected for a sequential ramp."
  ),
  cobalt = list(
    domain          = "industrial",
    source          = "Constructed sequential ramp (monotonic lightness) anchored on gost14202 compressed-air blue #5B8DB8.",
    recommended_use = "Sequential scale for continuous magnitude; blue.",
    cvd_note        = NULL,
    white_note      = "The pale low end is light on white, as expected for a sequential ramp."
  ),
  soviet_military = list(
    domain          = "military",
    source          = "Vallejo 70.609, AK Real Colors RC206, FS equivalents.",
    recommended_use = paste0(
      "Earth-toned camouflage set. `primer` sits close to `soviet_red`; drop ",
      "it with sovpal('soviet_military')[-3] for a more distinct qualitative ",
      "palette with a single clean red."
    ),
    cvd_note        = NULL,
    white_note      = "Full palette is adequate on white backgrounds."
  ),
  steppe = list(
    domain          = "military",
    source          = "Soviet camouflage paint standards 7K / 4BO / 6K.",
    recommended_use = paste0(
      "Themed terrain ramp. Lightness is not strictly monotonic (sand light, ",
      "green mid, brown dark, with a hue swing), so it reads as terrain more ",
      "than as a strict magnitude scale."
    ),
    cvd_note        = NULL,
    white_note      = "All stops are adequate on white backgrounds."
  ),
  field = list(
    domain          = "military",
    source          = "Constructed sequential ramp (monotonic lightness) anchored on 4BO Protective Green #51653F.",
    recommended_use = "Sequential scale for continuous magnitude; the monotonic green alternative to steppe.",
    cvd_note        = NULL,
    white_note      = "The pale low end is light on white, as expected for a sequential ramp."
  ),
  lissitzky = list(
    domain          = "artistic",
    source          = "Color-sampled from a reproduction of El Lissitzky, 'Beat the Whites with the Red Wedge' (1919). Approximate.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = "The off-white `ground` is the work's paper field; low-contrast on white."
  ),
  popova = list(
    domain          = "artistic",
    source          = "Color-sampled from a reproduction of Liubov Popova, 'Architectonic Painting' (1917). Approximate.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = "Layered painterly planes; all stops read on white."
  ),
  stepanova = list(
    domain          = "artistic",
    source          = "Color-sampled from a reproduction of Varvara Stepanova, 'Billiard Players' (1920). Approximate.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = "Muted cubo-futurist earth and stone tones; all stops read on white."
  ),
  malevich = list(
    domain          = "artistic",
    source          = "Color-sampled from a reproduction of Kazimir Malevich, 'Suprematist Composition' (1916). Approximate.",
    recommended_use = NULL,
    cvd_note        = NULL,
    white_note      = "All stops read on white; the dusty `rose` is the faintest."
  ),
  hazard = list(
    domain          = "composite",
    source          = "Assembled from gost14202 (green, grey, red).",
    recommended_use = paste0(
      "Diverging safe-to-danger scale for risk scores, hazard ratios, and ",
      "survival data: green (safe/low) to grey (neutral) to red (danger/high)."
    ),
    cvd_note        = paste0(
      "Green-red diverging scales are hard to read under red-green color ",
      "vision deficiency (~8% of men); use `hazard_cvd` for those audiences."
    ),
    white_note      = "All stops are adequate on white backgrounds."
  ),
  hazard_warm = list(
    domain          = "composite",
    source          = "Assembled from gost14202 (green, red) plus a defined light-cream neutral midpoint.",
    recommended_use = paste0(
      "Diverging safe-to-danger scale with a light cream midpoint: green ",
      "(safe/low) to cream (neutral) to red (danger/high). For use when ",
      "colorblind safety is not required."
    ),
    cvd_note        = paste0(
      "Green-red ends are hard to read under red-green color vision deficiency ",
      "(~8% of men). Use `hazard_cvd` for those audiences."
    ),
    white_note      = paste0(
      "The light cream midpoint reads as a zero-point in a gradient but is not ",
      "meant as a standalone discrete swatch."
    )
  ),
  hazard_cvd = list(
    domain          = "composite",
    source          = "Assembled from gost_signal (blue) and gost14202 (red) plus a defined light-cream neutral midpoint.",
    recommended_use = paste0(
      "Colorblind-safe diverging safe-to-danger scale: blue (safe/low) to ",
      "cream (neutral) to red (danger/high). Use in place of `hazard` when ",
      "red-green color vision deficiency is a concern."
    ),
    cvd_note        = "Distinguishable under deuteranopia and protanopia.",
    white_note      = paste0(
      "The light cream midpoint reads as a zero-point in a gradient but is not ",
      "meant as a standalone discrete swatch."
    )
  )
)


# Relative luminance of an sRGB hex color, per WCAG 2.x. Returns [0, 1].
.sovpal_luminance <- function(hex) {
  rgb  <- grDevices::col2rgb(hex)[, 1] / 255
  lin  <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * lin)
}

# WCAG contrast ratio of each hex color against a white background. Ranges from
# 1 (identical to white) to 21 (black on white). The WCAG 2.1 minimum for
# non-text graphical objects (lines, markers) is 3:1.
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
