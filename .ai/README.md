# `.ai/`: canonical assistant guidance

This folder holds the project-specific guidance for coding assistants, written in plain Markdown so that any tool can read it. `AGENTS.md` at the repository root routes tasks to these files.

- `analysis-structure.md` describes the project layout and its contracts. Keep it in step with the code.
- The other files are skeletons. Add rules only where this project differs from, or adds to, the general conventions in the user-level instructions. Delete a heading that stays empty.
- `agents/` holds reusable, tool-independent prompts (independent review, planning).

Tool adapters (`CLAUDE.md`, `GEMINI.md`, `.github/copilot-instructions.md`, `.github/instructions/`) only point here. When guidance changes, edit the file in `.ai/` first, then check that every adapter pointer still resolves.
