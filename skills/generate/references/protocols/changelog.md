# changelog [<ref>] — architectural change history

1. Base ref: the argument if given, else the oldest `generated_at_commit`
   across topic files.
2. `git diff --stat <base>..HEAD`, then read enough of the changed files
   to describe changes at architecture level only: modules added/removed,
   dependency-direction changes, new/removed routes, commands, events,
   tables, workers, external dependencies, config keys. Ignore
   implementation-detail churn.
3. Append a dated entry to `docs/design/changelog.md` (create with
   frontmatter on first run; entries newest-first, each headed
   `## <date> (<base>..<head>)`). Factual voice; cite files.
4. Suggest `/archdesign:generate` if the diff shows stale topics.
