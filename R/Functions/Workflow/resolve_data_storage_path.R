#' @title Resolve the project data root
#' @description
#' Choose the folder that holds large inputs and target stores. A
#' machine-local `secrets.yaml` with a `Data` entry wins; otherwise the
#' configured default is used.
#' @param path_default
#' Character scalar default data root, absolute or relative to
#' `path_project`. Usually `load_config_value(value = "data_storage_path")`.
#' @param path_secrets
#' Path to the git-ignored machine-local secrets file.
#' @param path_project
#' Project root used to resolve relative paths.
#' @return
#' Character scalar absolute path to the data root. The folder does not have
#' to exist.
#' @examples
#' \dontrun{
#' path_data_storage <-
#'   resolve_data_storage_path(path_default = "Data")
#' }
resolve_data_storage_path <- function(path_default,
                                      path_secrets = here::here(
                                        "secrets.yaml"
                                      ),
                                      path_project = here::here()) {
  assertthat::assert_that(
    base::is.character(path_default),
    base::length(path_default) == 1L,
    !base::is.na(path_default),
    base::nzchar(path_default),
    msg = "`path_default` must be a non-empty character scalar."
  )

  assertthat::assert_that(
    base::is.character(path_secrets),
    base::length(path_secrets) == 1L,
    base::is.character(path_project),
    base::length(path_project) == 1L,
    msg = "`path_secrets` and `path_project` must be character scalars."
  )

  path_selected <- path_default

  if (
    base::file.exists(path_secrets)
  ) {
    list_secrets <-
      yaml::read_yaml(file = path_secrets)

    if (
      purrr::pluck_exists(list_secrets, "Data")
    ) {
      path_secret_data <-
        purrr::chuck(list_secrets, "Data")

      is_valid_secret <-
        base::is.character(path_secret_data) &&
        base::length(path_secret_data) == 1L &&
        base::nzchar(path_secret_data)

      if (
        isFALSE(is_valid_secret)
      ) {
        cli::cli_abort(
          c(
            "The {.field Data} entry in {.path {path_secrets}} is invalid.",
            "i" = "It must be one non-empty path string."
          )
        )
      }

      path_selected <- path_secret_data
    }
  }

  # Expand `~` first; then a drive letter, leading slash, or leading
  #   backslash (including UNC paths) marks an absolute path
  path_expanded <-
    base::path.expand(path_selected)

  is_absolute <-
    stringr::str_detect(
      string = path_expanded,
      pattern = "^([A-Za-z]:)?[/\\\\]"
    )

  if (
    isTRUE(is_absolute)
  ) {
    res <- path_expanded
  } else {
    res <-
      base::file.path(path_project, path_expanded)
  }

  return(res)
}
