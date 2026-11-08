#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("run_target_pipeline() validates arguments", {
  dir_root <-
    withr::local_tempdir()

  path_script <-
    base::file.path(dir_root, "pipeline.R")

  base::writeLines(
    text = "list(targets::tar_target(name = data_alpha, command = 1))",
    con = path_script
  )

  testthat::expect_error(
    run_target_pipeline(
      script = base::file.path(dir_root, "missing.R"),
      store = base::file.path(dir_root, "store")
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    run_target_pipeline(
      script = path_script,
      store = 1
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    run_target_pipeline(
      script = path_script,
      store = ""
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    run_target_pipeline(
      script = path_script,
      store = NA_character_
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    run_target_pipeline(
      script = path_script,
      store = base::file.path(dir_root, "store"),
      visualise = NA
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    run_target_pipeline(
      script = path_script,
      store = base::file.path(dir_root, "store"),
      verbose = "yes"
    ),
    regexp = "arguments are invalid"
  )
})


#----------------------------------------------------------#
# Outputs and side effects -----
#----------------------------------------------------------#

testthat::test_that("run_target_pipeline() builds targets in the store", {
  dir_root <-
    withr::local_tempdir()

  path_script <-
    base::file.path(dir_root, "pipeline.R")

  path_store <-
    base::file.path(dir_root, "store")

  base::writeLines(
    text = "list(targets::tar_target(name = data_alpha, command = 1:2))",
    con = path_script
  )

  res <-
    run_target_pipeline(
      script = path_script,
      store = path_store,
      verbose = FALSE
    )

  testthat::expect_null(res)

  testthat::expect_true(base::dir.exists(path_store))

  testthat::expect_equal(
    targets::tar_read_raw(name = "data_alpha", store = path_store),
    1:2
  )
})


#----------------------------------------------------------#
# Messages -----
#----------------------------------------------------------#

testthat::test_that("run_target_pipeline() is silent if verbose = FALSE", {
  dir_root <-
    withr::local_tempdir()

  path_script <-
    base::file.path(dir_root, "pipeline.R")

  base::writeLines(
    text = "list(targets::tar_target(name = data_alpha, command = 1:2))",
    con = path_script
  )

  testthat::expect_silent(
    run_target_pipeline(
      script = path_script,
      store = base::file.path(dir_root, "store"),
      verbose = FALSE
    )
  )
})
