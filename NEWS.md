# sovpal 0.3.0

Reorganizes the package around thematic **domains** and introduces
artwork-derived palettes. Breaking changes (still lifecycle-experimental).

## Taxonomy

* Palettes are now grouped by **domain** (`industrial`, `military`, `artistic`,
  `composite`) instead of the previous archival/visualization-optimized tier.
  `palette_info()` gains `domain` and drops `tier`, `evocative`, and
  `derived_from`; `sovpal_palettes()` gains a `domain` column; and
  `show_all_palettes()` takes a `domain` filter (was `tier`).

## New: artistic palettes (MetBrewer-style)

* `lissitzky`, `popova`, `stepanova`, and `malevich` are color-sampled from
  specific Constructivist/Suprematist works and named for the artist. Hex values
  are approximate (sampled from reproductions; see `data-raw/sample_artwork.R`).
* The vignette presents each public-domain work as a scan beside its palette.
  Stepanova's image is not bundled (still under EU copyright until 2029); her
  palette is shown as swatches with a link.

## Removed

* `constructivist` and `constructivist_core` (superseded by the artwork
  palettes) and `gost14202_lines` (the single low-contrast `gas` yellow is now
  just reported by `palette_info()`, not split into a separate palette).

## Composite diverging palettes

* `hazard` (archival GOST green/grey/red), `hazard_warm` (green/cream/red), and
  `hazard_cvd` (blue/cream/red, colorblind-safe) are now grouped as the
  `composite` domain. Their cream midpoint is a defined light neutral.

---

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
  * `gost14202_lines` — `gost14202` with only the low-contrast `gas` yellow
    removed, for thin lines and small points on white (7 colors).
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
