# repo-template

A production-grade multi-language repository template: four optional stacks
(Rust, TypeScript, Elixir, Python) behind one GNU Make entrypoint, one CI
pipeline, and one release process. Use it as the starting point for any new
project — keep the stacks you need, delete the rest, zero Makefile edits.

[![PR pipeline](https://github.com/ostara-labs/repo-template/actions/workflows/pr-pipeline.yml/badge.svg)](https://github.com/ostara-labs/repo-template/actions/workflows/pr-pipeline.yml)
[![Security](https://github.com/ostara-labs/repo-template/actions/workflows/security.yml/badge.svg)](https://github.com/ostara-labs/repo-template/actions/workflows/security.yml)
[![Release](https://img.shields.io/github/v/release/ostara-labs/repo-template)](https://github.com/ostara-labs/repo-template/releases)
[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/ostara-labs/repo-template/badge)](https://api.scorecard.dev/projects/github.com/ostara-labs/repo-template)

## What's inside

| Area | Contents |
|---|---|
| Stacks | `rust/`, `typescript/`, `elixir/`, `python/` — each optional, auto-detected via its marker file |
| Tooling | GNU Make, gitleaks, Conventional Commits, release-please |
| CI/CD | GitHub Actions: lint + test per stack, security scan, release automation |
| Governance | AGENTS.md, CONTRIBUTING.md, SECURITY.md, CODE_OF_CONDUCT.md, ADRs |

## Quickstart

1. **Create the repository.** Click "Use this template" on GitHub, or clone
   this repository and push it to a new remote.
2. **Run the selection pass.** Open MANIFEST.md — your first PR is deciding
   which stacks to keep. Delete the stacks you do not need plus their
   Dependabot and release-please entries (exact instructions in MANIFEST.md;
   CI needs no edits — the pipeline auto-detects stacks).
3. **Rename placeholders.** Replace `your-org`, `my-app`, `@your-org/my-app`,
   `:my_app`/`MyApp`, and `my-package`/`my_package` with your real names
   (table in MANIFEST.md).
4. **Install hooks.** `make hooks` (activates the devtools git hooks —
   pre-commit, commit-msg, pre-push).
5. **Push and harden.** Push to `main`, then provision branch protection
   with `bash scripts/setup-rulesets.sh <owner>/<repo>` (requires PRs and
   the `ci / gate` + `merge-gate` status checks), enable secret scanning
   with push protection, and Dependabot alerts. Full checklist in
   MANIFEST.md.

## Trust boundary (CODEOWNERS + ruleset)

Normal PRs (code, docs, dependency bumps) merge without human approval.
PRs that touch trust-boundary paths — CI pipelines, dependency policy,
release automation, review routing, governance files — require an explicit
approval from a listed code owner. The paths are declared in
[`.github/CODEOWNERS`](.github/CODEOWNERS) and mirrored by
[`.github/trust-boundary.yml`](.github/trust-boundary.yml), which labels
such PRs `requires-human-review`.

CODEOWNERS on its own blocks nothing, and "Use this template" copies files
only — repository settings are not inherited. After creating your repo,
create the `trust-boundary-codeowner-review` ruleset via the API:

```bash
gh api repos/{owner}/{repo}/rulesets --method POST --input - <<'JSON'
{
  "name": "trust-boundary-codeowner-review",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] }
  },
  "bypass_actors": [
    { "actor_id": 51793308, "actor_type": "User", "bypass_mode": "always" }
  ],
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "require_code_owner_review": true,
        "dismiss_stale_reviews_on_push": true,
        "allowed_merge_methods": ["squash", "merge", "rebase"]
      }
    }
  ]
}
JSON
```

Quirks (the rulesets API is inconsistent — learned the hard way):

- `conditions` is an **object**, not an array: nest `ref_name` directly.
- Updating an existing ruleset is a **`PUT`** to
  `/repos/{owner}/{repo}/rulesets/{id}`; **`PATCH` returns 404**.
- `bypass_actors` is `Oloompa` (actor_id `51793308`), so the owning identity
  can bypass the code-owner requirement; it is independent of the
  `main-protection` ruleset that
  [`scripts/setup-rulesets.sh`](scripts/setup-rulesets.sh) creates — run
  both.

Live example: [`ostara-labs/bot`](https://github.com/ostara-labs/bot) runs
this exact ruleset on `main`.

## CI: the PR pipeline

One workflow, [`.github/workflows/pr-pipeline.yml`](.github/workflows/pr-pipeline.yml),
chains everything a PR needs — no per-stack workflows to maintain:

1. **`ci`** — thin caller to the devtools aggregate (`ostara-labs/devtools`
   ci.yml), which auto-detects stacks by their marker files and runs
   lint + test for each one. Adding or removing a stack needs **zero
   workflow edits**.
2. **`ai-review`** — AI code review on non-draft PRs (org-wide calibration,
   no local config needed).
3. **`merge-gate`** — the final verdict job.

Branch protection requires exactly two status checks: `ci / gate` (the CI
aggregate) and `merge-gate`. The devtools version is pinned by digest in the
workflow; update it with `make devtools-update` (moves the submodule), then
move the digest to the matching tag commit.

## Commands

| Target | What it does |
|---|---|
| `make help` | List all targets |
| `make hooks` | Activate the devtools git hooks |
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
