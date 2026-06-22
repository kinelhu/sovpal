# --- core sovpal() behavior --------------------------------------------------

test_that("sovpal('gost14202') returns named character vector of length 8", {
  result <- sovpal("gost14202")
  expect_type(result, "character")
  expect_length(result, 8)
  expect_false(is.null(names(result)))
})

test_that("sovpal('gost14202', n = 3) returns length 3", {
  expect_length(sovpal("gost14202", n = 3), 3)
})

test_that("sovpal continuous interpolation returns correct length", {
  expect_length(sovpal("steppe", n = 20, type = "continuous"), 20)
})

test_that("sovpal direction = -1 returns reversed palette", {
  fwd <- sovpal("gost14202")
  expect_equal(rev(fwd), sovpal("gost14202", direction = -1))
})

test_that("sovpal is case-insensitive", {
  expect_equal(sovpal("MALEVICH"), sovpal("malevich"))
})

test_that("sovpal throws informative error for nonexistent palette", {
  expect_error(sovpal("nonexistent"), regexp = "not a valid palette name")
  expect_error(sovpal("nonexistent"), regexp = "gost14202")
})

test_that("sovpal throws error for discrete with n > available colors", {
  expect_error(sovpal("gost14202", n = 20, type = "discrete"), regexp = "discrete")
})

test_that("named vectors support base-R subsetting", {
  pal <- sovpal("gost14202")
  expect_equal(unname(pal[c("water", "fire")]), c("#2E7D32", "#C62828"))
  expect_length(sovpal("steppe")[2:3], 2)
})


# --- artwork (artistic domain) palettes --------------------------------------

test_that("artwork palettes exist with expected stops", {
  expect_length(sovpal("lissitzky"), 4)
  expect_length(sovpal("popova"),    5)
  expect_length(sovpal("stepanova"), 5)
  expect_length(sovpal("malevich"),  5)
})

test_that("malevich includes the dusty rose and drops the near-white ground", {
  m <- sovpal("malevich")
  expect_true("#BB9E99" %in% m)                          # the pink plane
  expect_false(any(sovpal:::.sovpal_contrast_on_white(m) < 1.3))  # no near-white
})

test_that("all artwork palettes are in the artistic domain", {
  for (nm in c("lissitzky", "popova", "stepanova", "malevich")) {
    expect_equal(palette_info(nm)$domain, "artistic", info = nm)
  }
})

test_that("removed palettes throw informative errors", {
  for (nm in c("constructivist", "constructivist_core", "gost14202_lines",
               "rodchenko", "pripyat", "moscow_metro")) {
    expect_error(sovpal(nm), regexp = "not a valid palette name", info = nm)
  }
})


# --- contrast helper (derived accessibility) ---------------------------------

test_that("contrast-on-white flags light colors and not dark ones", {
  cw <- sovpal:::.sovpal_contrast_on_white
  expect_lt(cw("#FFFFFF"), 1.05)
  expect_gt(cw("#000000"), 20)
  expect_lt(cw("#F9A825"), 3)            # signal yellow is low-contrast
})

test_that("palette_info flags the gost14202 gas yellow as low-contrast", {
  info <- palette_info("gost14202")
  expect_true("gas" %in% info$low_contrast_on_white)
  expect_false("fire" %in% info$low_contrast_on_white)
})


# --- palette_info() is generic, domain-based ---------------------------------

test_that("palette_info returns the generic field set for every palette", {
  required <- c("name", "domain", "type", "n_colors", "color_names",
                "hex_values", "source", "recommended_use", "cvd_note",
                "contrast_white", "low_contrast_on_white", "white_note")
  removed  <- c("tier", "evocative", "derived_from", "medical_use")
  for (nm in sovpal_palettes()$palette) {
    info <- palette_info(nm)
    expect_true(all(required %in% names(info)), info = nm)
    expect_false(any(removed %in% names(info)), info = nm)
    expect_length(info$contrast_white, info$n_colors)
  }
})

test_that("domains are assigned correctly", {
  expect_equal(palette_info("gost14202")$domain,       "industrial")
  expect_equal(palette_info("soviet_military")$domain, "military")
  expect_equal(palette_info("steppe")$domain,          "military")
  expect_equal(palette_info("hazard")$domain,          "composite")
})

test_that("hazard carries a CVD caveat and points at hazard_cvd", {
  info <- palette_info("hazard")
  expect_true(grepl("color vision", info$cvd_note))
  expect_true(grepl("hazard_cvd", info$cvd_note))
})


# --- discovery ---------------------------------------------------------------

test_that("sovpal_palettes() enumerates every palette with domain + type", {
  tab <- sovpal_palettes()
  expect_setequal(tab$palette, names(sovpal:::.sovpal_palettes))
  expect_true(all(tab$domain %in% c("industrial", "military", "artistic", "composite")))
  expect_true(all(tab$type   %in% c("qualitative", "sequential", "diverging")))
  expect_true("domain" %in% names(tab))
  expect_false("tier" %in% names(tab))
})


# --- diverging composites ----------------------------------------------------

test_that("diverging viz composites use the light cream midpoint", {
  expect_equal(unname(sovpal("hazard_cvd")[2]),  "#E8DFC8")
  expect_equal(unname(sovpal("hazard_warm")[2]), "#E8DFC8")
  expect_equal(unname(sovpal("hazard")[2]),      "#78909C")  # archival, untouched
})


# --- sequential palettes -----------------------------------------------------

test_that("rust, steel, field, cobalt exist as 5-stop sequential ramps", {
  for (nm in c("rust", "steel", "field", "cobalt")) {
    expect_equal(palette_info(nm)$type, "sequential", info = nm)
    expect_length(sovpal(nm), 5)
  }
})

test_that("constructed sequential palettes have monotonic lightness", {
  seqs <- sovpal_palettes()$palette[sovpal_palettes()$type == "sequential"]
  for (nm in setdiff(seqs, "steppe")) {  # steppe is intentionally non-monotonic
    L <- vapply(as.character(sovpal(nm)), sovpal:::.sovpal_luminance, numeric(1))
    expect_true(all(diff(L) < 0), info = nm)
  }
})


# --- data integrity ----------------------------------------------------------

test_that("all hex codes match valid hex format", {
  all_hex <- unlist(lapply(sovpal:::.sovpal_palettes, as.character))
  expect_true(all(grepl("^#[0-9A-Fa-f]{6}$", all_hex)))
})

test_that("every palette has a metadata entry and vice versa", {
  expect_setequal(names(sovpal:::.sovpal_meta), names(sovpal:::.sovpal_palettes))
})


# --- ggplot2 scales: no hidden subsetting ------------------------------------

test_that("scale_color_sovpal uses the full named palette", {
  skip_if_not_installed("ggplot2")
  sc <- scale_color_sovpal("gost14202")
  expect_equal(sc$palette(8), unname(sovpal("gost14202")))
})

test_that("scale_fill_sovpal works with an artwork palette", {
  skip_if_not_installed("ggplot2")
  sc <- scale_fill_sovpal("popova")
  expect_equal(sc$palette(5), unname(sovpal("popova")))
})
