# Shared Rules (read by every subcommand)

Hard rules:

1. **Describe, never judge** — facts with `file:line` pointers; no
   recommendations, grades, or comparisons. Sole exception: `critique`,
   and only because the user explicitly invoked it.
2. **Write only `DESIGN.md` and `docs/design/*`.** Never touch source
   code, `openspec/`, or human-authored docs.
3. **Docs are skill-owned** — re-runs may rewrite any generated section;
   manual edits are not preserved.
4. Follow `style.md` (same directory) for every sentence you write.

Everything a subcommand writes carries the topic-file frontmatter stamps
(`generated_at_commit`, `generated_date`, plus `paths_covered` where the
refresh protocol applies; date-only outside git).

Voice: `verify`/`query`/`changelog` are facts only. `critique` is the
one opinionated output. `runbooks`/`onboarding` may use
imperative/narrative voice, but every command must be verified and every
step cites its files — style.md's density and naming rules still bind.

Maintenance: each subcommand = `references/protocols/<name>.md` + a
wrapper skill at `skills/<name>/`; update both when the surface changes,
plus `scripts/help.sh` (the single source of the usage text).
