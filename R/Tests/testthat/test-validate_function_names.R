#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("validate_function_names() needs an existing folder", {
  testthat::expect_error(
    validate_function_names(
      function_dir = base::file.path(base::tempdir(), "missing_folder")
    ),
    regexp = "contract"
  )
})

testthat::test_that("validate_function_names() aborts on an empty folder", {
  dir_functions <-
    withr::local_tempdir()

  testthat::expect_error(
    validate_function_names(function_dir = dir_functions),
    regexp = "No function files"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("validate_function_names() accepts valid files", {
  dir_functions <-
    withr::local_tempdir()

  base::writeLines(
    text = "compute_total <- function(x) {\n  return(x)\n}",
    con = base::file.path(dir_functions, "compute_total.R")
  )

  base::writeLines(
    text = ".resolve_value <- function(x) {\n  return(x)\n}",
    con = base::file.path(dir_functions, "resolve_value.R")
  )

  res <-
    validate_function_names(function_dir = dir_functions)

  testthat::expect_s3_class(res, "data.frame")

  testthat::expect_equal(base::nrow(res), 2L)

  testthat::expect_true(
    base::all(dplyr::pull(res, basename_matches))
  )
})

testthat::test_that("validate_function_names() passes the project folder", {
  res <-
    validate_function_names()

  testthat::expect_true(base::nrow(res) > 0L)
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("validate_function_names() rejects two functions", {
  dir_functions <-
    withr::local_tempdir()

  base::writeLines(
    text = c(
      "compute_total <- function(x) {",
      "  return(x)",
      "}",
      "compute_other <- function(x) {",
      "  return(x)",
      "}"
    ),
    con = base::file.path(dir_functions, "compute_total.R")
  )

  testthat::expect_error(
    validate_function_names(function_dir = dir_functions),
    regexp = "contract failed"
  )
})

testthat::test_that("validate_function_names() rejects a wrong file name", {
  dir_functions <-
    withr::local_tempdir()

  base::writeLines(
    text = "compute_total <- function(x) {\n  return(x)\n}",
    con = base::file.path(dir_functions, "compute_sum.R")
  )

  testthat::expect_error(
    validate_function_names(function_dir = dir_functions),
    regexp = "contract failed"
  )
})

testthat::test_that("validate_function_names() rejects unapproved verbs", {
  dir_functions <-
    withr::local_tempdir()

  base::writeLines(
    text = "get_total <- function(x) {\n  return(x)\n}",
    con = base::file.path(dir_functions, "get_total.R")
  )

  testthat::expect_error(
    validate_function_names(function_dir = dir_functions),
    regexp = "contract failed"
  )
})
