#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("run_test_file() validates paths", {
  dir_root <-
    withr::local_tempdir()

  path_setup <-
    base::file.path(dir_root, "setup.R")

  base::writeLines(text = "# setup", con = path_setup)

  testthat::expect_error(
    run_test_file(
      test_file = base::file.path(dir_root, "test-missing.R"),
      path_setup = path_setup
    ),
    regexp = "test_file"
  )

  path_test <-
    base::file.path(dir_root, "test-example.R")

  base::writeLines(
    text = "testthat::test_that('ok', testthat::expect_true(TRUE))",
    con = path_test
  )

  testthat::expect_error(
    run_test_file(
      test_file = path_test,
      path_setup = base::file.path(dir_root, "missing_setup.R")
    ),
    regexp = "path_setup"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("run_test_file() runs one file", {
  dir_root <-
    withr::local_tempdir()

  path_setup <-
    base::file.path(dir_root, "setup.R")

  base::writeLines(text = "# setup", con = path_setup)

  path_test <-
    base::file.path(dir_root, "test-example.R")

  base::writeLines(
    text = c(
      "testthat::test_that('first', testthat::expect_true(TRUE))",
      "testthat::test_that('second', testthat::expect_true(TRUE))"
    ),
    con = path_test
  )

  res <-
    run_test_file(
      test_file = path_test,
      path_setup = path_setup
    )

  data_res <-
    base::as.data.frame(res)

  testthat::expect_equal(base::nrow(data_res), 2L)

  testthat::expect_equal(
    base::sum(dplyr::pull(data_res, failed)),
    0L
  )
})
