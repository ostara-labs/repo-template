# repo-template

A production-grade multi-language repository template: four optional stacks
(Rust, TypeScript, Elixir, Python) behind one GNU Make entrypoint, one CI
pipeline, and one release process. Use it as the starting point for any new
project — keep the stacks you need, delete the rest, zero Makefile edits.

[![CI](https://github.com/ostara-labs/repo-template/actions/workflows/ci.yml/badge.svg)](https://github.com/ostara-labs/repo-template/actions/workflows/ci.yml)
[![Security](https://github.com/ostara-labs/repo-template/actions/workflows/security.yml/badge.svg)](https://github.com/ostara-labs/repo-template/actions/workflows/security.yml)
[![Release](https://img.shields.io/github/v/release/ostara-labs/repo-template)](https://github.com/ostara-labs/repo-template/releases)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/ostara-labs/repo-template/badge)](https://api.scorecard.dev/projects/github.com/ostara-labs/repo-template)

## What's inside

| Area | Contents |
|---|---|
| Stacks | `rust/`, `typescript/`, `elixir/`, `python/` — each optional, auto-detected via its marker file |
| Tooling | GNU Make, pre-commit, gitleaks, Conventional Commits, release-please |
| CI/CD | GitHub Actions: lint + test per stack, security scan, release automation |
| Governance | AGENTS.md, CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md, ADRs |

## Quickstart

1. **Create the repository.** Click "Use this template" on GitHub, or clone
   this repository and push it to a new remote.
2. **Run the selection pass.** Open MANIFEST.md — your first PR is deciding
   which stacks to keep. Delete the stacks you do not need plus their CI,
   Dependabot, and release-please entries (exact instructions in MANIFEST.md).
3. **Rename placeholders.** Replace `your-org`, `my-app`, `@your-org/my-app`,
   `:my_app`/`MyApp`, and `my-package`/`my_package` with your real names
   (table in MANIFEST.md).
4. **Install hooks.** `make hooks` (requires pre-commit; see CONTRIBUTING.md).
5. **Push and harden.** Push to `main`, then provision branch protection
   with `bash scripts/setup-rulesets.sh <owner>/<repo>` (requires PRs and
   the `gate` status check), enable secret scanning with push protection,
   and Dependabot alerts. Full checklist in MANIFEST.md.

## Commands

| Target | What it does |
|---|---|
| `make help` | List all targets |
| `make hooks` | Install pre-commit hooks |
| `make deps` | Install dependencies in all kept stacks |
| `make format` | Format all kept stacks |
| `make lint` | Lint all kept stacks |
| `make test` | Test all kept stacks |
| `make build` | Build all kept stacks |
| `make ci` | `lint` + `test` — the full local gate |
| `make clean` | Remove build artifacts |
| `make lint-rust` | One stack only (`-typescript`, `-elixir`, `-python` also available) |

Absent stacks print `[target] skipped (no <marker>)` and are ignored.

## Requirements

- GNU Make >= 4
- pre-commit (Python)
- Toolchains for the stacks you keep: Rust stable (pinned by
  rust-toolchain.toml), Node 22 + pnpm, OTP 27 + Elixir 1.18, uv (Python)
- **Windows:** `choco install make` for GNU Make >= 4, and Git Bash in PATH —
  the Makefile recipes are POSIX. Line endings are enforced as LF by
  `.gitattributes`.

## Documentation

Suggested reading order for humans: MANIFEST → CONTRIBUTING → the docs
tree below (guidelines first).

- MANIFEST.md — file inventory and bootstrap checklist
- CONTRIBUTING.md — setup, conventions, PR process
- SECURITY.md — supported versions and vulnerability reporting
- docs/architecture/ARCHITECTURE.md — layout rationale and CI/CD flow
- docs/architecture/decisions/ — architecture decision records
- docs/guidelines/ — repo rules (engineering principles: coding-patterns.md)
- docs/processes/ — process and code-walkthrough docs (code wins over prose)
- docs/domain/ — business-domain concepts and glossary (fill after bootstrap)
- docs/how-to/ — task-oriented recipes for humans

## License

MIT — see LICENSE.
