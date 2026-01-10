# fw — File Selector and Combiner

> **Quickly select and combine files into context for ChatGPT, Claude, and other LLMs.**

[![Python 3.6+](https://img.shields.io/badge/python-3.6+-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/yilinfang/fw)](https://github.com/yilinfang/fw/releases)

## Why fw?

When working with AI assistants like ChatGPT or Claude, you often need to share multiple source files as context. Manually copying and pasting each file is tedious and error-prone. `fw` solves this by letting you:

1. **Interactively browse and select** files with fuzzy search (`fzf`)
2. **Preview file contents** before selecting
3. **Combine them into a single file** with clear separators
4. **Open in your editor** to review/copy the result

The output format uses clear `<<< START OF FILE >>>` / `<<< END OF FILE >>>` markers that AI assistants can easily parse and understand.

## Features

- **Interactive File Selection** — Use `fzf` to fuzzy-search and multi-select files
- **Live Preview** — Preview file contents with `bat` (with syntax highlighting) or `cat`
- **Smart File Discovery** — Automatically uses `fd`, `ripgrep`, or `find` (whichever is available)
- **Respects .gitignore** — Skips ignored files by default (override with `-I`)
- **Hidden Files Support** — Include dotfiles with `-H`
- **Piped Input** — Works with `find`, `rg`, or any command that outputs file paths
- **Editor Integration** — Opens combined output in `$EDITOR` for easy copying

## Installation

### Prerequisites

- [`python3`](https://www.python.org/) (3.6+)
- [`fzf`](https://github.com/junegunn/fzf) (required)
- [`fd`](https://github.com/sharkdp/fd) or [`ripgrep`](https://github.com/BurntSushi/ripgrep) (optional, faster file listing)
- [`bat`](https://github.com/sharkdp/bat) (optional, syntax-highlighted previews)

### One-line Installation (recommended)

You can install `fw` to `~/.local/bin` by running following command:

```bash
curl -fsSL https://raw.githubusercontent.com/yilinfang/fw/main/install.sh | bash
```

To install to a different location, set the `FW_INSTALL_DIR` variable:

```bash
FW_INSTALL_DIR=/path/to/bin bash -c "$(curl -fsSL https://raw.githubusercontent.com/yilinfang/fw/main/install.sh)"
```

### Using mise

```bash
mise use github:yilinfang/fw
# Or install globally
mise use -g github:yilinfang/fw
```

### Manual Installation

1. Download the latest `fw` from [Releases](https://github.com/yilinfang/fw/releases)
2. Make it executable: `chmod +x fw`
3. Move to a directory in your `$PATH` (e.g., `/usr/local/bin/`)

## Usage

```bash
fw [directory] [options]
```

### Options

| Option              | Description                            |
| ------------------- | -------------------------------------- |
| `-H, --hidden`      | Include hidden files                   |
| `-I, --no-ignore`   | Ignore .gitignore rules                |
| `-O, --output FILE` | Save to specific output file           |
| `-v, --verbose`     | Show verbose output (file count, size) |
| `-V, --version`     | Show version and exit                  |

### Examples

```bash
# Select files from current directory
fw

# Select files from a specific directory
fw ~/project

# Include hidden files
fw -H

# Ignore .gitignore rules
fw -I

# Save to a specific file
fw -O context.txt

# Use with piped input
find . -name "*.py" | fw
rg --files -g "*.ts" | fw
```

## Environment Variables

| Variable            | Description                                              |
| ------------------- | -------------------------------------------------------- |
| `FW_PREVIEW_CMD`    | Custom preview command for fzf (default: `bat` or `cat`) |
| `EDITOR` / `VISUAL` | Editor to open the combined file (default: `vi`)         |

Example custom preview:

```bash
export FW_PREVIEW_CMD="head -n 100 {}"
```

## Output Format

The combined output uses clear markers for easy parsing:

```
<<< START OF FILE: src/main.py >>>
<contents of main.py>
<<< END OF FILE: src/main.py >>>

<<< START OF FILE: src/utils.py >>>
<contents of utils.py>
<<< END OF FILE: src/utils.py >>>
```

## Acknowledgements

- [fzf](https://github.com/junegunn/fzf) — Fuzzy finder
- [fd](https://github.com/sharkdp/fd) & [ripgrep](https://github.com/BurntSushi/ripgrep) — Fast file finder
- [bat](https://github.com/sharkdp/bat) — Better previewer

## License

MIT
