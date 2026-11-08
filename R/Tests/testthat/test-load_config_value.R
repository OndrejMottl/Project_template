#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("load_config_value() validates `value`", {
  path_config <-
    withr::local_tempfile(fileext = ".yml")

  base::writeLines(
    text = c("default:", "  seed: 42"),
    con = path_config
  )

  testthat::expect_error(
    load_config_value(value = 1, file = path_config),
    regexp = "value"
  )

  testthat::expect_error(
    load_config_value(value = base::character(0), file = path_config),
    regexp = "value"
  )

  testthat::expect_error(
    load_config_value(value = NA_character_, file = path_config),
    regexp = "value"
  )
})

testthat::test_that("load_config_value() requires a readable YAML file", {
  testthat::expect_error(
    load_config_value(
      value = "seed",
      file = base::file.path(base::tempdir(), "missing_config.yml")
    ),
    regexp = "file"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("load_config_value() reads scalar and nested values", {
  path_config <-
    withr::local_tempfile(fileext = ".yml")

  base::writeLines(
    text = c(
      "default:",
      "  seed: 42",
      "  graphical:",
      "    width: 16",
      "    units: cm"
    ),
    con = path_config
  )

  withr::local_envvar(R_CONFIG_ACTIVE = "default")

  testthat::expect_equal(
    load_config_value(value = "seed", file = path_config),
    42
  )

  testthat::expect_equal(
    load_config_value(value = c("graphical", "units"), file = path_config),
    "cm"
  )

  list_graphical <-
    load_config_value(value = "graphical", file = path_config)

  testthat::expect_type(list_graphical, "list")

  testthat::expect_named(list_graphical, c("width", "units"))
})

testthat::test_that("load_config_value() follows R_CONFIG_ACTIVE", {
  path_config <-
    withr::local_tempfile(fileext = ".yml")

  base::writeLines(
    text = c(
      "default:",
      "  seed: 42",
      "  graphical:",
      "    width: 16",
      "alternative:",
      "  seed: 7"
    ),
    con = path_config
  )

  withr::local_envvar(R_CONFIG_ACTIVE = "alternative")

  testthat::expect_equal(
    load_config_value(value = "seed", file = path_config),
    7
  )

  testthat::expect_equal(
    load_config_value(value = c("graphical", "width"), file = path_config),
    16
  )
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("load_config_value() aborts on a missing key", {
  path_config <-
    withr::local_tempfile(fileext = ".yml")

  base::writeLines(
    text = c("default:", "  seed: 42"),
    con = path_config
  )

  withr::local_envvar(R_CONFIG_ACTIVE = "default")

  testthat::expect_error(
    load_config_value(value = "missing_key", file = path_config),
    regexp = "not found"
  )

  testthat::expect_error(
    load_config_value(value = c("seed", "nested"), file = path_config),
    regexp = "not found"
  )
})
