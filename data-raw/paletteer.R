# Generates the data files needed to register sovpal with {paletteer}.
#
# paletteer ingests palettes from contributing packages by adding rows to its
# internal long-format tables (one row per color). This script emits those
# tables for sovpal in the conventional shape so the upstream PR is mechanical.
#
# Qualitative palettes -> discrete table (palettes_d).
# Sequential / diverging palettes -> continuous table (palettes_c).
#
# Run from the package root:  Rscript data-raw/paletteer.R
# See PALETTEER.md for the submission steps.

devtools::load_all(".")

meta <- sovpal_palettes()

rows <- function(palette) {
  cols <- as.character(sovpal(palette))
  data.frame(
    package = "sovpal",
    palette = palette,
    colour  = cols,
    order   = seq_along(cols),
    stringsAsFactors = FALSE
  )
}

discrete_names   <- meta$palette[meta$type == "qualitative"]
continuous_names <- meta$palette[meta$type %in% c("sequential", "diverging")]

palettes_d <- do.call(rbind, lapply(discrete_names,   rows))
palettes_c <- do.call(rbind, lapply(continuous_names, rows))

dir.create("data-raw/paletteer", showWarnings = FALSE)
write.csv(palettes_d, "data-raw/paletteer/sovpal_palettes_d.csv", row.names = FALSE)
write.csv(palettes_c, "data-raw/paletteer/sovpal_palettes_c.csv", row.names = FALSE)

message("Wrote ", nrow(palettes_d), " discrete and ", nrow(palettes_c),
        " continuous palette rows to data-raw/paletteer/.")
