# Team Onboarding Guide

Welcome to the SRE/DevOps team. This toolkit exists so a fresh laptop
becomes a useful workstation in one command, and so tool knowledge is
shared instead of tribal.

## First 15 Minutes

```bash
git clone <your-repo-url> devops-toolkit
cd devops-toolkit
./packages/scripts/bootstrap.sh --dry-run   # see what will happen
./packages/scripts/bootstrap.sh             # actually install
exec zsh                                     # restart shell
```

Add the toolkit CLIs to your PATH (put this in your shell profile):

```bash
export PATH="$HOME/devops-toolkit/bin:$PATH"
```

Verify:

```bash
explore list-installed   # what you have
diag all                 # system health snapshot
net myip                 # connectivity sanity check
```

## What Bootstrap Installs

- **macOS:** Homebrew formulae from `packages/macos.brew.txt`
- **Linux (Debian/Ubuntu):** APT packages from `packages/linux.apt.txt`
- **Aliases:** appended to `~/.zshrc` (and `~/.bashrc` on Linux)
- **CLIs:** symlinked into `bin/` — `diag`, `net`, `k8s`, `docker`, `ssh`, `explore`

Nothing is forced: interactive prompts by default, `--yes` to accept,
`--dry-run` to preview. Re-running is safe (idempotent).

## The Toolkit CLIs

| Command | What it does | Examples |
|---------|--------------|----------|
| `diag`  | System diagnostics | `diag uptime`, `diag disk`, `diag all` |
| `net`   | Network checks | `net ping host`, `net port host 443`, `net myip` |
| `k8s`   | Kubernetes helpers | `k8s ctx`, `k8s get-pods`, `k8s get-logs <pod>` |
| `docker`| Docker helpers | `docker ps`, `docker images`, `docker prune` |
| `ssh`   | SSH helpers | `ssh list-configs`, `ssh last-login` |
| `explore`| Tool discovery | `explore search terraform`, `explore describe helm` |

## Discovering New Tools

`explore` is the answer to "what's this tool and should I have it?":

```bash
explore search <term>       # find a tool across the kit
explore describe <tool>     # what it does + install command
explore list-installed      # what you already have on PATH
```

If you find a tool the team should standardize on, add it:

1. Add the package to `packages/macos.brew.txt` and `packages/linux.apt.txt`
2. Add a description case in `tools/explore/explore`
3. Open a PR — one tool per PR keeps review easy

## Adding a New CLI Tool

```
tools/<category>/<name>     # <name> is the command, no extension
```

Rules:

- First line: `#!/usr/bin/env bash`
- Subcommand dispatch at the bottom: `case "${1:-}" in ... esac`
- Source the shared lib: `source "$REPO_ROOT/lib/os.sh"` (for `is_macos`, logging, etc.)
- Every subcommand prints plain text to stdout, errors to stderr
- Provide a `usage()` and exit 2 on bad usage
- Must work on both macOS and Linux; branch on `is_macos` / `is_linux`

## Conventions

- **No secrets** in this repo. Use your shell config, `~/.ssh/config`, or the vault.
- **Idempotent scripts.** Re-running must not break anything.
- **`--dry-run` for anything destructive** (installs, prunes, deletes).
- **One tool per PR.** Keeps review focused.
- **Test on both OSes** before opening a PR (or note what you couldn't test).

## Who Owns What

- **Toolkit core** (`lib/`, `packages/scripts/`): team maintainers
- **Individual tools** (`tools/*`): the person who added it, then the team
- **Package lists**: anyone, via PR

## Getting Help

- Read `README.md` and `DESIGN.md`
- Run `<tool> ` with no args for usage
- Ask in the team channel; if the answer should be shared, add it to this doc