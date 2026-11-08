#' @title Run one test file
#' @description
#' Source the project setup script and run a single `testthat` file in the
#' current session. Use it for focused runs during development; use
#' `run_project_tests()` for the full suite.
#' @param test_file
#' Path to an existing test file.
#' @param path_setup
#' Path to the setup script sourced before the test runs.
#' @return
#' Invisibly returns the `testthat` results object.
#' @examples
#' \dontrun{
#' run_test_file(
#'   test_file = here::here(
#'     "R/Tests/testthat/test-load_config_value.R"
#'   )
#' )
#' }
run_test_file <- function(test_file,
                          path_setup = here::here(
                            "R", "___setup_project___.R"
                          )) {
  assertthat::assert_that(
    base::is.character(test_file),
    base::length(test_file) == 1L,
    base::file.exists(test_file),
    msg = "`test_file` must be the path to an existing test file."
  )

  assertthat::assert_that(
    base::is.character(path_setup),
    base::length(path_setup) == 1L,
    base::file.exists(path_setup),
    msg = "`path_setup` must be the path to an existing setup script."
  )

  base::source(file = path_setup)

  res <-
    testthat::test_file(path = test_file)

  return(invisible(res))
}
