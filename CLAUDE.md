# fw

Single-file Python CLI tool that interactively selects files via `fzf` and combines them into a single output for pasting into AI assistants.

## Architecture

- `fw` — Single 331-line Python 3 executable script. No modules, no packages.
- `install.sh` — Installation helper script.

## Conventions

- Python 3.6+ compatibility required.
- Standard library only — no third-party dependencies.
- External tool dependency chain: `fzf` (required), `bat` (optional, for preview).
- CLI argument parsing via `argparse`.

## Build / Test / Lint

No build step, no test suite, no linter configuration. The script is run directly as `fw`.
