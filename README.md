# Project template

Template for reproducible R research projects: `{renv}` for packages, `{targets}` pipelines grouped into numbered analysis stages, configuration in `config.yml`, one function per file with `{testthat}` tests, and instruction files for coding assistants.

## Structure

```text
├─ .ai/                         canonical assistant guidance (see AGENTS.md)
├─ .github/                     Copilot adapters, commit instructions, PR template
├─ Data/
│   ├─ Input/                   raw inputs
│   ├─ Processed/               processed data saved outside {targets}
│   ├─ Temp/                    disposable scratch files (git-ignored)
│   └─ Targets_data/            one {targets} store per pipeline (git-ignored)
├─ Outputs/
│   ├─ Data/
│   ├─ Figures/
│   └─ Tables/
├─ R/
│   ├─ ___Init_project___.R     restore or initialise the R environment
│   ├─ ___setup_project___.R    shared setup sourced by every script
│   ├─ package_dependencies.R   generated package manifest for {renv}
│   ├─ Analyses/
│   │   ├─ 00_run_main.R        run all stages in order
│   │   ├─ 01_Data_preparation/ 00_run.R + pipeline.R
│   │   └─ 02_Main_analyses/    00_run.R + pipeline.R
│   ├─ Functions/               one function per file, grouped by area
│   └─ Tests/
│       ├─ Run_tests.R          full test suite
│       └─ testthat/            test-<function_name>.R
├─ renv/
├─ AGENTS.md                    entry point for coding assistants
├─ CLAUDE.md, GEMINI.md         redirects to AGENTS.md
├─ config.yml                   project configuration
├─ secrets_example.yaml         template for the machine-local secrets.yaml
├─ [project name].Rproj
└─ README.md
```

The layout and its rules are described in [.ai/analysis-structure.md](.ai/analysis-structure.md).

## Starting a new project from the template

1. Create a repository from this template on GitHub (**Use this template**) and clone it.
2. Rename `Project_template.Rproj`, and replace "Project name" in the script headers, `AGENTS.md`, and this README.
3. Run `Rscript R/___Init_project___.R` from the project root. Without a lockfile, it installs the packages listed in `config.yml` and those used in the code, then writes the first `renv.lock`. Commit the lockfile.
4. Run `Rscript R/Tests/Run_tests.R` and `Rscript R/Analyses/00_run_main.R` to check that everything works.
5. Replace the example functions in `R/Functions/Example/`, their tests, and the example targets with the project's own.

## Getting the code of an existing project

Clone the repository, or download the latest release as a zip file. Then run `Rscript R/___Init_project___.R` from the project root, which restores the exact package versions in `renv.lock`.

## Running the project

- **All stages:** `Rscript R/Analyses/00_run_main.R`.
- **One stage:** `Rscript R/Analyses/<NN>_<Stage>/00_run.R`.
- Up-to-date targets are skipped. Each pipeline keeps its own store in `<data root>/Targets_data/`.
- **Inspect results:** `targets::tar_read(<target>, store = <store path>)`, or set `flag_visualise_pipeline <- TRUE` in a stage runner to see the dependency graph.

## Configuration

- **`config.yml`** holds the seed, thresholds, graphical options, and package lists. Read values with `load_config_value(value = c("graphical", "width"))`. Add profiles that inherit from `default` and select one with the `R_CONFIG_ACTIVE` environment variable.
- **`secrets.yaml`** is git-ignored and holds machine-local values. Copy `secrets_example.yaml` to `secrets.yaml` and set `Data:` to keep large inputs and target stores outside the repository, for example on a shared drive. Without it, `Data/` in the project is used.

## Functions and tests

- **Files:** each function lives in its own file in `R/Functions/<Area>/`, named after the function, with a roxygen2 block. Each has a test file `R/Tests/testthat/test-<function_name>.R`, written before the implementation.
- **Full suite:** `Rscript R/Tests/Run_tests.R` checks the one-function-per-file contract and runs the suite in a clean R subprocess.
- **Focused run:** source `R/___setup_project___.R`, then `run_test_file(test_file = here::here("R/Tests/testthat/test-<function_name>.R"))`.

## Packages

Packages are managed with [`{renv}`](https://rstudio.github.io/renv/):

1. Install new packages with `renv::install()`.
2. List them under `packages` in `config.yml`, unless they are only called as `pkg::fun()`.
3. Record the change deliberately with `renv::snapshot()`.

Never edit `renv.lock` by hand.

## Coding assistants

`AGENTS.md` is the entry point for coding assistants (Codex, Claude Code, Gemini, Copilot). It routes tasks to the project guidance in `.ai/`. The general R, git, and writing conventions come from each user's own assistant instructions; `.ai/` holds only what is specific to the project.
