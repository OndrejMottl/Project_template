#' @title Run one target pipeline
#' @description
#' Run one `{targets}` pipeline script in its own store and optionally show
#' its dependency graph.
#' @param script
#' Character scalar path to an existing pipeline script.
#' @param store
#' Character scalar path to the pipeline's target store.
#' @param visualise
#' Logical scalar. If `TRUE`, open the targets-only dependency graph after
#' the run.
#' @param verbose
#' Logical. If `TRUE` (default), `{targets}` progress is printed; if `FALSE`,
#' the run is silent. Errors are never silenced.
#' @return
#' Invisibly returns `NULL` after the pipeline completes.
#' @examples
#' \dontrun{
#' run_target_pipeline(
#'   script = here::here("R/Analyses/01_Data_preparation/pipeline.R"),
#'   store = store_data_preparation
#' )
#' }
run_target_pipeline <- function(script,
                                store,
                                visualise = FALSE,
                                verbose = TRUE) {
  assertthat::assert_that(
    base::is.character(script),
    base::length(script) == 1L,
    base::file.exists(script),
    base::is.character(store),
    base::length(store) == 1L,
    !base::is.na(store),
    base::nzchar(store),
    base::is.logical(visualise),
    base::length(visualise) == 1L,
    !base::is.na(visualise),
    base::is.logical(verbose),
    base::length(verbose) == 1L,
    !base::is.na(verbose),
    msg = "Target pipeline arguments are invalid."
  )

  reporter_make <- "silent"

  if (
    isTRUE(verbose)
  ) {
    reporter_make <-
      targets::tar_config_get(name = "reporter_make")
  }

  targets::tar_make(
    script = script,
    store = store,
    reporter = reporter_make
  )

  if (
    isTRUE(visualise)
  ) {
    targets::tar_visnetwork(
      targets_only = TRUE,
      script = script,
      store = store
    )
  }

  return(invisible(NULL))
}
