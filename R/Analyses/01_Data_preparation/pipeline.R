#----------------------------------------------------------#
#
#
#                     Project name
#
#                Data preparation pipeline
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Defines the data preparation target graph.
# Run with:
#   R/Analyses/01_Data_preparation/00_run.R
# Sourcing this script only declares targets; it does not execute them.


#----------------------------------------------------------#
# 0. Configure pipeline -----
#----------------------------------------------------------#

library(here)

source(
  here::here("R/___setup_project___.R")
)

targets::tar_option_set(
  seed = config_seed
)


#----------------------------------------------------------#
# 1. Define targets -----
#----------------------------------------------------------#

list(
  # Why: Example raw input. Replace with the project's raw data, e.g. a
  #   `format = "file"` target on a file in `Data/Input/`.
  targets::tar_target(
    name = "data_raw",
    command = tibble::as_tibble(datasets::iris)
  ),
  # Why: Public target with clean column names, imported by later stages.
  targets::tar_target(
    name = "data_prepared",
    command = prepare_example_data(data_raw = data_raw)
  )
)
