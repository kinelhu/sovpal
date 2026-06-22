# Sample dominant colors from artwork reproductions for the `artistic` domain.
#
# Reads each image in data-raw/artwork/, subsamples pixels, and runs k-means in
# RGB to surface the dominant colors with their area proportions. The output is
# a CANDIDATE list -- curate by hand (drop background/near-duplicates, keep the
# 4-6 colors that define the work) before writing hex values into R/palettes.R.
#
# Source scans (not committed; re-fetch into data-raw/artwork/ with curl):
#   lissitzky https://commons.wikimedia.org/wiki/Special:FilePath/Klinom_Krasnym_Bej_Belych.JPG
#   popova    https://uploads7.wikiart.org/images/lyubov-popova/architectonic-painting.jpg!Large.jpg
#   malevich  https://commons.wikimedia.org/wiki/Special:FilePath/Kazimir_Malevich_-_%27Suprematist_Composition%27%2C_1916.jpg
#   stepanova https://www.museothyssen.org/sites/default/files/imagen/obras/CTB.1986.18_jugadores-billar.jpg
#
# Run from package root:  Rscript data-raw/sample_artwork.R

suppressWarnings(suppressMessages({
  stopifnot(requireNamespace("jpeg", quietly = TRUE))
}))

sample_image <- function(path, k = 8, max_px = 40000, seed = 1) {
  img <- jpeg::readJPEG(path)                    # H x W x 3, values in [0, 1]
  d   <- dim(img)
  px  <- matrix(img, ncol = 3)                   # (H*W) x 3
  # subsample for speed
  set.seed(seed)
  if (nrow(px) > max_px) px <- px[sample(nrow(px), max_px), , drop = FALSE]

  km  <- kmeans(px, centers = k, iter.max = 50, nstart = 3)
  ord <- order(km$size, decreasing = TRUE)
  hex <- grDevices::rgb(km$centers[ord, 1], km$centers[ord, 2], km$centers[ord, 3])
  prop <- round(km$size[ord] / sum(km$size), 3)
  data.frame(hex = hex, proportion = prop, stringsAsFactors = FALSE)
}

files <- list.files("data-raw/artwork", pattern = "\\.jpg$", full.names = TRUE)
for (f in files) {
  cat("\n==== ", basename(f), " ====\n", sep = "")
  print(sample_image(f, k = 8))
}
