# Analysis structure

The project layout is a contract. Change it deliberately, update this file in the same change, and check every caller.

## Layout

```text
config.yml                 project configuration, read via load_config_value()
secrets.yaml               git-ignored machine-local values (see secrets_example.yaml)
Data/
  Input/                   raw inputs (not modified by code)
  Processed/               processed data saved outside {targets}
  Temp/                    disposable scratch and debug scripts (git-ignored)
  Targets_data/            one {targets} store per pipeline (git-ignored)
Outputs/
  Data/, Figures/, Tables/ final outputs, organised by the analysis that made them
R/
  ___Init_project___.R     one-time environment restore or initialisation
  ___setup_project___.R    shared setup sourced by every script and pipeline
  package_dependencies.R   generated; do not edit
  Functions/<Area>/        one function per file, named after the function
  Analyses/
    00_run_main.R          runs every stage runner in order
    <NN>_<Stage>/
      00_run.R             runs the pipelines of the stage
      pipeline.R           declares one target graph (or <Operation>/pipeline.R)
  Tests/
    Run_tests.R            full suite runner
    testthat/test-<function_name>.R
```

## Stages and pipelines

- A stage is a numbered folder under `R/Analyses/` for one scientific operation (data preparation, a hypothesis, a model family, visualisation, reporting). Numbers give the run order. Use `90_` and above for diagnostics and sensitivity analyses outside the main chain.
- Each stage has a `00_run.R` that sources the setup and calls `run_target_pipeline()` for each of its pipelines. `00_run_main.R` sources the stage runners in order; add each new stage runner to its list.
- A `pipeline.R` only declares targets. It sources the setup, sets `targets::tar_option_set(seed = config_seed)`, and returns a list of targets. Sourcing it never builds targets (the setup it sources may still refresh `R/package_dependencies.R`).
- Each pipeline owns one store, resolved with `resolve_pipeline_store_path()` under `<data root>/Targets_data/`. Never share a store between pipelines.
- Target names are quoted strings. Each target has a `# Why:` comment saying what it provides and why it is in the graph.
- When a target command is more than one function call, move the logic into a function in `R/Functions/`. The upstream-import target is the one exception (see below).

## Cross-pipeline contracts

- A downstream pipeline imports only public targets of an upstream store. List them in the pipeline's "Upstream contract" section, together with the upstream runner.
- Import pattern: a `fingerprint_<stage>` target calls `compute_target_store_fingerprint()` with `cue = targets::tar_cue(mode = "always")`, and the import target references the fingerprint and calls `load_target_store_value()`. The import then reruns only when an upstream public target changes.
- A missing upstream store or target is an error that names the runner to execute first (`validate_target_store_contract()`). It never silently triggers an expensive rebuild.
- Renaming or removing a public target is a contract change: search all downstream pipelines first.

## Configuration

- Analysis values (seed, thresholds, graphical options, package lists) live in `config.yml` and are read only through `load_config_value()`. Do not call `config::get()` directly.
- Profiles other than `default` are selected with `R_CONFIG_ACTIVE` and inherit from `default`.
- The data root comes from `resolve_data_storage_path()`: `secrets.yaml` (`Data:` key) if present, otherwise `data_storage_path` in `config.yml`.

## Setup and packages

- Every stage runner, pipeline, and test run starts with `library(here)` and `source(here::here("R/___setup_project___.R"))`. `00_run_main.R` relies on the stage runners for this.
- The setup aborts if the data root does not exist, so a mistyped `secrets.yaml` never creates stores in the wrong place.
- The setup loads every file in `R/Functions/`, attaches `packages: attach` from `config.yml`, regenerates `R/package_dependencies.R`, sets the seed and ggplot theme, and resolves `path_data_storage`.
- Add a package by listing it in `config.yml` (attach or tools) or by calling it as `pkg::fun()`, then install it with `renv::install()` and snapshot deliberately.

## Tests

- Every function in `R/Functions/` has `R/Tests/testthat/test-<function_name>.R`. Shared fixtures go in `helper-*.R` files.
- `Rscript R/Tests/Run_tests.R` validates the function files (`validate_function_names()`) and runs the suite in a clean subprocess (`run_project_tests()`).
- Focused run: source the setup, then `run_test_file(test_file = ...)`.

## Template examples

`R/Functions/Example/`, their tests, and the example targets (`data_raw`, `data_prepared`, `table_species_summary`) only demonstrate the pattern. Replace them when the project starts.
