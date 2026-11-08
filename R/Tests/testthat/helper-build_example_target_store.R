#' @title Build a small target store for tests
#' @description
#' Write a two-target pipeline into `dir_root` and run it in the current
#' session, so store-contract functions can be tested against a real store.
#' @param dir_root
#' Existing directory that receives `pipeline.R` and the `store` folder.
#' @param command_alpha
#' Character scalar R expression used as the command of `data_alpha`.
#' @return
#' Character scalar path to the built store.
build_example_target_store <- function(dir_root,
                                       command_alpha = "1:3") {
  path_script <-
    base::file.path(dir_root, "pipeline.R")

  path_store <-
    base::file.path(dir_root, "store")

  base::writeLines(
    text = c(
      "list(",
      stringr::str_glue(
        "  targets::tar_target(name = data_alpha, command = {command_alpha}),"
      ),
      "  targets::tar_target(name = data_beta, command = letters[1:2])",
      ")"
    ),
    con = path_script
  )

  targets::tar_make(
    script = path_script,
    store = path_store,
    callr_function = NULL,
    reporter = "silent"
  )

  res_path_store <- path_store

  return(res_path_store)
}
