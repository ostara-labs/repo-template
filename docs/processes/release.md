# Release process

```mermaid
sequenceDiagram
    participant C as Contributor / Agent
    participant M as main
    participant RP as release-please (release.yml)
    participant H as Human maintainer
    participant GH as GitHub Releases

    C->>M: merge PR(s) with Conventional Commit titles
    M->>RP: push event triggers release.yml
    RP->>RP: compute next semver per stack<br/>(feat = minor, fix/perf = patch, feat! = major)
    RP->>H: opens or updates the Release PR<br/>(version bumps + CHANGELOG.md per kept stack)
    Note over H: review when ready to publish
    H->>M: squash-merge the Release PR
    M->>GH: tags v<version> + publishes GitHub Release<br/>with generated notes
```

## TL;DR

Merging conventional commits to `main` is all it takes. release-please
accumulates them into a single **Release PR**; merging that one PR
publishes the version: tags and GitHub Releases with notes are created
automatically. No manual `git tag`, no hand-written changelog, ever.

## Rules

- **Never edit `CHANGELOG.md` by hand** - it is generated. Fix the commit
  history instead (a follow-up Release PR corrects course).
- **Tags are immutable** - a wrong release is fixed forward by cutting the
  next one, never by retagging.
- **Only release-please creates tags/releases** on this repository.
- Commit types drive versions: `feat` bumps minor, `fix`/`perf` bump
  patch, `feat!` or a `BREAKING CHANGE:` footer bumps major; other types
  do not bump.

## Failure modes

- **Release workflow red** - usually means GitHub Actions is not allowed
  to create pull requests (common under org policies). Remedy: set the
  `RELEASE_TOKEN` secret or enable the org setting (see MANIFEST.md,
  post-bootstrap hardening).
- **No Release PR appears** - normal when only non-bumping commits
  (`docs:`, `chore:`...) landed since the last release.
