# AGENTS.md

## Project overview

Multi-language template repository: four optional stacks (Rust, TypeScript,
Elixir, Python) behind one GNU Make entrypoint. Stacks are auto-detected via
marker files (rust/Cargo.toml, typescript/package.json, elixir/mix.exs,
python/pyproject.toml); deleting a stack means deleting its dir plus its CI,
Dependabot, and release-please entries — zero Makefile edits. Distributed via
GitHub "Use this template"; generated projects inherit these rules.

## Commands

- `make ci` — full local gate (lint + test). Run before declaring work done.
- `make deps` — install dependencies for all present stacks (run after clone).
- `make lint`, `make test`, `make format`, `make build`, `make clean`
- Per-stack: `make lint-rust`, `make test-typescript`, ... (suffixes:
  -rust, -typescript, -elixir, -python). Absent stacks print
  `[target] skipped (no <marker>)`.
- Single tests:
  - Rust: `cargo test <name>` from rust/
  - TypeScript: `cd typescript && pnpm exec vitest run <path>`
  - Elixir: `mix test <path>` from elixir/
  - Python: `uv run pytest <path>::<test_name>` from python/

## Structure

- rust/ — crate `my-app` (lib `my_app`); marker Cargo.toml
- typescript/ — package `@your-org/my-app`; marker package.json
- elixir/ — app `:my_app` / `MyApp`; marker mix.exs
- python/ — package `my-package` / `my_package`; marker pyproject.toml
- .github/ — workflows, dependabot, issue/PR templates
- docs/ — ARCHITECTURE.md + decisions/ (ADRs)

## Code style

- Rust: rustfmt + clippy `-D warnings`; 4-space indent
- TypeScript: Biome 2.x; 2-space indent
- Elixir: `mix format` + credo `--strict`; 2-space indent
- Python: ruff (check + format); 4-space indent
- Commits: Conventional Commits — types: feat, fix, docs, style, refactor,
  perf, test, build, ci, chore, revert. Breaking changes: `!` after the type
  (e.g. `feat!: ...`). Scope optional (e.g. `feat(rust): ...`).

## Security and secrets

- Never commit real secrets or `.env` files. `.env.example` is the only
  committed template.
- gitleaks runs in pre-commit and CI (security.yml); a leak blocks the PR.
- Report vulnerabilities via SECURITY.md.

## Boundaries

### Always

- Run `make ci` before declaring work done.
- Update docs and MANIFEST.md when behavior changes.

### Ask first

- Add dependencies.
- Edit `.github/workflows/**`.
- Change the Makefile contract or `.pre-commit-config.yaml`.
- Touch LICENSE or MANIFEST.md.

### Never

- Commit real secrets or `.env`.
- Force-push main.
- Bypass or disable hooks or CI gates.
- Weaken lint configs to pass.
- Commit directly to main.

## Definition of done

- `make ci` is green locally.
- Docs updated (README, MANIFEST, ADRs as applicable).
- No unrelated changes in the PR.

Nested AGENTS.md files are allowed per stack dir and override this file within
that subtree.
