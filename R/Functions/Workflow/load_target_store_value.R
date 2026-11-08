#' @title Load a public target from an upstream store
#' @description
#' Validate the upstream store contract and read one public target from it.
#' @param store
#' Character scalar upstream target-store path.
#' @param target_name
#' Character scalar public target name.
#' @param runner
#' Character scalar runner script that builds the upstream store.
#' @return
#' The stored target value.
#' @seealso [compute_target_store_fingerprint()],
#'   [validate_target_store_contract()]
#' @examples
#' \dontrun{
#' data_prepared <-
#'   load_target_store_value(
#'     store = store_data_preparation,
#'     target_name = "data_prepared",
#'     runner = "R/Analyses/01_Data_preparation/00_run.R"
#'   )
#' }
load_target_store_value <- function(store,
                                    target_name,
                                    runner) {
  assertthat::assert_that(
    base::is.character(target_name),
    base::length(target_name) == 1L,
    msg = "`target_name` must be one target name."
  )

  validate_target_store_contract(
    store = store,
    target_names = target_name,
    runner = runner
  )

  res <-
    targets::tar_read_raw(
      name = target_name,
      store = store
    )

  return(res)
}
