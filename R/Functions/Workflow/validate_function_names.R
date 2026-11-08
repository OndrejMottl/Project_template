#' @title Validate project function files
#' @description
#' Enforce the function-file contract: each file holds exactly one top-level
#' function, the file name equals the function name (ignoring one leading
#' dot), and the name is lower snake case starting with an approved verb.
#' @param function_dir
#' Directory searched recursively for `.R` function files.
#' @param approved_verbs
#' Character vector of approved leading verbs.
#' @return
#' Invisibly returns a tibble with one validation row per function file.
#' Aborts when any file violates the contract.
#' @examples
#' \dontrun{
#' validate_function_names()
#' }
validate_function_names <- function(function_dir = here::here(
                                      "R", "Functions"
                                    ),
                                    approved_verbs = c(
                                      "load", "save", "build", "prepare",
                                      "validate", "diagnose", "is", "has",
                                      "resolve", "compute", "aggregate",
                                      "summarise", "fit", "predict",
                                      "score", "evaluate", "select", "run",
                                      "plot", "render", "filter",
                                      "classify", "interpolate", "scale",
                                      "project", "cluster", "deduplicate",
                                      "normalise"
                                    )) {
  assertthat::assert_that(
    base::is.character(function_dir),
    base::length(function_dir) == 1L,
    !base::is.na(function_dir),
    base::dir.exists(function_dir),
    base::is.character(approved_verbs),
    base::length(approved_verbs) > 0L,
    !base::anyNA(approved_verbs),
    msg = "Function-name validation inputs do not satisfy the contract."
  )

  # Top-level definitions start at column one
  pattern_declaration <-
    stringr::str_c(
      "^([.]?[a-z][a-z0-9_]*)",
      "[[:space:]]*<-[[:space:]]*function"
    )

  vec_function_files <-
    base::list.files(
      path = function_dir,
      pattern = "[.]R$",
      recursive = TRUE,
      full.names = TRUE
    )

  if (
    base::length(vec_function_files) == 0L
  ) {
    cli::cli_abort(
      "No function files ({.file .R}) found in {.path {function_dir}}."
    )
  }

  data_validation <-
    vec_function_files |>
    purrr::map(
      .f = ~ {
        file_function <- .x

        vec_lines <-
          base::readLines(
            con = file_function,
            warn = FALSE,
            encoding = "UTF-8"
          )

        vec_declared_names <-
          stringr::str_match(
            string = vec_lines,
            pattern = pattern_declaration
          )[, 2] |>
          stats::na.omit() |>
          base::as.character()

        name_public <-
          stringr::str_remove(
            string = vec_declared_names[1],
            pattern = "^[.]"
          )

        verb <-
          stringr::str_extract(
            string = name_public,
            pattern = "^[^_]+"
          )

        tibble::tibble(
          function_file = file_function,
          function_name = name_public,
          has_one_function = base::length(vec_declared_names) == 1L,
          uses_lower_snake_case = stringr::str_detect(
            string = name_public,
            pattern = "^[a-z][a-z0-9]*(?:_[a-z0-9]+)+$"
          ),
          uses_approved_verb = verb %in% approved_verbs,
          basename_matches = base::basename(file_function) ==
            stringr::str_c(name_public, ".R")
        )
      }
    ) |>
    purrr::list_rbind()

  data_invalid <-
    data_validation |>
    dplyr::filter(
      !.data[["has_one_function"]] |
        base::is.na(.data[["uses_lower_snake_case"]]) |
        !.data[["uses_lower_snake_case"]] |
        !.data[["uses_approved_verb"]] |
        base::is.na(.data[["basename_matches"]]) |
        !.data[["basename_matches"]]
    )

  if (
    base::nrow(data_invalid) > 0L
  ) {
    vec_invalid_files <-
      data_invalid |>
      dplyr::pull("function_file") |>
      base::basename()

    cli::cli_abort(
      c(
        "Function-name contract failed.",
        "x" = "Invalid file{?s}: {.file {vec_invalid_files}}",
        "i" = "Each file: one function, named as the file, approved verb."
      )
    )
  }

  return(invisible(data_validation))
}
