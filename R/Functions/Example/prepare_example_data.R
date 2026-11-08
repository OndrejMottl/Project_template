#' @title Prepare the example data
#' @description
#' Example function for the template pipeline. Converts a raw data frame to
#' a tibble with lower snake case column names. Delete it, its test, and the
#' example targets when starting a real project.
#' @param data_raw
#' Data frame with at least one row and one column.
#' @return
#' Tibble with the same rows as `data_raw` and column names in lower snake
#' case (dots and spaces replaced by `_`).
#' @examples
#' \dontrun{
#' data_prepared <-
#'   prepare_example_data(data_raw = datasets::iris)
#' }
prepare_example_data <- function(data_raw) {
  assertthat::assert_that(
    base::is.data.frame(data_raw),
    base::nrow(data_raw) > 0L,
    base::ncol(data_raw) > 0L,
    msg = "`data_raw` must be a data frame with at least one row and column."
  )

  res <-
    data_raw |>
    tibble::as_tibble() |>
    dplyr::rename_with(
      .fn = ~ .x |>
        stringr::str_to_lower() |>
        stringr::str_replace_all(
          pattern = "[.[:space:]]+",
          replacement = "_"
        )
    )

  return(res)
}
