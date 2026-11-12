# Review checklist

Use this when reviewing changed files, together with the general conventions in the user-level instructions. An independent review is done by a separate read-only reviewer (`agents/changes-reviewer.agent.md`); a self-review does not count. If no reviewer is available, say the review was not completed.

## General

- The change does what was asked and nothing unrelated.
- Validation that was claimed was actually run; anything not run is reported.

## Structure contracts (`analysis-structure.md`)

- New functions: one per file, matching name, roxygen2 block, matching test file, approved verb.
- Pipelines: quoted target names, a plain comment above each target saying what it provides and why (no `Why:` label), own store, imports only public upstream targets.
- Configuration read only through `load_config_value()`; no hardcoded paths, seeds, or thresholds.
- Renamed targets, stores, or config keys: all downstream users updated.

## Project-specific checks

<!-- Add checks specific to this project. -->
