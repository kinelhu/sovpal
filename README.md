# sovpal

**Soviet and Industrial Color Palettes for R**

Color palettes derived from Soviet industrial standards and military paint
specifications. Standards-based palettes carry fixed hex values traceable to
specific documents. The `constructivist` palette is evocative rather than
standards-derived.

[![R CMD check](https://github.com/kinelhu/sovpal/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/kinelhu/sovpal/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

---

## Installation

```r
remotes::install_github("kinelhu/sovpal")
```

---

## Quick Start

```r
library(sovpal)

# Full 8-color GOST pipeline palette
sovpal("gost14202")

# Select colors by name with base-R indexing (no special argument needed)
sovpal("gost14202")[c("water", "fire", "air")]

# White-background-safe lines palette
sovpal("gost14202_lines")

# Colorblind-safe diverging scale
sovpal("hazard_cvd")

# Inspect a palette: provenance, intended use, computed white-bg contrast
palette_info("hazard")

# Enumerate everything (name, type, tier, n)
sovpal_palettes()

# ggplot2 integration
library(ggplot2)
ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  scale_fill_sovpal("gost14202")
```

---

## Two tiers

Every palette belongs to one of two tiers:

* **Archival** — faithful to a source document or reference. Hex values are
  never altered.
* **Visualization-optimized** (`_lines`, `_core`, `_cvd`) — selects or reorders
  colors that already appear in an archival palette for distinctness,
  white-background contrast, or colorblind safety. These introduce **no new hex
  values.**

This keeps the historical record intact while still giving you palettes that
work in real plots. To slice or subset further, just index the returned named
vector: `sovpal("gost14202")[c("water", "fire")]` or `sovpal("steppe")[2:3]`.

---

## Palettes

| Name | Type | N | Tier | Description | Source |
|---|---|---|---|---|---|
| `gost14202` | qualitative | 8 | archival | Industrial pipeline identification | GOST 14202-69 paint card index |
| `soviet_military` | qualitative | 6 | archival | WWII / Cold War vehicle & aircraft colors | Vallejo 70.609, AK Real Colors RC206, FS equivalents |
| `constructivist` | qualitative | 5 | archival* | Soviet Constructivist graphic design | Evocative; not standards-derived |
| `gost_signal` | qualitative | 4 | archival | Mandatory workplace safety signal colors | GOST 12.4.026 |
| `steppe` | sequential | 3 | archival | Soviet camouflage field terrain colors | 7K / 4BO / 6K paint standards |
| `hazard` | diverging | 3 | archival | Safe → danger (green/grey/red) | GOST 14202-69 |
| `gost14202_lines` | qualitative | 7 | viz | `gost14202` minus the low-contrast `gas` yellow (lines/points on white) | subset of GOST 14202-69 |
| `constructivist_core` | qualitative | 4 | viz | `constructivist` without the cream ground | subset of `constructivist` |
| `hazard_cvd` | diverging | 3 | viz | Colorblind-safe safe → danger (blue/cream/red) | canonical sovpal hexes |
| `hazard_warm` | diverging | 3 | viz | Safe → danger (green/cream/red); prettiest, **not** CVD-safe | canonical sovpal hexes |

\* `constructivist` is evocative, not standards-derived; `palette_info()` reports
`evocative = TRUE`.

---

## Accessibility

* **White-background contrast is computed, not hand-curated.** `palette_info()`
  reports each color's WCAG contrast ratio against white and flags any below the
  3:1 non-text threshold (`low_contrast_on_white`).
* **`hazard` is green↔red and therefore hard to read under red-green color
  vision deficiency** (~8% of men). For those audiences use `hazard_cvd`
  (blue↔red), which carries the same semantics with colorblind-safe hues.

---

## Palette Reference

```
gost14202:           #2E7D32  #C62828  #5B8DB8  #F9A825  #E64A19  #8E6EAF  #5D4037  #78909C
soviet_military:     #51653F  #5B8F8C  #C45830  #CD2500  #3D2B1F  #C9A96E
constructivist:      #CD2500  #1A1A1A  #F9A825  #E8DFC8  #1565C0
gost_signal:         #D32F2F  #FDD835  #388E3C  #1565C0
steppe:              #C9A96E  #51653F  #3D2B1F
hazard:              #2E7D32  #78909C  #C62828
gost14202_lines:     #2E7D32  #C62828  #5B8DB8  #E64A19  #8E6EAF  #5D4037  #78909C
constructivist_core: #CD2500  #1A1A1A  #F9A825  #1565C0
hazard_cvd:          #1565C0  #E8DFC8  #C62828
hazard_warm:         #2E7D32  #E8DFC8  #C62828
```

---

## Interoperability

sovpal works with base R (`sovpal()` returns a plain named vector) and ggplot2
(`scale_color_sovpal()` / `scale_fill_sovpal()`). It is also structured for
ingestion into [paletteer](https://github.com/EmilHvitfeldt/paletteer) — see
[`PALETTEER.md`](PALETTEER.md). `sovpal_palettes()` enumerates every palette for
programmatic discovery.

---

## Acknowledgments

Color values sourced from the scale modeling community (Vallejo Model Color,
AK Interactive Real Colors), Tank Archives, KSM-IPMS, and the original GOST
standards documents.
