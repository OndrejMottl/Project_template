#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("run_project_tests() validates paths", {
  dir_root <-
    withr::local_tempdir()

  path_setup <-
    base::file.path(dir_root, "setup.R")

  base::writeLines(text = "# setup", con = path_setup)

  testthat::expect_error(
    run_project_tests(
      test_dir = base::file.path(dir_root, "missing_tests"),
      path_setup = path_setup
    ),
    regexp = "test_dir"
  )

  testthat::expect_error(
    run_project_tests(
      test_dir = dir_root,
      path_setup = base::file.path(dir_root, "missing_setup.R")
    ),
    regexp = "path_setup"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("run_project_tests() reports passes and failures", {
  dir_root <-
    withr::local_tempdir()

  dir_tests <-
    base::file.path(dir_root, "testthat")

  base::dir.create(dir_tests)

  path_setup <-
    base::file.path(dir_root, "setup.R")

  base::writeLines(
    text = "value_from_setup <- 2",
    con = path_setup
  )

  base::writeLines(
    text = c(
      "testthat::test_that('setup is sourced', {",
      "  testthat::expect_equal(value_from_setup, 2)",
      "})",
      "testthat::test_that('this fails', {",
      "  testthat::expect_equal(1, 2)",
      "})"
    ),
    con = base::file.path(dir_tests, "test-example.R")
  )

  res <-
    run_project_tests(
      test_dir = dir_tests,
      path_setup = path_setup,
      verbose = FALSE
    )

  testthat::expect_s3_class(res, "data.frame")

  testthat::expect_equal(base::nrow(res), 2L)

  testthat::expect_equal(
    dplyr::pull(res, failed),
    c(0L, 1L)
  )
})


#----------------------------------------------------------#
# Messages -----
#----------------------------------------------------------#

testthat::test_that("run_project_tests() is silent if verbose = FALSE", {
  dir_root <-
    withr::local_tempdir()

  path_setup <-
    base::file.path(dir_root, "setup.R")

  base::writeLines(text = "# setup", con = path_setup)

  base::writeLines(
    text = "testthat::test_that('ok', testthat::expect_true(TRUE))",
    con = base::file.path(dir_root, "test-example.R")
  )

  testthat::expect_silent(
    run_project_tests(
      test_dir = dir_root,
      path_setup = path_setup,
      verbose = FALSE
    )
  )

  testthat::expect_error(
    run_project_tests(
      test_dir = dir_root,
      path_setup = path_setup,
      verbose = NA
    ),
    regexp = "verbose"
  )
})
