#----------------------------------------------------------#
#
#
#                     Project name
#
#                    Run all stages
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Runs the stage runners in order. Each stage builds its pipelines in their
#   own stores; up-to-date targets are skipped. Each runner sources the
#   project setup itself. Add every new stage runner to the list below.
# Run with:
#   Rscript R/Analyses/00_run_main.R


#----------------------------------------------------------#
# 0. Setup -----
#----------------------------------------------------------#

library(here)

vec_stage_runners <-
  c(
    "R/Analyses/01_Data_preparation/00_run.R",
    "R/Analyses/02_Main_analyses/00_run.R"
  )


#----------------------------------------------------------#
# 1. Run stages -----
#----------------------------------------------------------#

purrr::walk(
  .x = vec_stage_runners,
  .f = ~ base::source(
    file = here::here(.x)
  )
)
