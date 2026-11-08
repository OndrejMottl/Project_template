# Debugging: project-specific rules

The general debugging workflow (reproduce in a throwaway script, run it with `Rscript` in a clean session, minimal fix, then focused test, full suite, and smoke check) is in the user-level instructions. Add here only what this project defines differently or additionally.

## Commands

- Throwaway reproductions: `Data/Temp/debug_<topic>.R` (git-ignored).
- Focused test: source `R/___setup_project___.R`, then `run_test_file(test_file = here::here("R/Tests/testthat/test-<function_name>.R"))`.
- Full suite: `Rscript R/Tests/Run_tests.R`.
- Smoke check: `Rscript R/Analyses/<NN>_<Stage>/00_run.R` for the affected stage. A successful run ends with `ended pipeline` (or `skipped pipeline`) and contains no `ERROR` or `errored target`.

## Known pitfalls

<!-- Project-specific traps worth recording. -->
