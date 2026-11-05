#!/usr/bin/env bash
# bootstrap.sh — One-command onboarding for the devops-toolkit
# Usage: ./packages/scripts/bootstrap.sh [--yes] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
LIB_DIR="$REPO_ROOT/lib"

# shellcheck source=/dev/null
source "$LIB_DIR/os.sh"

# ── Flags ──────────────────────────────────────────────────────────────────
dry_run=false
yes_flag=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --yes) yes_flag=true; shift ;;
    --dry-run) dry_run=true; shift ;;
    *) log_err "Unknown flag: $1" ;;
  esac
done

# Build install-script args
install_args=()
if $yes_flag; then install_args+=(--yes); fi
if $dry_run; then install_args+=(--dry-run); fi

# ── Print header ───────────────────────────────────────────────────────────
log_info "========================================="
log_info "  devops-toolkit bootstrap"
log_info "  OS: $(uname -s) $DISTRO $ARCH"
log_info "========================================="

# ── OS-specific package install ────────────────────────────────────────────
if is_macos; then
  log_info "Detected macOS — running brew install..."
  bash "$SCRIPT_DIR/install-brew.sh" ${install_args[@]+"${install_args[@]}"}
elif is_linux; then
  log_info "Detected Linux ($DISTRO) — running apt install..."
  bash "$SCRIPT_DIR/install-apt.sh" ${install_args[@]+"${install_args[@]}"}
else
  log_err "Unsupported OS: $OS"
fi

# ── Wire aliases (skip on dry-run) ─────────────────────────────────────────
if $dry_run; then
  log_info "[DRY-RUN] Would wire aliases into shell profile"
  exit 0
fi

log_info "Wiring team aliases..."
ALIAS_DIR="$REPO_ROOT/aliases"

wire_aliases() {
  local rc_file="$1" alias_file="$2"
  [[ -f "$rc_file" ]] || return 0
  if grep -q "devops-toolkit aliases" "$rc_file" 2>/dev/null; then
    log_info "Aliases already in $rc_file — skipping"
    return 0
  fi
  {
    printf '\n# --- devops-toolkit aliases ---\n'
    cat "$alias_file"
    printf '\n# --- end devops-toolkit aliases ---\n'
  } >> "$rc_file"
  log_info "Appended aliases to $rc_file"
}

if is_macos; then
  wire_aliases "$HOME/.zshrc" "$ALIAS_DIR/macos.zsh"
else
  wire_aliases "$HOME/.zshrc" "$ALIAS_DIR/linux.zsh"
  wire_aliases "$HOME/.bashrc" "$ALIAS_DIR/linux.zsh"
fi

# ── Stage binaries ─────────────────────────────────────────────────────────
BIN_DIR="$REPO_ROOT/bin"
mkdir -p "$BIN_DIR"
# Symlink each toolkit CLI into bin/ so adding bin/ to PATH exposes them
for tool_script in "$REPO_ROOT"/tools/*/*; do
  [[ -f "$tool_script" ]] || continue
  ln -sf "$tool_script" "$BIN_DIR/$(basename "$tool_script")"
done
log_info "Bin directory: $BIN_DIR (add it to PATH to use diag/net/k8s/docker/ssh/explore)"

# ── Summary ────────────────────────────────────────────────────────────────
log_info "========================================="
log_info "  bootstrap complete"
log_info "  OS: $(uname -s) $DISTRO $ARCH"
log_info "  Next: restart your shell or run: source ~/.zshrc"
log_info "========================================="