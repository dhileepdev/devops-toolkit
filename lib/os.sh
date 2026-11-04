#!/usr/bin/env bash
# lib/os.sh — OS / distro / arch detection, shared helpers, logging
# sourced by other scripts; provides: OS, DISTRO, ARCH, is_macos, is_linux,
# is_ubuntu, is_debian, is_centos, is_arm64, is_x64, log_info, log_warn, log_err

# ── Detect OS ──────────────────────────────────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
  OS="macos"
elif [[ "$(uname -s)" == "Linux" ]]; then
  OS="linux"
else
  OS="unknown"
fi

# ── Detect distro (Debian/Ubuntu/CentOS/RHEL/Fedora/Arch/Unknown) ────────
if [[ "$OS" == "linux" ]]; then
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    DISTRO="${ID:-unknown}"
    # Normalise
    case "$DISTRO" in
      ubuntu|debian) DISTRO="debian" ;;
      centos|rhel|rocky|almalinux) DISTRO="centos" ;;
      arch) DISTRO="arch" ;;
      *) DISTRO="unknown" ;;
    esac
  else
    DISTRO="unknown"
  fi
else
  DISTRO="unknown"
fi

# ── Detect arch ────────────────────────────────────────────────────────────
if [[ "$(uname -m)" == "arm64" || "$(uname -m)" == "aarch64" ]]; then
  ARCH="arm64"
else
  ARCH="x86_64"
fi

# ── Convenience booleans ───────────────────────────────────────────────────
is_macos()  { [[ "$OS" == "macos" ]]; }
is_linux()  { [[ "$OS" == "linux" ]]; }
is_ubuntu() { [[ "$DISTRO" == "debian" && "$(lsb_release -is 2>/dev/null)" == "Ubuntu" ]]; }
is_debian() { [[ "$DISTRO" == "debian" ]]; }
is_centos(){ [[ "$DISTRO" == "centos" ]]; }
is_arm64()  { [[ "$ARCH" == "arm64" ]]; }
is_x64()    { [[ "$ARCH" == "x86_64" ]]; }

# ── Logging ────────────────────────────────────────────────────────────────
log_info()  { printf "[INFO] %s\n" "$*" >&2; }
log_warn()  { printf "[WARN] %s\n" "$*" >&2; }
log_err()   { printf "[ERR] %s\n" "$*" >&2; exit 1; }

# ── Ensure we have a required command ──────────────────────────────────────
require_cmd() {
  local cmd="$1"; shift
  if ! command -v "$cmd" >/dev/null 2>&1; then
    log_err "Required command '$cmd' not found. Install it first."
  fi
  "$cmd" "$@"
}

# ── Print once per session ────────────────────────────────────────────────
# Usage: once_per_session KEY "message"
once_per_session() {
  local key="$1"; shift
  local var="_OS_ONCE_${key}"
  if [[ -z "${!var:-}" ]]; then
    eval "$var=1"
    printf "%s\n" "$*"
  fi
}