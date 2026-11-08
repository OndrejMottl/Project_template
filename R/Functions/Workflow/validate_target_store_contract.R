#' @title Validate a target-store contract
#' @description
#' Check that an upstream target store exists and contains every required
#' public target as a completed target.
#' @param store
#' Character scalar upstream target-store path.
#' @param target_names
#' Character vector of required public target names.
#' @param runner
#' Character scalar runner script that builds the upstream store. It is
#' named in the error message so the user knows what to run first.
#' @return
#' Invisibly returns a tibble with the `name` and `data` (hash) metadata of
#' the required targets.
#' @examples
#' \dontrun{
#' validate_target_store_contract(
#'   store = store_data_preparation,
#'   target_names = "data_prepared",
#'   runner = "R/Analyses/01_Data_preparation/00_run.R"
#' )
#' }
validate_target_store_contract <- function(store,
                                           target_names,
                                           runner) {
  assertthat::assert_that(
    base::is.character(store),
    base::length(store) == 1L,
    base::is.character(target_names),
    base::length(target_names) > 0L,
    base::all(!base::is.na(target_names)),
    base::all(base::nzchar(target_names)),
    base::is.character(runner),
    base::length(runner) == 1L,
    !base::is.na(runner),
    base::nzchar(runner),
    msg = "Target-store contract arguments are invalid."
  )

  if (
    isFALSE(base::dir.exists(store))
  ) {
    cli::cli_abort(
      c(
        "The required upstream target store does not exist:",
        "x" = "{.path {store}}",
        "i" = "Run {.path {runner}} first."
      )
    )
  }

  data_meta <-
    targets::tar_meta(
      fields = c("name", "data"),
      complete_only = TRUE,
      store = store
    ) |>
    dplyr::filter(.data[["name"]] %in% target_names)

  vec_missing_targets <-
    base::setdiff(
      target_names,
      dplyr::pull(data_meta, "name")
    )

  if (
    base::length(vec_missing_targets) > 0L
  ) {
    cli::cli_abort(
      c(
        "The upstream store is missing public targets:",
        "x" = "{.val {vec_missing_targets}}",
        "i" = "Run {.path {runner}} first."
      )
    )
  }

  res_meta <-
    data_meta |>
    dplyr::select(dplyr::all_of(c("name", "data")))

  return(invisible(res_meta))
}
