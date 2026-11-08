#' @title Load a configuration value
#' @description
#' Load one (possibly nested) value from the project configuration file,
#' using the profile selected by `R_CONFIG_ACTIVE` (`default` otherwise).
#' @param value
#' Character vector giving the key path, e.g. `c("graphical", "width")`.
#' @param file
#' Path to the YAML configuration file. Defaults to the project `config.yml`.
#' @return
#' The configuration value stored at the key path.
#' @details
#' This is the only project boundary around `config::get()`. Scripts,
#' pipelines, and functions read configuration through it. A missing key is
#' an error, never a silent `NULL`.
#' @examples
#' \dontrun{
#' config_seed <-
#'   load_config_value(value = "seed")
#' }
load_config_value <- function(value,
                              file = here::here("config.yml")) {
  assertthat::assert_that(
    base::is.character(value),
    base::length(value) > 0L,
    base::all(!base::is.na(value)),
    base::all(base::nzchar(value)),
    msg = "`value` must be a character vector of non-empty keys."
  )

  assertthat::assert_that(
    base::is.character(file),
    base::length(file) == 1L,
    base::file.exists(file),
    msg = "`file` must be the path to an existing YAML file."
  )

  # Read the whole active profile, so a missing nested key can be reported
  #   instead of silently returning NULL
  list_config <-
    config::get(file = file)

  is_key_present <-
    purrr::pluck_exists(list_config, !!!base::as.list(value))

  if (
    isFALSE(is_key_present)
  ) {
    cli::cli_abort(
      c(
        "Configuration key {.val {value}} not found.",
        "i" = "Check {.path {file}} and the active profile."
      )
    )
  }

  res <-
    purrr::chuck(list_config, !!!base::as.list(value))

  return(res)
}
