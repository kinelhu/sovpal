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
  expect_equal(sovpal("gost14202"), sovpal("GOST14202"))
})

test_that("sovpal throws informative error for nonexistent palette", {
  expect_error(sovpal("nonexistent"), regexp = "not a valid palette name")
  expect_error(sovpal("nonexistent"), regexp = "gost14202")
})

test_that("sovpal throws error for discrete with n > available colors", {
  expect_error(sovpal("gost14202", n = 20, type = "discrete"), regexp = "discrete")
})

test_that("named vectors support base-R subsetting (replacing the subset arg)", {
  pal <- sovpal("gost14202")
  expect_equal(unname(pal[c("water", "fire")]), c("#2E7D32", "#C62828"))
  expect_length(sovpal("steppe")[2:3], 2)
})


# --- visualization-optimized tier --------------------------------------------

test_that("viz palettes exist and reuse only canonical hex values", {
  # gost14202_lines is a strict subset of gost14202
  expect_true(all(sovpal("gost14202_lines") %in% sovpal("gost14202")))
  expect_length(sovpal("gost14202_lines"), 6)

  # constructivist_core drops cream only
  expect_true(all(sovpal("constructivist_core") %in% sovpal("constructivist")))
  expect_false("#E8DFC8" %in% sovpal("constructivist_core"))

  # diverging viz palettes introduce no new hex values vs archival palettes
  archival <- sovpal_palettes()$palette[sovpal_palettes()$tier == "archival"]
  archival_hex <- unlist(lapply(archival, function(nm) as.character(sovpal(nm))))
  expect_true(all(sovpal("hazard_cvd")  %in% archival_hex))
  expect_true(all(sovpal("hazard_warm") %in% archival_hex))
})

test_that("diverging viz palettes use the light cream midpoint", {
  expect_equal(unname(sovpal("hazard_cvd")[2]),  "#E8DFC8")
  expect_equal(unname(sovpal("hazard_warm")[2]), "#E8DFC8")
  # archival hazard is untouched (keeps the GOST blue-grey midpoint)
  expect_equal(unname(sovpal("hazard")[2]), "#78909C")
})

test_that("hazard_warm carries a red-green CVD caveat", {
  expect_true(grepl("color vision", palette_info("hazard_warm")$cvd_note))
  expect_true(grepl("hazard_cvd", palette_info("hazard_warm")$cvd_note))
})

test_that("removed palettes throw informative errors", {
  expect_error(sovpal("pripyat"),      regexp = "not a valid palette name")
  expect_error(sovpal("moscow_metro"), regexp = "not a valid palette name")
})


# --- contrast helper (derived accessibility) ---------------------------------

test_that("contrast-on-white flags light colors and not dark ones", {
  cw <- sovpal:::.sovpal_contrast_on_white
  expect_lt(cw("#FFFFFF"), 1.05)          # white on white ~ 1
  expect_gt(cw("#000000"), 20)            # black on white ~ 21
  expect_lt(cw("#E8DFC8"), 1.5)           # cream is near-invisible
  expect_lt(cw("#F9A825"), 3)             # signal yellow is low-contrast
})

test_that("palette_info flags cream as low-contrast on white", {
  info <- palette_info("constructivist")
  expect_true("cream" %in% info$low_contrast_on_white)
  expect_false("black" %in% info$low_contrast_on_white)
})


# --- palette_info() is generic (no hazard special-case) ----------------------

test_that("palette_info returns the generic field set for every palette", {
  required <- c("name", "type", "tier", "evocative", "n_colors", "color_names",
                "hex_values", "source", "recommended_use", "cvd_note",
                "derived_from", "contrast_white", "low_contrast_on_white",
                "white_note")
  for (nm in sovpal_palettes()$palette) {
    info <- palette_info(nm)
    expect_true(all(required %in% names(info)), info = nm)
    expect_false("medical_use" %in% names(info), info = nm)
    expect_length(info$contrast_white, info$n_colors)
  }
})

test_that("hazard carries a CVD caveat and points at hazard_cvd", {
  info <- palette_info("hazard")
  expect_true(grepl("color vision", info$cvd_note))
  expect_true(grepl("hazard_cvd", info$cvd_note))
})

test_that("tiers are labeled correctly", {
  expect_equal(palette_info("gost14202")$tier, "archival")
  expect_equal(palette_info("gost14202_lines")$tier, "viz")
  expect_equal(palette_info("gost14202_lines")$derived_from, "gost14202")
})


# --- discovery / paletteer-conformant accessor -------------------------------

test_that("sovpal_palettes() enumerates every palette with metadata", {
  tab <- sovpal_palettes()
  expect_setequal(tab$palette, names(sovpal:::.sovpal_palettes))
  expect_true(all(tab$tier %in% c("archival", "viz")))
  expect_true(all(tab$type %in% c("qualitative", "sequential", "diverging")))
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

test_that("scale_color_sovpal uses the full named palette (no auto-subset)", {
  skip_if_not_installed("ggplot2")
  sc <- scale_color_sovpal("gost14202")
  expect_equal(sc$palette(8), unname(sovpal("gost14202")))
})

test_that("scale_color_sovpal honors an explicit lines palette", {
  skip_if_not_installed("ggplot2")
  sc <- scale_color_sovpal("gost14202_lines")
  expect_equal(sc$palette(6), unname(sovpal("gost14202_lines")))
})

test_that("scale_fill_sovpal uses the full palette by default", {
  skip_if_not_installed("ggplot2")
  sc <- scale_fill_sovpal("gost14202")
  expect_equal(sc$palette(8), unname(sovpal("gost14202")))
})
