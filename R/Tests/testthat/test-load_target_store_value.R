#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("load_target_store_value() reads a public target", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  res_alpha <-
    load_target_store_value(
      store = path_store,
      target_name = "data_alpha",
      runner = "R/run.R"
    )

  res_beta <-
    load_target_store_value(
      store = path_store,
      target_name = "data_beta",
      runner = "R/run.R"
    )

  testthat::expect_equal(res_alpha, 1:3)

  testthat::expect_equal(res_beta, c("a", "b"))
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("load_target_store_value() aborts on a missing target", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  testthat::expect_error(
    load_target_store_value(
      store = path_store,
      target_name = "data_gamma",
      runner = "R/run.R"
    ),
    regexp = "missing public targets"
  )
})

testthat::test_that("load_target_store_value() needs one target name", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  testthat::expect_error(
    load_target_store_value(
      store = path_store,
      target_name = c("data_alpha", "data_beta"),
      runner = "R/run.R"
    ),
    regexp = "target_name"
  )
})

testthat::test_that("load_target_store_value() aborts on a missing store", {
  dir_root <-
    withr::local_tempdir()

  testthat::expect_error(
    load_target_store_value(
      store = base::file.path(dir_root, "missing_store"),
      target_name = "data_alpha",
      runner = "R/run.R"
    ),
    regexp = "does not exist"
  )
})
