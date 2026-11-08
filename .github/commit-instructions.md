# Commit message instructions

- One line only: no body, no trailing period, at most 72 characters.
- Format: `<subject>: <summary>`.
- Subject: a function as `name()`; a pipeline, stage, or script by its name; several files by a plain topic; non-code changes by a label: `renv`, `config`, `docs`, `tests`, `refactor`, `data`, `ci`, `chore`, `agents` (for `AGENTS.md`, `.ai/`, and adapter files).
- Summary: starts with a specific verb (add, correct, remove, update, switch, adjust, replace, rename) and describes the durable outcome, never a plan label such as `Phase 1`.
- Never use the words enhance, feat, feature, or fix.
- No issue or PR numbers (`#12`, `Issue 12`, `PR 12`); issue links belong in the PR description.
- No `Co-Authored-By` or "Generated with" trailers.

Examples:

- `summarise_example_data(): drop groups below minimum size`
- `Data preparation: add pollen harmonisation pipeline`
- `renv: update lockfile after targets upgrade`
- `docs: describe secrets.yaml setup`
