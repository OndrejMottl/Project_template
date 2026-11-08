#' @title Resolve a pipeline target store
#' @description
#' Resolve the store folder of one `{targets}` pipeline below the
#' `Targets_data` folder of the project data root.
#' @param path_data_storage
#' Character scalar project data root (see `resolve_data_storage_path()`).
#' @param store_relative_path
#' Character scalar store path below `Targets_data`, e.g.
#' `"data_preparation"`. It may not traverse upwards with `..`.
#' @return
#' Character scalar target-store path.
#' @examples
#' \dontrun{
#' store_data_preparation <-
#'   resolve_pipeline_store_path(
#'     path_data_storage = path_data_storage,
#'     store_relative_path = "data_preparation"
#'   )
#' }
resolve_pipeline_store_path <- function(path_data_storage,
                                        store_relative_path) {
  assertthat::assert_that(
    base::is.character(path_data_storage),
    base::length(path_data_storage) == 1L,
    !base::is.na(path_data_storage),
    base::nzchar(path_data_storage),
    base::is.character(store_relative_path),
    base::length(store_relative_path) == 1L,
    !base::is.na(store_relative_path),
    base::nzchar(store_relative_path),
    msg = "Pipeline store paths must be non-empty character scalars."
  )

  assertthat::assert_that(
    !stringr::str_detect(
      string = store_relative_path,
      pattern = "^([A-Za-z]:|[/\\\\~])"
    ),
    msg = "`store_relative_path` must be relative to `Targets_data`."
  )

  assertthat::assert_that(
    !stringr::str_detect(
      string = store_relative_path,
      pattern = "(^|[\\\\/])[.][.]([\\\\/]|$)"
    ),
    msg = "Pipeline store paths may not traverse above `Targets_data`."
  )

  res <-
    base::file.path(
      path_data_storage,
      "Targets_data",
      store_relative_path
    )

  return(res)
}
