#!/usr/bin/env bash
# install-brew.sh — Install Homebrew packages from macos.brew.txt
# Usage: ./packages/scripts/install-brew.sh [--yes] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BREW_LIST="$REPO_ROOT/packages/macos.brew.txt"

# shellcheck source=/dev/null
source "$REPO_ROOT/lib/os.sh"

dry_run=false
yes_flag=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes) yes_flag=true; shift ;;
    --dry-run) dry_run=true; shift ;;
    *) log_err "Unknown flag: $1" ;;
  esac
done

if ! is_macos; then
  log_err "This script is for macOS only. Detected OS: $OS"
fi
if ! command -v brew >/dev/null 2>&1; then
  log_err "Homebrew not found. Install from https://brew.sh first."
fi

# Read package names, stripping blank lines and comments (inline too)
read_pkgs() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$BREW_LIST"
}

if $dry_run; then
  log_info "[DRY-RUN] Would install brew packages from $BREW_LIST:"
  read_pkgs | while IFS= read -r pkg; do
    log_info "  brew install $pkg"
  done
  exit 0
fi

log_info "Installing brew packages from $BREW_LIST..."
while IFS= read -r pkg; do
  if $yes_flag; then
    brew install "$pkg" 2>/dev/null || log_warn "Failed/skipped: $pkg"
  else
    read -rp "Install $pkg? [y/N] " ans || ans=""
    case "$ans" in
      [Yy]*) brew install "$pkg" 2>/dev/null || log_warn "Failed/skipped: $pkg" ;;
      *) log_info "Skipped $pkg" ;;
    esac
  fi
done < <(read_pkgs)

log_info "Done."