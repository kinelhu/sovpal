# sovpal 0.2.0

This release simplifies the API, removes a footgun, and improves
interoperability and accessibility. It contains breaking changes (the package
is still lifecycle-experimental and pre-CRAN).

## Breaking changes

* `sovpal()` no longer takes `from`, `to`, or `subset`. These duplicated base-R
  indexing on the returned named vector. Use `sovpal("gost14202")[c("water",
  "fire")]` or `sovpal("steppe")[2:3]` instead.
* `scale_color_sovpal()` / `scale_fill_sovpal()` no longer take `auto_subset`,
  `from`, `to`, or `subset`. The previous `auto_subset = TRUE` default silently
  dropped colors and, with more groups than the subset had colors, silently
  interpolated non-canonical colors onto a discrete scale. Scales now use the
  named palette exactly as defined.

## New features

* **Visualization-optimized palettes** that reuse only canonical hex values:
  * `gost14202_lines` — white-background-safe 6-color subset of `gost14202`.
  * `constructivist_core` — `constructivist` without the low-contrast cream.
  * `hazard_cvd` — colorblind-safe (blue/cream/red) alternative to `hazard`.
  * `hazard_warm` — green/cream/red diverging scale; the most legible
    diverging option when colorblind safety is not required.
* The diverging viz palettes now use a light cream midpoint (`#E8DFC8`) instead
  of the muddy mid blue-grey, giving a proper light "zero" point. Archival
  `hazard` keeps its GOST green/grey/red.
* `sovpal_palettes()` enumerates every palette (name, type, tier, n_colors).
* `palette_info()` is now generic for all palettes (no more `hazard`
  special-case) and reports `tier`, `source`, `recommended_use`, `cvd_note`,
  `derived_from`, and computed `contrast_white` / `low_contrast_on_white`.
* White-background contrast is now **computed** from hex values via WCAG
  relative luminance rather than hand-maintained metadata.
* `show_palette()` / `show_all_palettes()` print usage notes from generic
  metadata; `show_all_palettes()` gains a `tier` filter.

## Accessibility

* `hazard` now documents its red-green color-vision-deficiency limitation and
  points to `hazard_cvd`.

## Interoperability

* Added `data-raw/paletteer.R` and `PALETTEER.md` describing registration with
  the paletteer aggregator.
