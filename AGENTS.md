# Project name: agent guide

This file is the universal entry point for coding assistants working in this repository. Canonical project guidance lives in `.ai/`; this file routes tasks to it. Replace "Project name" and add project-specific routes as the project grows.

## Precedence

1. The user's current request.
2. This file and the project files in `.ai/`.
3. The user-level instructions of the assistant (for example `~/.claude/CLAUDE.md`), which hold the general R, git, and writing conventions.
4. Defaults.

Project rules override the general ones wherever they conflict. The `.ai/` files hold only what is specific to this project; do not copy general conventions into them.

## Required reading

| Task | Read first |
| --- | --- |
| Any repository work | `AGENTS.md`, `.ai/analysis-structure.md` |
| R scripts, pipelines, configuration, `{renv}` | `.ai/r-coding.md`, `.ai/analysis-structure.md` |
| Creating, renaming, documenting, or testing R functions | `.ai/r-functions.md` |
| Git, branches, worktrees, commits, pull requests | `.ai/git-workflow.md`, then `.github/commit-instructions.md` for commit messages |
| Debugging or bug fixes | `.ai/debugging.md` |
| Reviewing changed files | `.ai/review-checklist.md` |
| Reusable agent prompts (independent review, planning) | `.ai/agents/changes-reviewer.agent.md`, `.ai/agents/plan-large-changes.agent.md` |

## Key commands

Run from the project root in a fresh session; judge success from the output text, not the exit code.

| Purpose | Command |
| --- | --- |
| Restore or initialise the R environment | `Rscript R/___Init_project___.R` |
| Run the full test suite | `Rscript R/Tests/Run_tests.R` |
| Run all analysis stages | `Rscript R/Analyses/00_run_main.R` |
| Run one stage | `Rscript R/Analyses/<NN>_<Stage>/00_run.R` |

## Tool adapters

| Tool | Entry file |
| --- | --- |
| Codex and other `AGENTS.md`-aware tools | `AGENTS.md` |
| Claude Code | `CLAUDE.md` -> `AGENTS.md` |
| Gemini | `GEMINI.md` -> `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md` by `applyTo` |

Adapters stay short and only point to `AGENTS.md` and `.ai/`. Never put substantive guidance in an adapter. Do not add a new adapter unless a real tool or collaborator needs it.

## Markdown source formatting

The 80-character limit applies only to R code, R comments, and roxygen2 lines. Never hard-wrap prose in Markdown, README, instruction files, or GitHub text; keep each paragraph and list item on one source line. In `.qmd` files, write one sentence per line.

## Private material

Keep private material (co-author correspondence, contact details, personal circumstances, unpublished data under embargo) inside the repository in a git-ignored `Private/` folder, never in tracked files and never outside the project. `Data/Temp/` is disposable and must not hold anything worth keeping.
