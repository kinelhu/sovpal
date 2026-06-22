# sovpal 0.3.0

Reorganises the package around thematic domains and adds artwork-derived and
sequential palettes. Contains breaking changes; the package is
lifecycle-experimental.

## Taxonomy

* Palettes are grouped by `domain` (`industrial`, `military`, `artistic`,
  `composite`) in place of the previous archival/visualization-optimized tier.
  `palette_info()` gains `domain` and drops `tier`, `evocative`, and
  `derived_from`. `sovpal_palettes()` gains a `domain` column.
  `show_all_palettes()` takes a `domain` argument in place of `tier`.

## Sequential ramps

* `rust`, `steel`, `cobalt`, and `field` are sequential palettes constructed for
  monotonic lightness (checked by a test against the WCAG luminance helper),
  anchored on canonical sovpal colors. `steppe` remains as a multi-hue,
  non-monotonic terrain ramp.

## Artistic palettes

* `lissitzky`, `popova`, `stepanova`, and `malevich` are color-sampled from
  specific Constructivist and Suprematist works and named for the artist. The
  hex values are approximate; see `data-raw/sample_artwork.R`.
* The vignette shows each public-domain work beside its palette. The Stepanova
  image is not bundled (under EU copyright until 2029); its palette is shown as
  swatches with a link to the source.

## Removed

* `constructivist`, `constructivist_core`, and `gost14202_lines`. The
  low-contrast `gas` yellow that `gost14202_lines` excluded is reported by
  `palette_info()` instead.

## Composite diverging palettes

* `hazard` (GOST green/grey/red), `hazard_warm` (green/cream/red), and
  `hazard_cvd` (blue/cream/red) form the `composite` domain. The cream midpoint
  is a defined light neutral.

---

# sovpal 0.2.0

Simplifies the API and moves white-background contrast reporting from
hand-maintained metadata to a computed value. Contains breaking changes;
pre-release.

## Breaking changes

* `sovpal()` no longer takes `from`, `to`, or `subset`; these duplicated base-R
  indexing on the returned named vector. Use `sovpal("gost14202")[c("water",
  "fire")]` or `sovpal("steppe")[2:3]`.
* `scale_color_sovpal()` and `scale_fill_sovpal()` no longer take `auto_subset`,
  `from`, `to`, or `subset`. The previous `auto_subset = TRUE` default dropped
  colors and could interpolate non-canonical colors onto a discrete scale. The
  scales now use the named palette as defined.

## Other changes

* `palette_info()` applies to all palettes uniformly and reports computed
  white-background contrast (`contrast_white`, `low_contrast_on_white`) derived
  from WCAG relative luminance.
* `hazard` documents its red-green color vision deficiency limitation.
* Added `data-raw/paletteer.R` and `PALETTEER.md` for paletteer registration.
