#----------------------------------------------------------#
#
#
#                     Project name
#
#                     Project init
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Prepare the reproducible R environment. Run once per checkout from the
#   project root in a fresh session:
#     Rscript R/___Init_project___.R
# - With `renv.lock` present, the exact locked versions are restored.
# - Without it (a new project created from the template), the packages
#     listed in `config.yml` and all packages used in the code are
#     installed and the first lockfile is written.
# Later snapshots are a separate, deliberate maintenance step.
# This script uses base R only (plus renv), because it must run before any
#   project package is installed.


#----------------------------------------------------------#
# 0. Bootstrap renv -----
#----------------------------------------------------------#

if (
  isFALSE(requireNamespace("renv", quietly = TRUE))
) {
  message("Package {renv} is not installed; installing it from CRAN.")

  utils::install.packages(pkgs = "renv")
}

if (
  isFALSE(requireNamespace("renv", quietly = TRUE))
) {
  stop(
    "Package {renv} could not be installed; setup cannot continue.",
    call. = FALSE
  )
}


#----------------------------------------------------------#
# 1. Locate the project -----
#----------------------------------------------------------#

path_project <-
  normalizePath(
    path = ".",
    winslash = "/",
    mustWork = TRUE
  )

path_config <-
  file.path(path_project, "config.yml")

path_lockfile <-
  file.path(path_project, "renv.lock")

if (
  isFALSE(file.exists(path_config))
) {
  stop(
    "No config.yml in ",
    path_project,
    ". Run this script from the project root.",
    call. = FALSE
  )
}


#----------------------------------------------------------#
# 2. Restore an existing project -----
#----------------------------------------------------------#

if (
  isTRUE(file.exists(path_lockfile))
) {
  message("Lockfile found; restoring the locked package versions.")

  renv::restore(
    project = path_project,
    lockfile = path_lockfile,
    prompt = FALSE
  )

  message("Setup complete. Start scripts with R/___setup_project___.R.")
}


#----------------------------------------------------------#
# 3. Initialise a new project -----
#----------------------------------------------------------#

if (
  isFALSE(file.exists(path_lockfile))
) {
  message("No lockfile found; installing packages for a new project.")

  renv::install(
    packages = "yaml",
    project = path_project,
    prompt = FALSE
  )

  # Packages are defined once, in the `default` profile; other profiles
  #   should not override them
  list_packages <-
    yaml::read_yaml(file = path_config)[["default"]][["packages"]]

  vec_packages_config <-
    unlist(list_packages, use.names = FALSE)

  renv::install(
    packages = vec_packages_config,
    project = path_project,
    prompt = FALSE
  )

  # Install every other package called in the project code (pkg::fun)
  renv::install(
    project = path_project,
    prompt = FALSE
  )

  # Sourcing the setup checks that it runs and writes the package manifest
  #   that the snapshot needs
  source(
    file.path(path_project, "R", "___setup_project___.R")
  )

  renv::snapshot(
    project = path_project,
    prompt = FALSE
  )

  message("Setup complete; renv.lock written. Commit it with the project.")
}
