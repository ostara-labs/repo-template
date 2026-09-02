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
| .github/workflows/ci.yml | Main CI; thin callers to devtools + workflow-lint gate | Adapt (delete per-stack caller jobs + gate.needs entries) |
| .devtools/ (submodule) | Shared makefiles, workflows, hooks — ostara-labs/devtools @ v1.0.0 | Keep (update via `make devtools-update`) |
| .gitmodules | Submodule definition: .devtools -> ostara-labs/devtools @ v1.0.0 | Keep |
| .github/workflows/security.yml | gitleaks scan | Keep |
| .github/workflows/release.yml | release-please | Keep |
| .github/workflows/pr-classify.yml | Trust-boundary PR labeling | Keep |
| .github/trust-boundary.yml | Trust-boundary path patterns; consumed by pr-classify.yml (requires-human-review label) and the main-protection ruleset (code-owner review) | Keep |
| .github/workflows/pr-meta.yml | PR title lint + size/risk labels | Keep |
| .coderabbit.yaml | AI review config (free on public repos) | Keep |
| release-please-config.json | Release config; one entry per stack | Adapt (delete per-stack entries) |
| .release-please-manifest.json | Release manifest; one entry per stack | Adapt (delete per-stack entries) |
| scripts/setup-rulesets.sh | Provisions the main-protection ruleset and the requires-human-review label on a fresh repo (run once post-bootstrap) | Keep |

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
2. The Rust caller job in `.github/workflows/ci.yml` — plus the same
   stack name in the `gate` job's `needs` list (a `needs` entry pointing
   at a deleted job invalidates the whole workflow).
3. The Rust section in `.github/dependabot.yml`.
4. The Rust entry in `release-please-config.json` and
   `.release-please-manifest.json`.
5. Mentions in README.md and CONTRIBUTING.md.

(The Rust logic itself lives centrally in the devtools submodule — nothing
to delete there; the caller job is what gates it.)

Repeat for each stack you do not keep.

## Rename placeholders

| Placeholder | Where |
|---|---|
| `your-org` | README.md, typescript/package.json, SECURITY.md, CODE_OF_CONDUCT.md, .github/ISSUE_TEMPLATE/config.yml |
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
- [ ] Auto-merge: ON (Settings → General → Pull Requests → *Allow
      auto-merge*, squash only, commit title = PR title, delete branches).
      With the main-protection ruleset this means: normal PRs squash-merge
      as soon as CI is green; trust-boundary PRs merge automatically once
      a code owner approves.
- [ ] Allow GitHub Actions to create pull requests (org admins:
      Organization → Settings → Actions → Workflow permissions → check
      *Allow GitHub Actions to create and approve pull requests*).
      release-please needs this to open its Release PRs; without it the
      Release workflow stays red.
- [ ] Default branch is `main`.
