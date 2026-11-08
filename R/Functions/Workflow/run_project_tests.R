#' @title Run the project test suite
#' @description
#' Run a `testthat` directory in a fresh R subprocess after sourcing the
#' project setup script, so results do not depend on the calling console.
#' @param test_dir
#' Path to an existing directory with the test files.
#' @param path_setup
#' Path to the setup script sourced before the tests run.
#' @param pattern
#' Regular expression selecting the test files.
#' @param verbose
#' Logical. If `TRUE` (default), the subprocess output (test reporter) is
#' printed; if `FALSE`, the run is silent. Errors are never silenced.
#' @return
#' Invisibly returns a tibble with one row per test, including the columns
#' `file`, `test`, `nb`, `failed`, `skipped`, `error`, and `warning`.
#' @details
#' Interactive consoles (e.g. radian) change console width, colours, and
#' encoding options. These leak into expectations, so the suite always runs
#' via `callr::r()`, which matches a clean `Rscript` run.
#' @examples
#' \dontrun{
#' data_test_results <-
#'   run_project_tests()
#' }
run_project_tests <- function(test_dir = here::here(
                                "R", "Tests", "testthat"
                              ),
                              path_setup = here::here(
                                "R", "___setup_project___.R"
                              ),
                              pattern = "^test-.*[.]R$",
                              verbose = TRUE) {
  assertthat::assert_that(
    base::is.character(test_dir),
    base::length(test_dir) == 1L,
    base::dir.exists(test_dir),
    msg = "`test_dir` must be the path to an existing directory."
  )

  assertthat::assert_that(
    base::is.character(path_setup),
    base::length(path_setup) == 1L,
    base::file.exists(path_setup),
    msg = "`path_setup` must be the path to an existing setup script."
  )

  assertthat::assert_that(
    base::is.character(pattern),
    base::length(pattern) == 1L,
    msg = "`pattern` must be a character scalar."
  )

  assertthat::assert_that(
    base::is.logical(verbose),
    base::length(verbose) == 1L,
    !base::is.na(verbose),
    msg = "`verbose` must be TRUE or FALSE."
  )

  data_results <-
    callr::r(
      func = function(path_setup, test_dir, pattern) {
        base::source(file = path_setup)

        res_tests <-
          testthat::test_dir(
            path = test_dir,
            filter = NULL,
            pattern = pattern,
            stop_on_failure = FALSE,
            stop_on_warning = FALSE
          )

        res_data <-
          base::as.data.frame(res_tests)

        return(res_data)
      },
      args = list(
        path_setup = base::normalizePath(path_setup, winslash = "/"),
        test_dir = base::normalizePath(test_dir, winslash = "/"),
        pattern = pattern
      ),
      wd = here::here(),
      show = verbose,
      spinner = FALSE
    )

  res <-
    tibble::as_tibble(data_results)

  return(invisible(res))
}
