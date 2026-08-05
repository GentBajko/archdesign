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

**Index maintenance:** every file this plugin writes under
`docs/design/` must be listed in `DESIGN.md` — topics in the topic
index, everything else (critique, changelog, onboarding, preferences,
runbooks/, mockup/) as a row in a "Companion docs" table (file · what
it is · date). The only exceptions are interview Q&A files
(`interview.md`, `mockup-interview.md`, `preferences-interview.md`),
which are never indexed. After writing your output, add or refresh your
row; if `DESIGN.md` does not exist yet, create a minimal one (title +
the two tables) rather than leaving the output orphaned.

Voice: `verify`/`query`/`changelog` are facts only. `critique` is the
one opinionated output. `preferences` is normative but only records the
user's own stated decisions. `runbooks`/`onboarding` may use
imperative/narrative voice, but every command must be verified and every
step cites its files — style.md's density and naming rules still bind.

Maintenance: each subcommand = `references/protocols/<name>.md` + a
wrapper skill at `skills/<name>/`; update both when the surface changes,
plus `scripts/help.sh` (the single source of the usage text).
