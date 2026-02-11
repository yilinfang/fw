#!/usr/bin/env bash

# install.sh - Installation script for fw (File Selector and Combiner)
# Usage: bash install.sh
# Or: FW_INSTALL_DIR=/path/to/bin bash install.sh

set -euo pipefail

# --- Uninstall Mode ---
if [ "${1:-}" = "--uninstall" ]; then
	INSTALL_DIR="${FW_INSTALL_DIR:-$HOME/.local/bin}"
	TARGET="$INSTALL_DIR/fw"
	if [ -f "$TARGET" ]; then
		rm "$TARGET"
		echo -e "\033[0;32msuccess:\033[0m fw has been removed from $TARGET"
	else
		echo -e "\033[1;33mwarn:\033[0m fw not found at $TARGET"
	fi
	exit 0
fi

# --- Configuration ---
REPO="yilinfang/fw"
BINARY_NAME="fw"
DEFAULT_INSTALL_DIR="$HOME/.local/bin"
GITHUB_API="https://api.github.com/repos/$REPO/releases/latest"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${BLUE}info:${NC} $1"; }
warn() { echo -e "${YELLOW}warn:${NC} $1"; }
error() {
	echo -e "${RED}error:${NC} $1"
	exit 1
}
success() { echo -e "${GREEN}success:${NC} $1"; }

# --- Dependency Checks ---
info "Checking dependencies..."

if ! command -v python3 >/dev/null 2>&1; then
	error "python3 is required but not found. Please install Python 3.6+."
fi

if ! command -v fzf >/dev/null 2>&1 && ! command -v sk >/dev/null 2>&1; then
	warn "Neither fzf nor sk (skim) is found. 'fw' requires one of them to run interactively."
	info "Install fzf from: https://github.com/junegunn/fzf"
	info "Or skim from: https://github.com/skim-rs/skim"
fi

# --- Installation Directory ---
INSTALL_DIR="${FW_INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
TARGET="$INSTALL_DIR/$BINARY_NAME"
mkdir -p "$INSTALL_DIR"

# --- Detect fetch tool ---
if command -v curl >/dev/null 2>&1; then
	fetch() { curl -fsSL "$1"; }
elif command -v wget >/dev/null 2>&1; then
	fetch() { wget -qO- "$1"; }
else
	error "Neither curl nor wget found. Please install one of them."
fi

# --- Get Latest Release (use python3 for robust JSON parsing) ---
info "Fetching latest release information for $REPO..."
LATEST_RELEASE=$(fetch "$GITHUB_API" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])" 2>/dev/null) || true

if [ -z "$LATEST_RELEASE" ]; then
	error "Could not determine the latest release version."
fi

info "Latest release: $LATEST_RELEASE"

# --- Version Comparison (target path only) ---
if [ -x "$TARGET" ]; then
	CURRENT_VERSION=$("$TARGET" --version 2>/dev/null | awk '{print $NF}') || true
	LATEST_RELEASE_CLEAN="${LATEST_RELEASE#v}"
	if [ -n "$CURRENT_VERSION" ] && [ "$CURRENT_VERSION" = "$LATEST_RELEASE_CLEAN" ]; then
		success "fw is already up to date at $TARGET ($CURRENT_VERSION)."
		exit 0
	fi
	if [ -n "$CURRENT_VERSION" ]; then
		info "Upgrading fw at $TARGET from $CURRENT_VERSION to $LATEST_RELEASE..."
	fi
fi

# --- Download ---
# Since fw is a single python script, we can just download the raw file from the main branch
# or the specific tag. Using the tag is safer for reproducible installs.
DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO/$LATEST_RELEASE/$BINARY_NAME"

info "Downloading $BINARY_NAME from $DOWNLOAD_URL..."
TMP_FILE=$(mktemp)
fetch "$DOWNLOAD_URL" >"$TMP_FILE"

# --- Install ---
info "Installing to $TARGET..."
mv "$TMP_FILE" "$TARGET"
chmod +x "$TARGET"

success "fw has been installed to $TARGET"

# --- PATH check ---
case ":$PATH:" in
*":$INSTALL_DIR:"*) ;;
*)
	warn "$INSTALL_DIR is not in your PATH."
	info "You may want to add it to your shell configuration (.zshrc, .bashrc):"
	echo -e "  export PATH=\"\$PATH:$INSTALL_DIR\""
	;;
esac

info "Run 'fw --version' to verify the installation."
