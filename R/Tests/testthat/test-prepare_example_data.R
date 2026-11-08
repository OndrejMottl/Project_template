#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("prepare_example_data() validates `data_raw`", {
  testthat::expect_error(
    prepare_example_data(data_raw = 1:3),
    regexp = "data_raw"
  )

  testthat::expect_error(
    prepare_example_data(
      data_raw = base::data.frame(value = base::numeric(0))
    ),
    regexp = "data_raw"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("prepare_example_data() returns snake case names", {
  data_raw <-
    base::data.frame(
      Sepal.Length = c(5.1, 4.9),
      `Petal Width` = c(0.2, 0.3),
      Species = c("setosa", "setosa"),
      check.names = FALSE
    )

  res <-
    prepare_example_data(data_raw = data_raw)

  testthat::expect_s3_class(res, "tbl_df")

  testthat::expect_named(res, c("sepal_length", "petal_width", "species"))

  testthat::expect_equal(base::nrow(res), 2L)

  testthat::expect_equal(
    dplyr::pull(res, sepal_length),
    c(5.1, 4.9)
  )
})

testthat::test_that("prepare_example_data() keeps rows of a larger input", {
  res <-
    prepare_example_data(data_raw = datasets::iris)

  testthat::expect_equal(base::nrow(res), 150L)

  testthat::expect_true("petal_length" %in% base::colnames(res))
})
