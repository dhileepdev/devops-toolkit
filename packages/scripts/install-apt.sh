#!/usr/bin/env bash
# install-apt.sh — Install APT packages from linux.apt.txt
# Usage: ./packages/scripts/install-apt.sh [--yes] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
APT_LIST="$REPO_ROOT/packages/linux.apt.txt"

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

if ! is_linux; then
  log_err "This script is for Linux only. Detected OS: $OS"
fi
if ! is_debian; then
  log_err "This script targets Debian/Ubuntu-derived systems. Detected distro: $DISTRO"
fi

read_pkgs() {
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^[[:space:]]*$/d' "$APT_LIST"
}

if $dry_run; then
  log_info "[DRY-RUN] Would install apt packages from $APT_LIST:"
  read_pkgs | while IFS= read -r pkg; do
    log_info "  sudo apt-get install -y $pkg"
  done
  exit 0
fi

log_info "Installing apt packages from $APT_LIST..."
sudo apt-get update -qq 2>/dev/null || log_warn "apt-get update failed, continuing..."

while IFS= read -r pkg; do
  if $yes_flag; then
    sudo apt-get install -y "$pkg" 2>/dev/null || log_warn "Failed/skipped: $pkg"
  else
    read -rp "Install $pkg? [y/N] " ans || ans=""
    case "$ans" in
      [Yy]*) sudo apt-get install -y "$pkg" 2>/dev/null || log_warn "Failed/skipped: $pkg" ;;
      *) log_info "Skipped $pkg" ;;
    esac
  fi
done < <(read_pkgs)

log_info "Done."