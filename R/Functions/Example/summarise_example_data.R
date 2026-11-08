#' @title Summarise the example data by group
#' @description
#' Example function for the template pipeline. Counts records and computes
#' the mean of one numeric column per group, keeping only groups with at
#' least `min_n_records` records.
#' @param data_input
#' Data frame containing the grouping and value columns.
#' @param group_var
#' Bare name of the grouping column.
#' @param value_var
#' Bare name of the numeric value column.
#' @param min_n_records
#' Positive whole-number scalar; the minimum number of records a group needs
#' to be kept.
#' @return
#' Ungrouped tibble with the grouping column, `n_records`, and `mean_value`,
#' sorted by the grouping column.
#' @examples
#' \dontrun{
#' table_species_summary <-
#'   summarise_example_data(
#'     data_input = data_prepared,
#'     group_var = species,
#'     value_var = petal_length,
#'     min_n_records = 3
#'   )
#' }
summarise_example_data <- function(data_input,
                                   group_var,
                                   value_var,
                                   min_n_records = 1L) {
  assertthat::assert_that(
    base::is.data.frame(data_input),
    msg = "`data_input` must be a data frame."
  )

  assertthat::assert_that(
    base::is.numeric(min_n_records),
    base::length(min_n_records) == 1L,
    !base::is.na(min_n_records),
    min_n_records >= 1,
    min_n_records == base::round(min_n_records),
    msg = "`min_n_records` must be a positive whole number."
  )

  res <-
    data_input |>
    dplyr::group_by({{ group_var }}) |>
    dplyr::summarise(
      n_records = dplyr::n(),
      mean_value = base::mean({{ value_var }}),
      .groups = "drop"
    ) |>
    dplyr::filter(.data[["n_records"]] >= min_n_records) |>
    dplyr::arrange({{ group_var }})

  return(res)
}
