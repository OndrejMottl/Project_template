#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("resolve_pipeline_store_path() validates arguments", {
  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = 1,
      store_relative_path = "data_preparation"
    ),
    regexp = "non-empty character"
  )

  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = ""
    ),
    regexp = "non-empty character"
  )

  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = c("a", "b")
    ),
    regexp = "non-empty character"
  )
})

testthat::test_that("resolve_pipeline_store_path() rejects absolute paths", {
  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = "D:/elsewhere"
    ),
    regexp = "relative"
  )

  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = "/elsewhere"
    ),
    regexp = "relative"
  )
})

testthat::test_that("resolve_pipeline_store_path() rejects `..` traversal", {
  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = "../outside"
    ),
    regexp = "traverse"
  )

  testthat::expect_error(
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = "stage/../../outside"
    ),
    regexp = "traverse"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("resolve_pipeline_store_path() builds the store path", {
  res <-
    resolve_pipeline_store_path(
      path_data_storage = "D:/Project_data",
      store_relative_path = "data_preparation"
    )

  testthat::expect_type(res, "character")

  testthat::expect_length(res, 1L)

  testthat::expect_equal(
    res,
    "D:/Project_data/Targets_data/data_preparation"
  )
})

testthat::test_that("resolve_pipeline_store_path() allows nested stores", {
  res <-
    resolve_pipeline_store_path(
      path_data_storage = "Data",
      store_relative_path = "main_analyses/models"
    )

  testthat::expect_equal(
    res,
    "Data/Targets_data/main_analyses/models"
  )
})
