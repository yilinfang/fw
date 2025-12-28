# fw - File Selector and Combiner

`fw` is a lightweight command-line tool that allows users to interactively select files from a directory or piped input using `fzf`, preview their contents, and combine them into a single output file.

## Features

- **Interactive File Selection**: Use `fzf` to interactively select multiple files.
- **Customizable Preview**: Preview file contents with `bat` or a custom preview command.
- **File Combination**: Combine selected files into a single output file with clear separators.
- **Directory Scanning**: Search for files using `fd` or `ripgrep` with options to include hidden files or ignore `.gitignore` rules.
- **Piped Input Support**: Accept file lists from piped input for maximum flexibility.
- **Temporary or Custom Output**: Save the combined output to a temporary file or a user-specified file path.
- **Editor Integration**: Automatically open the combined file in your preferred editor (`$EDITOR`, `$VISUAL`, or `vi`).

## Installation

### Prerequisites

Make sure the following tools are installed on your system:

- [`python3`](https://www.python.org/)
- [`fzf`](https://github.com/junegunn/fzf)
- [`fd`](https://github.com/sharkdp/fd) or [`ripgrep`](https://github.com/BurntSushi/ripgrep) (optional)
- [`bat`](https://github.com/sharkdp/bat) (optional)

### Using `mise` (recommended)

```bash
mise use github:yilinfang/fw
# Or if you want to install it globally
mise use -g github:yilinfang/fw
```

### Manual Installation

1. Download the latest `fw` from [Releases](https://github.com/yilinfang/fw/releases).

2. Unarchive the downloaded file and make `fw` executable.

3. Move `fw` file to a directory in your `$PATH` (e.g., `/usr/local/bin`).

## Usage

### Basic Syntax

```bash
fw [directory] [--hidden] [--no-ignore] [--output OUTPUT]
```

### Examples

#### Select Files from the Current Directory

```bash
fw
```

#### Select Files from a Specific Directory

```bash
fw ~/Workspace
```

#### Include Hidden Files

```bash
fw ~/Workspace --hidden
```

#### Ignore `.gitignore` Rules

```bash
fw ~/Workspace --no-ignore
```

#### Specify an Output File

```bash
fw ~/Workspace --output combined.txt
```

#### Use Piped Input

**When using the Piped Input, the `--hidden` and `--no-ignore` will be ignored.**

```bash
find ~/Workspace -type f | fw
```

## Environment Variables

### `$FW_PREVIEW_CMD`

Set a custom preview command for `fzf`. By default, `fw` uses:

```bash
bat --color=always --paging=never --style=plain --line-range=:150 {}
```

Example:

```bash
export FW_PREVIEW_CMD="cat {}"
```

### `$EDITOR` or `$VISUAL`

Set your preferred text editor to open the combined output file. If not set, `fw` falls back to `vi`.

## Output Format

The combined output file contains clear separators between files for easy navigation:

```txt
<<< START OF FILE: file1.txt >>>
<contents of file1.txt>
<<< END OF FILE: file1.txt >>>

<<< START OF FILE: file2.txt >>>
<contents of file2.txt>
<<< END OF FILE: file2.txt >>>
```

## Acknowledgements

- [`fzf`](https://github.com/junegunn/fzf) for its amazing fuzzy finding capabilities.
- [`fd`](https://github.com/sharkdp/fd) and [`ripgrep`](https://github.com/BurntSushi/ripgrep) for their fast and user-friendly file searching.
- [`bat`](https://github.com/sharkdp/bat) for making file previews beautiful.
