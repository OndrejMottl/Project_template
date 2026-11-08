#' @title Compute an upstream target-store fingerprint
#' @description
#' Build a deterministic fingerprint from the recorded data hashes of public
#' targets in an upstream store. A downstream target that depends on the
#' fingerprint is invalidated whenever an upstream public target changes.
#' @param store
#' Character scalar upstream target-store path.
#' @param target_names
#' Character vector of public target names.
#' @param runner
#' Character scalar runner script that builds the upstream store.
#' @return
#' Character scalar of `name=hash` pairs, sorted by name and joined by `|`.
#' @examples
#' \dontrun{
#' fingerprint_data_preparation <-
#'   compute_target_store_fingerprint(
#'     store = store_data_preparation,
#'     target_names = "data_prepared",
#'     runner = "R/Analyses/01_Data_preparation/00_run.R"
#'   )
#' }
compute_target_store_fingerprint <- function(store,
                                             target_names,
                                             runner) {
  data_meta <-
    validate_target_store_contract(
      store = store,
      target_names = target_names,
      runner = runner
    )

  res <-
    data_meta |>
    dplyr::arrange(.data[["name"]]) |>
    dplyr::mutate(
      value = stringr::str_c(.data[["name"]], .data[["data"]], sep = "=")
    ) |>
    dplyr::pull("value") |>
    stringr::str_c(collapse = "|")

  return(res)
}
