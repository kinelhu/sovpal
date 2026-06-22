# sovpal

**Soviet and Industrial Color Palettes for R**

Color palettes drawn from the Soviet world: GOST industrial standards, military
paint specifications, and the palettes of avant-garde artworks. Each palette has
a thematic **domain** and a functional **type**.

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

# A GOST industrial palette (named vector)
sovpal("gost14202")

# Select colors by name with base-R indexing
sovpal("gost14202")[c("water", "fire", "air")]

# An artwork-derived palette
sovpal("malevich")

# Colorblind-safe diverging scale
sovpal("hazard_cvd")

# Inspect: domain, provenance, intended use, computed white-bg contrast
palette_info("lissitzky")

# Enumerate everything (name, domain, type, n)
sovpal_palettes()

# ggplot2 integration
library(ggplot2)
ggplot(mtcars, aes(factor(cyl), fill = factor(cyl))) +
  geom_bar() +
  scale_fill_sovpal("gost14202")
```

---

## Domains

| Domain | Palettes |
|---|---|
| **industrial** | `gost14202` (8, qual), `gost_signal` (4, qual) |
| **military** | `soviet_military` (6, qual), `steppe` (3, sequential) |
| **artistic** | `lissitzky` (4), `popova` (5), `stepanova` (5), `malevich` (5) — all qual |
| **composite** | `hazard`, `hazard_warm`, `hazard_cvd` (3 each, diverging) |

The **artistic** palettes are color-sampled from specific avant-garde works and
named for the artist (cf. [MetBrewer](https://github.com/BlakeRMills/MetBrewer)).
The **composite** palettes are functional diverging scales assembled from the
others — `hazard` is the faithful GOST green/grey/red; `hazard_warm`
(green/cream/red) is the most legible; `hazard_cvd` (blue/cream/red) is
colorblind-safe.

To subset or slice, index the returned named vector:
`sovpal("gost14202")[c("water", "fire")]` or `sovpal("steppe")[2:3]`.

---

## Accessibility

* **White-background contrast is computed, not hand-curated.** `palette_info()`
  reports each color's WCAG contrast ratio against white and flags any below the
  3:1 non-text threshold (`low_contrast_on_white`).
* **`hazard` is green↔red** and hard to read under red-green color vision
  deficiency. Use `hazard_cvd` (blue↔red) for those audiences.

---

## Palette Reference

```
gost14202:        #2E7D32  #C62828  #5B8DB8  #F9A825  #E64A19  #8E6EAF  #5D4037  #78909C
gost_signal:      #D32F2F  #FDD835  #388E3C  #1565C0
soviet_military:  #51653F  #5B8F8C  #C45830  #CD2500  #3D2B1F  #C9A96E
steppe:           #C9A96E  #51653F  #3D2B1F
lissitzky:        #EEEDDB  #D84F24  #131312  #8E9396
popova:           #BF3E08  #2F4672  #455238  #CC8F58  #1E2227
stepanova:        #1C1B1C  #4E5753  #772821  #B9882A  #C5C7B8
malevich:         #161B49  #B9592F  #CEA829  #5D8169  #BB9E99
hazard:           #2E7D32  #78909C  #C62828
hazard_warm:      #2E7D32  #E8DFC8  #C62828
hazard_cvd:       #1565C0  #E8DFC8  #C62828
```

The artistic palettes are approximate, sampled from reproductions of works by
El Lissitzky, Liubov Popova, Varvara Stepanova, and Kazimir Malevich. The
sampling script is `data-raw/sample_artwork.R`.

---

## Interoperability

sovpal works with base R (`sovpal()` returns a plain named vector) and ggplot2
(`scale_color_sovpal()` / `scale_fill_sovpal()`). It is also structured for
ingestion into [paletteer](https://github.com/EmilHvitfeldt/paletteer) — see
[`PALETTEER.md`](PALETTEER.md). `sovpal_palettes()` enumerates every palette.

---

## Acknowledgments

GOST and military color values are sourced from the scale modeling community
(Vallejo Model Color, AK Interactive Real Colors), Tank Archives, KSM-IPMS, and
the original GOST standards. Artistic-palette colors are sampled from
public-domain reproductions on Wikimedia Commons and the Museo
Thyssen-Bornemisza.
