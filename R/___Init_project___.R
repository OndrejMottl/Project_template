#----------------------------------------------------------#
#
#
#                     Project name
#
#                     Project setup
#
#
#                       O. Mottl
#                         2023
#
#----------------------------------------------------------#

# Script to prepare all components of the environment to run the Project.
#   Needs to be run only once

#----------------------------------------------------------#
# Step 0: Install {renv} for package management -----
#----------------------------------------------------------#

if (
  "renv" %in% utils::installed.packages()
) {
  library(renv)
} else {
  # install package
  utils::install.packages("renv")

  # load the package
  library(renv)
}

#----------------------------------------------------------#
# Step 1: Activate 'renv' project -----
#----------------------------------------------------------#

# NOTE: The R may ask the User to restart the session (R).
#   After that, continue with the next step

renv::activate()

#----------------------------------------------------------#
# Step 1: Install {here} for file navigation -----
#----------------------------------------------------------#

if (
  "here" %in% utils::installed.packages()
) {
  library(here)
} else {
  # install package
  utils::install.packages("here")

  # load the package
  library(here)
}

#----------------------------------------------------------#
# Step 2: Synchronize package versions with the project -----
#----------------------------------------------------------#

# If there is no lock file present make a new snapshot
if (
  isTRUE("library_list.lock" %in% list.files(here::here("renv")))
) {
  cat("The project already has a lockfile. Restoring packages", "\n")

  renv::restore(
    lockfile = here::here("renv/library_list.lock")
  )

  cat("Set up completed. You can continute to run the project", "\n")

  cat("Do NOT run the rest of this script", "\n")
} else {
  cat("The project seems to be new (no lockfile)", "\n")

  cat("Continue with this script", "\n")
}

#----------------------------------------------------------#
# Step 3: Install packages to the project -----
#----------------------------------------------------------#

# install all packages in the lst from CRAN
sapply(
  c(
    "assertthat",
    "devtools",
    "here",
    "httpgd",
    "janitor",
    "jsonlite",
    "knitr",
    "languageserver",
    "lifecycle",
    "renv",
    "remotes",
    "rlang",
    "roxygen2",
    "tidyverse",
    "usethis",
    "utils"
  ),
  utils::install.packages,
  character.only = TRUE
)

# install RUtilpol from GitHub
remotes::install_github(
  repo = "HOPE-UIB-BIO/R-Utilpol-package",
  ref = "HEAD",
  quiet = FALSE,
  upgrade = "ask"
)

#----------------------------------------------------------#
# Step 4: Save versions of packages -----
#----------------------------------------------------------#

renv::snapshot(
  lockfile = here::here("renv/library_list.lock")
)

cat("Set up completed. You can continute to run the project", "\n")
