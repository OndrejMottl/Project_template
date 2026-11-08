#----------------------------------------------------------#
#
#
#                     Project name
#
#                Run stage 01: data preparation
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Builds every pipeline of the data preparation stage, each in its own
#   store under `<data root>/Targets_data/`.


#----------------------------------------------------------#
# 0. Setup -----
#----------------------------------------------------------#

library(here)

source(
  here::here("R/___setup_project___.R")
)

flag_visualise_pipeline <- FALSE


#----------------------------------------------------------#
# 1. Run pipelines -----
#----------------------------------------------------------#

run_target_pipeline(
  script = here::here("R/Analyses/01_Data_preparation/pipeline.R"),
  store = resolve_pipeline_store_path(
    path_data_storage = path_data_storage,
    store_relative_path = "data_preparation"
  ),
  visualise = flag_visualise_pipeline
)
