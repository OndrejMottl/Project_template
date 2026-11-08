#----------------------------------------------------------#
#
#
#                     Project name
#
#                Run stage 02: main analyses
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Builds every pipeline of the main analyses stage. Requires the stores of
#   stage 01 (`R/Analyses/01_Data_preparation/00_run.R`).


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
  script = here::here("R/Analyses/02_Main_analyses/pipeline.R"),
  store = resolve_pipeline_store_path(
    path_data_storage = path_data_storage,
    store_relative_path = "main_analyses"
  ),
  visualise = flag_visualise_pipeline
)
