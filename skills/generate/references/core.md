# Shared Rules (read by every subcommand)

## User config — `docs/design/archdesign.json`

Optional; read it first if present; absent keys use these defaults:

```json
{
  "expertise": 3,
  "docs_dir": "docs/design",
  "index_file": "DESIGN.md",
  "subagent_threshold": 150,
  "docs_in_git": "ask",
  "language": "en"
}
```

`docs_in_git` (`"commit" | "ignore" | "ask"`) pre-answers the
commit-or-gitignore question. `language` sets the generated docs'
language. The user can change any key by editing the file or just
telling you.

**`expertise` (1–5) calibrates every conversation with the user — never
the generated docs**, which serve AI sessions and stay dense per
style.md regardless:

1. **vibe** — plain language only; explain any unavoidable term in one
   clause; interviews ask about goals and experience, then derive the
   technical decision yourself and confirm it in plain words ("I'll use
   a managed database so you never run servers — OK?"); strong
   recommended defaults; never ask for numbers the user can't know —
   translate ("roughly how many people at once?") and derive the
   technical targets yourself, recording them as derived decisions.
   This overrides the interview conduct rules' quantification demands:
   the numbers still get recorded, but you compute them.
2. **explorer** — as 1, but introduce the proper term alongside each
   plain explanation and add short why-it-matters notes; teach while
   asking.
3. **builder** (default) — normal technical vocabulary; recommended
   option first with one-line trade-offs.
4. **engineer** — terse; jargon unexplained; ask for numbers directly
   (percentiles, RTO/RPO); rationale only on request.
5. **architect** — maximally terse; lead with trade-off matrices;
   challenge weak or inconsistent answers; the user drives, you record.

If the config file is missing and the task is interactive (any
interview, `query`, `onboarding`, `critique`), ask ONE question — "How
technical should I be with you?" with the five levels — then write the
config file with the answer plus defaults, and never ask again.
Non-interactive runs assume level 3 without asking.

## Hard rules

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
