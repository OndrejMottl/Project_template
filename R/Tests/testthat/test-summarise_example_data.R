#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("summarise_example_data() validates `data_input`", {
  testthat::expect_error(
    summarise_example_data(
      data_input = 1:3,
      group_var = group,
      value_var = value
    ),
    regexp = "data_input"
  )
})

testthat::test_that("summarise_example_data() validates `min_n_records`", {
  data_input <-
    base::data.frame(
      group = c("a", "b"),
      value = c(1, 2)
    )

  testthat::expect_error(
    summarise_example_data(
      data_input = data_input,
      group_var = group,
      value_var = value,
      min_n_records = 0
    ),
    regexp = "min_n_records"
  )

  testthat::expect_error(
    summarise_example_data(
      data_input = data_input,
      group_var = group,
      value_var = value,
      min_n_records = 1.5
    ),
    regexp = "min_n_records"
  )

  testthat::expect_error(
    summarise_example_data(
      data_input = data_input,
      group_var = group,
      value_var = value,
      min_n_records = "2"
    ),
    regexp = "min_n_records"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("summarise_example_data() summarises per group", {
  data_input <-
    base::data.frame(
      group = c("b", "a", "a", "a"),
      value = c(10, 1, 2, 6)
    )

  res <-
    summarise_example_data(
      data_input = data_input,
      group_var = group,
      value_var = value
    )

  testthat::expect_s3_class(res, "tbl_df")

  testthat::expect_false(dplyr::is_grouped_df(res))

  testthat::expect_named(res, c("group", "n_records", "mean_value"))

  testthat::expect_equal(dplyr::pull(res, group), c("a", "b"))

  testthat::expect_equal(dplyr::pull(res, n_records), c(3L, 1L))

  testthat::expect_equal(
    dplyr::pull(res, mean_value),
    c(3, 10),
    tolerance = 1e-8
  )
})

testthat::test_that("summarise_example_data() drops small groups", {
  data_input <-
    base::data.frame(
      group = c("b", "a", "a", "a"),
      value = c(10, 1, 2, 6)
    )

  res <-
    summarise_example_data(
      data_input = data_input,
      group_var = group,
      value_var = value,
      min_n_records = 2
    )

  testthat::expect_equal(dplyr::pull(res, group), "a")
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("summarise_example_data() fails on a missing column", {
  data_input <-
    base::data.frame(
      group = c("a", "b"),
      value = c(1, 2)
    )

  testthat::expect_error(
    summarise_example_data(
      data_input = data_input,
      group_var = missing_column,
      value_var = value
    )
  )
})
