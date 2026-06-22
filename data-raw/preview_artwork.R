# Preview: each artwork scan next to its curated, sampled palette.
# Used to validate color curation and to prototype the vignette presentation.
# Run: Rscript data-raw/preview_artwork.R  ->  /tmp/sov_art.png

library(jpeg)

pals <- list(
  lissitzky = c("#EEEDDB", "#D84F24", "#131312", "#8E9396"),
  popova    = c("#BF3E08", "#2F4672", "#455238", "#CC8F58", "#1E2227"),
  stepanova = c("#1C1B1C", "#4E5753", "#772821", "#B9882A", "#C5C7B8"),
  malevich  = c("#161B49", "#B9592F", "#CEA829", "#5D8169", "#BB9E99")
)
imgs <- c(
  lissitzky = "data-raw/artwork/lissitzky.jpg",
  popova    = "data-raw/artwork/popova.jpg",
  stepanova = "data-raw/artwork/stepanova.jpg",
  malevich  = "data-raw/artwork/malevich.jpg"
)

lum <- function(hex) {
  rgb <- col2rgb(hex) / 255
  colSums(c(0.2126, 0.7152, 0.0722) * rgb)
}

png("/tmp/sov_art.png", width = 1000, height = 1100, res = 120)
layout(matrix(seq_len(8), ncol = 2, byrow = TRUE), widths = c(1, 1.4))
par(mar = c(0.6, 1, 2, 1))

for (nm in names(pals)) {
  im <- readJPEG(imgs[[nm]])
  asp <- dim(im)[1] / dim(im)[2]
  plot.new(); plot.window(xlim = c(0, 1), ylim = c(0, 1))
  rasterImage(im, 0, 0, 1, 1)
  title(nm, font.main = 2)

  cols <- pals[[nm]]; n <- length(cols)
  plot.new(); plot.window(xlim = c(0, n), ylim = c(0, 1))
  rect(0:(n - 1), 0, 1:n, 1, col = cols, border = "grey25", lwd = 1.5)
  text((0:(n - 1)) + 0.5, 0.5, cols, srt = 90, cex = 0.85,
       col = ifelse(lum(cols) > 0.5, "grey10", "white"))
}
dev.off()
cat("wrote /tmp/sov_art.png\n")
