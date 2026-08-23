# MANIFEST

Every file and directory in this template, what it does, and what to do with
it. Your first PR after generating the repository is the selection pass:
decide which stacks to keep, delete the rest, and rename the placeholders.

## Inventory

### Shared core

| Path | Purpose | Action |
|---|---|---|
| Makefile | Entrypoint; canonical targets (help, hooks, format, lint, test, build, ci, clean) | Keep |
| .pre-commit-config.yaml | Local hooks: hygiene, gitleaks, conventional commits, no-commit-to-main | Keep |
| .editorconfig | Editor defaults (LF, indentation) | Keep |
| .gitattributes | Line endings, linguist hints | Keep |
| .gitignore | Root ignores (stack ignores live in stack dirs) | Keep |
| .env.example | Environment template | Keep |
| .gitleaks.toml | Secret scanning config | Keep |
| README.md | Pitch and quickstart | Adapt |
| MANIFEST.md | This file | Keep |
| AGENTS.md | Agent rules | Keep |
| CLAUDE.md | Claude import of AGENTS.md | Keep |
| CONTRIBUTING.md | Contribution guide | Adapt |
| SECURITY.md | Security policy | Adapt |
| CODE_OF_CONDUCT.md | Contributor Covenant 2.1 | Keep |
| CHANGELOG.md | Keep a Changelog | Keep |
| LICENSE | MIT | Adapt |
| docs/architecture/ARCHITECTURE.md | Layout and flow | Adapt |
| docs/architecture/decisions/ | ADRs | Keep |
| docs/guidelines/, docs/processes/, docs/domain/, docs/how-to/ | Documentation tree (see each README) | Keep |

### CI, security, release

| Path | Purpose | Action |
|---|---|---|
| .github/CODEOWNERS | Review ownership | Adapt |
| .github/dependabot.yml | Dependency updates | Adapt (delete per-stack sections) |
| .github/pull_request_template.md | PR template | Keep |
| .github/ISSUE_TEMPLATE/ | Issue templates | Keep |
| .github/workflows/ci.yml | Main CI; one job block per stack | Adapt (delete per-stack job blocks) |
| .github/workflows/rust-ci.yml | Reusable Rust workflow | Delete-if-unused |
| .github/workflows/typescript-ci.yml | Reusable TypeScript workflow | Delete-if-unused |
| .github/workflows/elixir-ci.yml | Reusable Elixir workflow | Delete-if-unused |
| .github/workflows/python-ci.yml | Reusable Python workflow | Delete-if-unused |
| .github/workflows/security.yml | gitleaks scan | Keep |
| .github/workflows/release.yml | release-please | Keep |
| .github/workflows/pr-classify.yml | Trust-boundary PR labeling | Keep |
| .github/workflows/pr-meta.yml | PR title lint + size/risk labels | Keep |
| release-please-config.json | Release config; one entry per stack | Adapt (delete per-stack entries) |
| .release-please-manifest.json | Release manifest; one entry per stack | Adapt (delete per-stack entries) |

### Rust

| Path | Purpose | Action |
|---|---|---|
| rust/ | Crate `my-app` (lib `my_app`); marker Cargo.toml | Delete-if-unused |
| rust/.gitignore | Stack ignores | Delete-if-unused |

### TypeScript

| Path | Purpose | Action |
|---|---|---|
| typescript/ | Package `@your-org/my-app`; marker package.json | Delete-if-unused |
| typescript/.gitignore | Stack ignores | Delete-if-unused |

### Elixir

| Path | Purpose | Action |
|---|---|---|
| elixir/ | App `:my_app` / `MyApp`; marker mix.exs | Delete-if-unused |
| elixir/.gitignore | Stack ignores | Delete-if-unused |

### Python

| Path | Purpose | Action |
|---|---|---|
| python/ | Package `my-package` / `my_package`; marker pyproject.toml | Delete-if-unused |
| python/.gitignore | Stack ignores | Delete-if-unused |

## Deleting a stack

To remove a stack (example: Rust), delete all of the following — no Makefile
edits are needed:

1. The stack directory (`rust/`).
2. `.github/workflows/rust-ci.yml`.
3. The Rust job block in `.github/workflows/ci.yml`.
4. The Rust section in `.github/dependabot.yml`.
5. The Rust entry in `release-please-config.json` and
   `.release-please-manifest.json`.
6. Mentions in README.md and CONTRIBUTING.md.

Repeat for each stack you do not keep.

## Rename placeholders

| Placeholder | Where |
|---|---|
| `your-org` | README.md, typescript/package.json, SECURITY.md, CODE_OF_CONDUCT.md |
| `@oloompa` | .github/CODEOWNERS (trust-boundary owners) |
| `my-app` / `my_app` | rust/Cargo.toml, rust/src/lib.rs |
| `@your-org/my-app` | typescript/package.json |
| `:my_app` / `MyApp` | elixir/mix.exs, elixir/lib/ |
| `my-package` / `my_package` | python/pyproject.toml, python/src/ |
| `Your Name` | LICENSE |
| `<repo-name>` | README.md, docs/architecture/ARCHITECTURE.md |

## Post-bootstrap hardening

After the first push:

- [ ] Replace `@oloompa` in `.github/CODEOWNERS` with your maintainer
      identity or team. These entries are the trust boundary: PRs touching
      CI workflows, dependency policy, release automation, hook config, or
      governance files require a code-owner approval to merge. Normal PRs
      (code, docs, dependency bumps) need no approval.
- [ ] Branch protection on `main`: run
      `bash scripts/setup-rulesets.sh <owner>/<repo>` — creates the
      "main-protection" ruleset (PRs required, force-push/deletion blocked,
      status checks required, code-owner review for trust-boundary paths)
      and the `requires-human-review` label.
- [ ] Secret scanning with push protection: ON.
- [ ] Dependabot alerts: ON.
- [ ] If GitHub Actions cannot create pull requests (common on org repos),
      add a `RELEASE_TOKEN` secret (fine-grained PAT or App token with
      `contents:write` + `pull-requests:write`) — release.yml prefers it over
      GITHUB_TOKEN automatically.
- [ ] Default branch is `main`.
