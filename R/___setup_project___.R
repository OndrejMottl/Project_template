#----------------------------------------------------------#
#
#
#                     Project name
#
#                     Project setup
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Shared setup sourced at the top of every script, pipeline, and test run:
#   loads project functions, attaches packages, writes the renv dependency
#   manifest, applies seed and graphical options from `config.yml`, and
#   resolves the data root. Run `R/___Init_project___.R` once beforehand.


#----------------------------------------------------------#
# 1. Load project functions -----
#----------------------------------------------------------#

library(here)

vec_function_files <-
  base::list.files(
    path = here::here("R", "Functions"),
    pattern = "[.]R$",
    recursive = TRUE,
    full.names = TRUE
  )

purrr::walk(
  .x = vec_function_files,
  .f = ~ base::source(
    file = .x,
    encoding = "UTF-8"
  )
)


#----------------------------------------------------------#
# 2. Attach packages -----
#----------------------------------------------------------#

vec_packages_attach <-
  load_config_value(value = c("packages", "attach")) |>
  base::unlist()

vec_packages_tools <-
  load_config_value(value = c("packages", "tools")) |>
  base::unlist()

# All project code calls `pkg::fun()`, so attach messages and conflicts are
#   irrelevant and silenced
purrr::walk(
  .x = vec_packages_attach,
  .f = ~ base::suppressPackageStartupMessages(
    base::library(
      package = .x,
      character.only = TRUE,
      quietly = TRUE,
      warn.conflicts = FALSE
    )
  )
)

# Keep the static renv manifest in step with the configured packages
save_package_dependencies_manifest(
  vec_package_names = c(vec_packages_attach, vec_packages_tools),
  path_output_file = here::here("R", "package_dependencies.R")
)


#----------------------------------------------------------#
# 3. Define options -----
#----------------------------------------------------------#

config_seed <-
  load_config_value(value = "seed")

base::set.seed(config_seed)

graphical_options <-
  load_config_value(value = "graphical")

ggplot2::theme_set(
  ggplot2::theme_classic(
    base_size = purrr::chuck(graphical_options, "text_size")
  )
)


#----------------------------------------------------------#
# 4. Resolve data storage -----
#----------------------------------------------------------#

# Large inputs and target stores live under this root. Set a machine-local
#   root in the git-ignored `secrets.yaml` (see `secrets_example.yaml`).
path_data_storage <-
  resolve_data_storage_path(
    path_default = load_config_value(value = "data_storage_path")
  )

# Abort rather than warn: a mistyped root would otherwise make {targets}
#   build new stores in the wrong place
if (
  isFALSE(base::dir.exists(path_data_storage))
) {
  cli::cli_abort(
    c(
      "The data root does not exist: {.path {path_data_storage}}",
      "i" = "Create it or correct {.file secrets.yaml}."
    )
  )
}
