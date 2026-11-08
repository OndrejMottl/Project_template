#----------------------------------------------------------#
#
#
#                     Project name
#
#                    Run test suite
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Checks the function-file contract, then runs every test in a clean R
#   subprocess. Exits with an error when any test fails or errors.
# Run with:
#   Rscript R/Tests/Run_tests.R
# For a focused run use `run_test_file()` after sourcing the setup.


#----------------------------------------------------------#
# 0. Setup -----
#----------------------------------------------------------#

library(here)

source(
  here::here("R/___setup_project___.R")
)


#----------------------------------------------------------#
# 1. Validate function files -----
#----------------------------------------------------------#

validate_function_names()


#----------------------------------------------------------#
# 2. Run tests -----
#----------------------------------------------------------#

data_test_results <-
  run_project_tests()

n_failed <-
  data_test_results |>
  dplyr::pull("failed") |>
  base::sum()

n_errored <-
  data_test_results |>
  dplyr::pull("error") |>
  base::sum()

if (
  base::nrow(data_test_results) == 0L
) {
  cli::cli_abort("No tests were found or run.")
}

if (
  n_failed + n_errored > 0L
) {
  cli::cli_abort(
    "Test suite failed: {n_failed} failure{?s}, {n_errored} error{?s}."
  )
}

cli::cli_alert_success(
  "All {base::nrow(data_test_results)} tests passed."
)
