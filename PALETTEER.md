# Registering sovpal with paletteer

[paletteer](https://github.com/EmilHvitfeldt/paletteer) is the de-facto
aggregator for R color palettes. Registering sovpal there lets users reach
every palette through a uniform interface they already know:

```r
paletteer::paletteer_d("sovpal::malevich")
paletteer::paletteer_c("sovpal::hazard_cvd", n = 50)
ggplot2::... + paletteer::scale_color_paletteer_d("sovpal::malevich")
```

sovpal is structured to make ingestion mechanical:

* `sovpal_palettes()` enumerates every palette (name, type, tier, n_colors).
* `sovpal(name)` returns the canonical hex vector for any palette.
* Qualitative palettes map to paletteer's **discrete** table; sequential and
  diverging palettes map to its **continuous** table.

## Steps (one-time, performed upstream)

Registration is a pull request against the paletteer repository -- it cannot be
done from within this package. The process:

1. Run `Rscript data-raw/paletteer.R` to regenerate
   `data-raw/paletteer/sovpal_palettes_d.csv` (discrete) and
   `sovpal_palettes_c.csv` (continuous).
2. Fork `EmilHvitfeldt/paletteer`, add `sovpal` to its `DESCRIPTION` Suggests
   and to the package list in `data-raw/`, following an existing entry
   (e.g. `nord` or `MetBrewer`) as a template.
3. Rebuild paletteer's internal data and open the PR.

Until the PR is merged, the native `scale_color_sovpal()` / `scale_fill_sovpal()`
scales provide full ggplot2 support, and `sovpal()` covers base R.
