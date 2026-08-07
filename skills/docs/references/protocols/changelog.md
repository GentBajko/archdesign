# changelog [<ref>] — architectural change history

1. Base ref: the argument if given; else the `<head>` of the newest
   entry in `docs/design/changelog.md` when it exists (so successive
   runs continue the history instead of re-describing it); else the
   oldest `generated_at_commit` across topic files. If the chosen ref
   is unreachable (rebase, shallow clone), say so and fall back to the
   oldest reachable stamp — never silently diff from the wrong base.
   Record refs as 12-char SHAs.
2. `git diff --stat <base>..HEAD`, then read enough of the changed files
   to describe changes at architecture level only: modules added/removed,
   dependency-direction changes, new/removed routes, commands, events,
   tables, workers, external dependencies, config keys. Ignore
   implementation-detail churn.
3. Append a dated entry to `docs/design/changelog.md` (create with
   frontmatter on first run; entries newest-first, each headed
   `## <date> (<base>..<head>)`). Factual voice; cite files.
4. Suggest a refresh (the `docs` skill) if the diff shows stale topics.
