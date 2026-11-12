#----------------------------------------------------------#
#
#
#                     Project name
#
#                  Main analyses pipeline
#
#
#                       O. Mottl
#                         2026
#
#----------------------------------------------------------#
# Defines the main analyses target graph.
# Run with:
#   R/Analyses/02_Main_analyses/00_run.R
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

min_n_records <-
  load_config_value(value = c("example", "min_n_records"))


#----------------------------------------------------------#
# 1. Upstream contract -----
#----------------------------------------------------------#

# Only these public targets of the upstream store are imported
vec_public_targets_data_preparation <- "data_prepared"

store_data_preparation <-
  resolve_pipeline_store_path(
    path_data_storage = path_data_storage,
    store_relative_path = "data_preparation"
  )

runner_data_preparation <- "R/Analyses/01_Data_preparation/00_run.R"


#----------------------------------------------------------#
# 2. Define targets -----
#----------------------------------------------------------#

list(
  # Fingerprint the upstream public targets so that a change upstream
  #   invalidates the import below; the check itself is cheap metadata.
  targets::tar_target(
    name = "fingerprint_data_preparation",
    command = compute_target_store_fingerprint(
      store = store_data_preparation,
      target_names = vec_public_targets_data_preparation,
      runner = runner_data_preparation
    ),
    cue = targets::tar_cue(mode = "always")
  ),
  # Import the prepared data once; it reruns only when the fingerprint
  #   changes. Referencing the fingerprint creates that dependency.
  targets::tar_target(
    name = "data_prepared",
    command = {
      fingerprint_data_preparation

      load_target_store_value(
        store = store_data_preparation,
        target_name = "data_prepared",
        runner = runner_data_preparation
      )
    }
  ),
  # Example result table, using the configured minimum group size.
  targets::tar_target(
    name = "table_species_summary",
    command = summarise_example_data(
      data_input = data_prepared,
      group_var = species,
      value_var = petal_length,
      min_n_records = min_n_records
    )
  )
)
