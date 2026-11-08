#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("validate_target_store_contract() validates arguments", {
  testthat::expect_error(
    validate_target_store_contract(
      store = 1,
      target_names = "data_alpha",
      runner = "R/run.R"
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    validate_target_store_contract(
      store = "store",
      target_names = base::character(0),
      runner = "R/run.R"
    ),
    regexp = "arguments are invalid"
  )

  testthat::expect_error(
    validate_target_store_contract(
      store = "store",
      target_names = "data_alpha",
      runner = ""
    ),
    regexp = "arguments are invalid"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("validate_target_store_contract() returns metadata", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  res <-
    validate_target_store_contract(
      store = path_store,
      target_names = "data_alpha",
      runner = "R/run.R"
    )

  testthat::expect_s3_class(res, "data.frame")

  testthat::expect_named(res, c("name", "data"))

  testthat::expect_equal(
    dplyr::pull(res, name),
    "data_alpha"
  )
})


#----------------------------------------------------------#
# Edge cases and messages -----
#----------------------------------------------------------#

testthat::test_that("validate_target_store_contract() names the runner", {
  dir_root <-
    withr::local_tempdir()

  testthat::expect_error(
    validate_target_store_contract(
      store = base::file.path(dir_root, "missing_store"),
      target_names = "data_alpha",
      runner = "R/Analyses/01_Stage/00_run.R"
    ),
    regexp = "does not exist"
  )

  testthat::expect_error(
    validate_target_store_contract(
      store = base::file.path(dir_root, "missing_store"),
      target_names = "data_alpha",
      runner = "R/Analyses/01_Stage/00_run.R"
    ),
    regexp = "01_Stage/00_run.R",
    fixed = TRUE
  )
})

testthat::test_that("validate_target_store_contract() flags missing targets", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  testthat::expect_error(
    validate_target_store_contract(
      store = path_store,
      target_names = c("data_alpha", "data_gamma"),
      runner = "R/run.R"
    ),
    regexp = "missing public targets"
  )

  testthat::expect_error(
    validate_target_store_contract(
      store = path_store,
      target_names = c("data_alpha", "data_gamma"),
      runner = "R/Analyses/01_Stage/00_run.R"
    ),
    regexp = "01_Stage/00_run.R",
    fixed = TRUE
  )
})
