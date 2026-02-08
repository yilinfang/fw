# fw

Single-file Python 3 CLI tool. Interactively selects files via `fzf`/`sk` and combines them into a single output for AI assistants.

## Architecture

- `fw` — Single executable Python script (`#!/usr/bin/env python3`). No modules, no packages.
- `install.sh` — Bash installation helper.

## Conventions

- Python 3.6+ compatibility required.
- Standard library only — no third-party dependencies.
- External tools: `fzf` or `sk` (required), `bat` (optional preview).
- CLI parsing via `argparse`; type hints from `typing`.
- Commit messages: Conventional Commits (`feat:`, `fix:`, `chore:`, etc.).

## Testing

No automated test suite. Verify changes manually:

```sh
./fw --help
./fw --version
./fw              # interactive selection via fzf/sk
```
