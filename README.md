# devops-toolkit

A shared SRE/DevOps playbook for onboarding and tool discovery.
Works on macOS and Linux. One repo, one `bootstrap` command, per-tool scripts anyone can read, review, or run individually.

## Quick Start

```bash
# 1. Clone this repo
git clone <your-repo-url> devops-toolkit
cd devops-toolkit

# 2. Run bootstrap (detects OS, installs packages, wires aliases)
chmod +x packages/scripts/bootstrap.sh
./packages/scripts/bootstrap.sh       # interactive prompts
./packages/scripts/bootstrap.sh --yes # auto-accept prompts
./packages/scripts/bootstrap.sh --dry-run  # preview what it will do

# 3. Source your shell profile
source ~/.zshrc   # or ~/.bashrc on Linux
```

## What It Does

- **OS auto-detection** — macOS vs Linux (debian/ubuntu/centos/arch/arm64/x86_64)
- **Package installs** — `brew install` on macOS, `apt-get install` on Linux
- **Aliases** — git, kubectl, helm, docker, fzf, bat, delta, and more
- **Diagnostic CLI tools** — `diag`, `net`, `k8s`, `docker`, `ssh`, `explore`
- **Tool discovery** — `explore search/describe/suggest` to find what's installed and what to install
- **Bootstrap summary** — prints what was installed and what to do next

## Directory Structure

```
devops-toolkit/
├── DESIGN.md           # this design doc
├── README.md           # you are here
├── bin/                # staged binaries + wrappers
├── lib/
│   └── os.sh          # OS/distro/arch detection, shared helpers, logging
├── tools/
│   ├── diag/          # disk, mem, cpu, uptime, load, boot time
│   ├── net/           # port connectivity, dns, trace, myip
│   ├── k8s/           # context switch, pods, nodes, logs
│   ├── docker/        # ps, images, prune, logs, top
│   ├── ssh/           # jump host config, last-login, key-list
│   └── explore/       # search, list-installed, suggest, describe
├── packages/
│   ├── macos.brew.txt # curated Homebrew formula list
│   ├── linux.apt.txt  # curated APT package list
│   └── scripts/       # install-brew.sh, install-apt.sh
├── aliases/
│   ├── macos.zsh      # macOS-specific aliases
│   └── linux.zsh      # Linux-specific aliases
└── docs/
    └── onboarding.md  # team onboarding guide (add your own)
```

## Adding a New Tool

1. Add a subdirectory under `tools/` with a script named `<name>` (no extension)
2. The script must accept a subcommand pattern: `script <subcommand> [args]`
3. Add the tool name to the `tools/explore/explore` list if you want it in `describe/suggest`
4. Add the package name to the appropriate `packages/*.txt` if it's a brew/apt formula
5. Add aliases to `aliases/macos.zsh` or `aliases/linux.zsh` if relevant

## Team Conventions

- All scripts are POSIX-sh compatible; bash-isms guarded at runtime
- Every script prints plain text to stdout, errors to stderr; exit codes: 0 success, 1 usage, 2 not-found
- No secrets in this repo. Credentials, tokens, hostnames live in the user's shell config or vault.
- `--dry-run` on `bootstrap`, `install-brew.sh`, `install-apt.sh` prints planned actions without executing.
- `--yes` skips interactive prompts (CI-friendly).

## OS Support

- **macOS** — tested on latest macOS, uses Homebrew
- **Linux** — APT path targets Debian/Ubuntu. macOS uses Homebrew.

## Contributing

1. Fork / clone the repo
2. Add/modify tools, packages, or aliases
3. Run `./packages/scripts/bootstrap.sh --dry-run` to preview changes
4. Commit with a clear message

See `DESIGN.md` for full architectural rationale.