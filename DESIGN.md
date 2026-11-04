# devops-toolkit — Design Doc

## Intent

A portable, shared SRE/DevOps playbook for onboarding and tool discovery.
Works on macOS and Linux (any distro). Team-maintained: one repo, one
`bootstrap` command, per-tool scripts that anyone can read, review, or
run individually.

## Why

New team members (and newly introduced tooling) need a single place to
find: essential packages, aliases, and small diagnostics. Today that
knowledge lives in tribal memory or scattered dotfiles. This repo makes
it explicit, OS-aware, and reviewable.

## Scope

**In:** aliases, binaries, brew/apt package lists, per-tool diagnostics,
OS detection, tool discovery/explore, bootstrap installer with `--dry-run`.

**Out:** package building, CI/CD pipelines, secrets management, cloud
provisioning, GUIs.

## Architecture

Modular toolkit. dispatcher → OS-aware lib → per-tool scripts.

```
devops-toolkit/
├── README.md
├── DESIGN.md
├── bin/                  # staged binaries + wrappers
├── lib/
│   └── os.sh             # OS/distro/arch detection, shared helpers, logging
├── tools/
│   ├── diag/             # disk, mem, cpu, uptime, load, boot time
│   ├── net/              # port listen, connectivity, dns, trace
│   ├── proc/             # ps wrappers, top-by-cpu/mem, kill-by-name
│   ├── k8s/              # context switch, pods-by-node, get-logs
│   ├── docker/           # ps, top, prune, images-by-size
│   ├── ssh/              # jump config, last-login, key-list
│   └── explore/          # tool discovery: search, check-installed, suggest
├── packages/
│   ├── macos.brew.txt
│   ├── linux.apt.txt
│   └── scripts/          # install-brew.sh, install-apt.sh, bootstrap.sh
├── aliases/
│   ├── macos.zsh
│   └── linux.zsh
├── go/                   # optional static binaries
└── docs/
    └── onboarding.md
```

## Key behaviors

- **OS auto-detect** at load (`lib/os.sh`): macOS vs Linux, distro
  (debian/ubuntu/centos/arch), arch (arm64/x86_64). Commands branch on
  detected values, never guess.
- **`bootstrap`** — one command: detect OS, install package list (prompt
  unless `--yes`), wire aliases, stage binaries, print a summary of what
  it did. `--dry-run` prints planned actions without executing.
- **`explore`** — search tools by name/tags, check what is installed on
  this box, suggest installs. This is the "newly introduced tools to
  explore" part.
- **No sudo by default** — install steps ask; `--yes` skips prompts.
- **Idempotent** — re-running bootstrap is safe.

## Language choices

- **bash** — OS detection, install/alias wiring, brew/apt manifests.
  Runs everywhere with zero build step.
- **Python** — `explore` CLI (nicer parsing, JSON output,
  cross-platform, stdlib only).
- **Go** — reserved for small static binaries (port scanner,
  http-probe) if they prove necessary; not required to use the kit.

## Conventions

- Scripts are POSIX-sh compatible where practical; bash-only features
  are guarded with a runtime check.
- Every tool prints plain text to stdout; errors to stderr; exit codes
  follow `0` success / `1` generic / `2` usage.
- `--help` on every tool.
- No secrets in this repo. Credentials, tokens, and hostnames live in
  the user's shell config or a vault.

## Open questions

- Team git hosting (GitHub internal/public)? Affects README clone URL.
- Default shell for aliases: zsh (macOS default) and bash; provide
  both `.zsh` and `.bash` variants where it matters.