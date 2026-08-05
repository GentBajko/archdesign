---
name: generate
description: Use when asked to generate, update, or refresh a codebase's architecture reference docs (DESIGN.md plus docs/design/ topic files), map the architecture, or document the data models, typing conventions, and module boundaries so AI sessions read docs instead of re-exploring the repo. Descriptive only; refreshes just the topics whose covered paths changed since their commit stamps.
---

# Archdesign: Codebase Architecture Reference Generator

Generate or refresh a descriptive architecture reference for the current
project: a lean `DESIGN.md` index at the project root plus topic files in
`docs/design/`. The audience is future Claude sessions — they read these
docs instead of re-exploring the repository.

**Announce at start:** "I'm using the archdesign skill to
generate/refresh the architecture reference."

## Hard rules

1. **Describe, never judge.** No recommendations, no grades, no
   comparisons to standards. If the codebase mixes paradigms, say where
   and how — not whether that is good. Sole exception: the
   explicitly-invoked `critique` subcommand (see Arguments).
2. **Write only `DESIGN.md` and `docs/design/*`.** Never touch source
   code, `openspec/`, or human-authored docs.
3. **Docs are skill-owned.** Re-runs may rewrite any generated section;
   manual edits are not preserved.
4. Follow `references/style.md` for every sentence you write.

## Arguments

Each subcommand is its own picker-visible plugin command
(`/archdesign:<name>`); the same words also work as arguments to this
skill (reserved words are parsed before topic names). To run one, read
`references/core.md` plus that one protocol file in
`references/protocols/<name>.md` — nothing else.

| Invocation | Behavior |
| --- | --- |
| `/archdesign:generate` | Generate if docs are missing; otherwise refresh stale topics |
| `/archdesign:generate rebuild` | Force a from-scratch rebuild of everything |
| `/archdesign:generate <topic>` | Regenerate that one topic file regardless of staleness (e.g. `models`) |
| `/archdesign:verify` | Read-only trust report: per-topic staleness + `file:line` pointer drift. No writes |
| `/archdesign:query <question>` | Answer an architecture question from the docs with citations, refreshing only the stale topics it touches |
| `/archdesign:changelog [<ref>]` | Architectural change history since `<ref>` (default: oldest stamp) → append to `docs/design/changelog.md` |
| `/archdesign:critique` | **Opt-in judgment** — prioritized improvement report → `docs/design/critique.md`, labeled as opinion |
| `/archdesign:runbooks [<task>]` | Task runbooks → `docs/design/runbooks/*.md`; no arg = standard set + project-derived workflows |
| `/archdesign:onboarding` | Guided reading path for new contributors → `docs/design/onboarding.md` |
| `/archdesign:design` | Greenfield mode: exhaustive one-question-at-a-time design interview persisted to `docs/design/interview.md`; complete only when every topic template section is answerable; then a formalization gate, then generate the full (prescriptive) reference |
| `/archdesign:discover` | Product-discovery mode, upstream of `design`: 3 seed questions, then adaptively generated questions (persisted to `docs/design/mockup-interview.md`) until the user stops or nothing would change the mockup; then a formalization gate, then a full traceable HTML mockup in `docs/design/mockup/` |
| `/archdesign:help` | Run `scripts/help.sh` via Bash — its stdout is the help; no analysis, no other output |

`critique` is the single exception to hard rule 1, and only because the
user explicitly invoked it; its output is labeled opinion and kept out
of the factual topic index. Voice rules per subcommand are in
`references/core.md`.

## help

On the `help` argument, run exactly one tool call and nothing else:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/generate/scripts/help.sh"
```

The script's stdout IS the help — it is the single source of truth for
the usage text. Do not restate, summarize, format, or add any text
before or after; if the harness requires a reply, output the script's
stdout verbatim and stop. No other file reads, no subagents, no
analysis.

## Phase 0 — Mode select

1. Check for `DESIGN.md` at the project root and stamped topic files in
   `docs/design/`.
2. If they exist and the argument is not `rebuild` → **refresh path**
   (see Refresh protocol below).
3. If a single topic argument was given → run Phase 1 recon, then
   Phases 2–4 for that topic only.
4. Otherwise → full generation (Phases 1–4).

## Phase 1 — Inline recon

Do this in the main session with cheap reads only:

1. Read dependency manifests that exist: `pyproject.toml`,
   `package.json`, `Cargo.toml`, `go.mod`.
2. Read type and lint configs: `tsconfig.json`, pyright config
   (`pyrightconfig.json` or `[tool.pyright]`), `mypy.ini`, eslint config.
3. Read `README*`, `CLAUDE.md`, `AGENTS.md` if present.
4. List the directory tree two to three levels deep, ignoring
   `node_modules`, `dist`, `build`, `.git`, and caches.
5. Identify entry points: main modules, CLI entries, server startup,
   route/command registries.
6. Build the **module map**: every top-level module or package, its
   one-line purpose, and its key entry-point files. All later phases and
   every subagent treat this map as authoritative.
7. Decide applicable topics using each topic's **Applicable** test in
   `references/topics.md`. Record inapplicable topics with a one-line
   reason; they appear in the index as absent.
8. Measure size: count tracked source files (`git ls-files` filtered to
   source extensions; `find` outside git).

## Phase 2 — Deep-dive

- **150 source files or fewer:** analyze each applicable topic inline
  yourself, against that topic's required sections and checklist in
  `references/topics.md`.
- **More than 150 source files:** dispatch one read-only subagent per
  applicable topic, in parallel. Each prompt must contain:
  1. The topic's required sections and checklist, copied from
     `references/topics.md`.
  2. The full module map from Phase 1, marked authoritative:
     "Do not re-derive the module map."
  3. The rules: read-only — modify nothing; facts only; a `file:line`
     pointer for every claim; no recommendations; return raw markdown
     matching the required sections, no preamble.

## Phase 3 — Compose

1. Write each topic file to `docs/design/<topic>.md` using the exact
   headings from `references/topics.md`, with this frontmatter:

```yaml
---
generated_at_commit: <short sha of HEAD>   # omit outside git
generated_date: <YYYY-MM-DD>
paths_covered:
  - "<glob>"
---
```

2. Choose `paths_covered` globs deliberately — they drive refresh
   staleness. Cover every directory the topic's content was derived from,
   but prefer the tightest globs that still do: package-level over
   repo-level, so unrelated commits don't mark the topic stale. Some
   topics (architecture, conventions) are legitimately repo-wide because
   they derive from whole-source scans — accept that rather than
   widening the others to match.
3. Write `DESIGN.md` **last**, so the index reflects what was actually
   generated. Structure:
   - Project one-liner, tech stack, and paradigm summary in a few lines.
   - Module map with `file:line` entry-point pointers.
   - Index table `| Topic | File | Commit | Generated |`, plus absent
     topics with their reasons.
   - If companion docs exist (`critique.md`, `changelog.md`,
     `onboarding.md`, `runbooks/`, `mockup/`, interview files), list
     them in a separate "Companion docs" table below the topic index —
     the factual reference and the opinionated/instructional outputs
     stay visibly distinct.
4. Monorepos: split a topic per subsystem
   (`architecture-frontend.md`, `architecture-backend.md`) when one file
   would be unwieldy; the index shows the split.

## Phase 4 — Verify

1. Re-read `DESIGN.md`: every topic link resolves to an existing file;
   every listed stamp matches that file's frontmatter.
2. Spot-check three `file:line` pointers across topic files against the
   actual source.
3. Report to the user: files written, topics skipped or absent and why.
4. If the generated files are untracked and not covered by `.gitignore`,
   ask the user whether to commit them or add `/DESIGN.md` and
   `/docs/design/` to `.gitignore` — never decide unilaterally. On later
   runs, respect whichever choice is already in place.

## Refresh protocol

For each existing topic file:

1. Read `generated_at_commit` and `paths_covered` from its frontmatter.
2. Run `git diff --stat <commit>..HEAD -- <globs>`.
3. **No changes** → skip; leave the file and its stamp untouched.
4. **Changes** → re-run that topic's Phase 2 deep-dive and rewrite the
   file.
5. Always re-verify the `DESIGN.md` module map and index rows.
6. Fall back to a full rebuild when the stamped commit is unreachable
   (rebase, shallow clone), there is no git repo, or the user passed
   `rebuild`.

## Non-git projects

Use `generated_date` only (no commit stamps). Every run is a full
generation.
