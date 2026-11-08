# R functions: project-specific rules

The general function conventions (contract first, TDD, one function per file, verb contract, roxygen2, `assertthat` and `cli` checks, `verbose`) are in the user-level instructions. Add here only what this project defines differently or additionally, and delete headings that stay empty.

## Function areas

Functions live in `R/Functions/<Area>/`, grouped by analytical responsibility. `Workflow/` holds the project infrastructure (configuration, stores, tests); `Example/` is template material to replace.

<!-- List the project's areas and what each owns. -->

## Approved verbs

The verb list is enforced by `validate_function_names()`. <!-- Record project additions to the verb list and why. -->

## Test fixtures

<!-- Shared `helper-*.R` fixtures and what they build. -->
