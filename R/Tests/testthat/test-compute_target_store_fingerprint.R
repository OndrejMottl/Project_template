#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("compute_target_store_fingerprint() returns a scalar", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  res <-
    compute_target_store_fingerprint(
      store = path_store,
      target_names = c("data_alpha", "data_beta"),
      runner = "R/run.R"
    )

  testthat::expect_type(res, "character")

  testthat::expect_length(res, 1L)

  testthat::expect_match(res, "^data_alpha=[^|]+[|]data_beta=[^|]+$")
})

testthat::test_that("compute_target_store_fingerprint() ignores name order", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  res_sorted <-
    compute_target_store_fingerprint(
      store = path_store,
      target_names = c("data_alpha", "data_beta"),
      runner = "R/run.R"
    )

  res_reversed <-
    compute_target_store_fingerprint(
      store = path_store,
      target_names = c("data_beta", "data_alpha"),
      runner = "R/run.R"
    )

  testthat::expect_type(res_reversed, "character")

  testthat::expect_identical(res_sorted, res_reversed)
})

testthat::test_that("compute_target_store_fingerprint() tracks changes", {
  dir_root_first <-
    withr::local_tempdir()

  dir_root_second <-
    withr::local_tempdir()

  path_store_first <-
    build_example_target_store(
      dir_root = dir_root_first,
      command_alpha = "1:3"
    )

  path_store_second <-
    build_example_target_store(
      dir_root = dir_root_second,
      command_alpha = "4:6"
    )

  res_first <-
    compute_target_store_fingerprint(
      store = path_store_first,
      target_names = "data_alpha",
      runner = "R/run.R"
    )

  res_second <-
    compute_target_store_fingerprint(
      store = path_store_second,
      target_names = "data_alpha",
      runner = "R/run.R"
    )

  testthat::expect_false(base::identical(res_first, res_second))
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("compute_target_store_fingerprint() needs all targets", {
  dir_root <-
    withr::local_tempdir()

  path_store <-
    build_example_target_store(dir_root = dir_root)

  testthat::expect_error(
    compute_target_store_fingerprint(
      store = path_store,
      target_names = "data_gamma",
      runner = "R/run.R"
    ),
    regexp = "missing public targets"
  )
})
