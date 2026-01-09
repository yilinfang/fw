#!/bin/bash

# install.sh - Installation script for fw (File Selector and Combiner)
# Usage: curl -fsSL https://raw.githubusercontent.com/yilinfang/fw/main/install.sh | bash
# Or: INSTALL_DIR=/path/to/bin bash install.sh

set -euo pipefail

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
error() { echo -e "${RED}error:${NC} $1"; exit 1; }
success() { echo -e "${GREEN}success:${NC} $1"; }

# --- Dependency Checks ---
info "Checking dependencies..."

if ! command -v python3 >/dev/null 2>&1; then
    error "python3 is required but not found. Please install Python 3.6+."
fi

if ! command -v fzf >/dev/null 2>&1; then
    warn "fzf is not found. 'fw' requires fzf to run interactively."
    info "You can install it from: https://github.com/junegunn/fzf"
fi

# --- Installation Directory ---
INSTALL_DIR="${INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
mkdir -p "$INSTALL_DIR"

# --- Get Latest Release ---
info "Fetching latest release information for $REPO..."
if command -v curl >/dev/null 2>&1; then
    LATEST_RELEASE=$(curl -s "$GITHUB_API" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
elif command -v wget >/dev/null 2>&1; then
    LATEST_RELEASE=$(wget -qO- "$GITHUB_API" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
else
    error "Neither curl nor wget found. Please install one of them."
fi

if [ -z "$LATEST_RELEASE" ]; then
    error "Could not determine the latest release version."
fi

info "Latest release: $LATEST_RELEASE"

# --- Download ---
# Since fw is a single python script, we can just download the raw file from the main branch 
# or the specific tag. Using the tag is safer for reproducible installs.
DOWNLOAD_URL="https://raw.githubusercontent.com/$REPO/$LATEST_RELEASE/$BINARY_NAME"

info "Downloading $BINARY_NAME from $DOWNLOAD_URL..."
TMP_FILE=$(mktemp)
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$DOWNLOAD_URL" -o "$TMP_FILE"
else
    wget -qO "$TMP_FILE" "$DOWNLOAD_URL"
fi

# --- Install ---
info "Installing to $INSTALL_DIR/$BINARY_NAME..."
mv "$TMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
chmod +x "$INSTALL_DIR/$BINARY_NAME"

success "fw has been installed to $INSTALL_DIR/$BINARY_NAME"

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
