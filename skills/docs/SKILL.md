---
name: docs
description: Use when asked to generate, update, or refresh a codebase's architecture reference docs (DESIGN.md plus docs/design/ topic files), map the architecture, or document the data models, typing conventions, and module boundaries so AI sessions read docs instead of re-exploring the repo. Descriptive only; refreshes just the topics whose covered paths changed since their commit stamps.
---

# Capstone: Codebase Architecture Reference Generator

Generate or refresh a descriptive architecture reference for the current
project: a lean `DESIGN.md` index at the project root plus topic files in
`docs/design/`. The audience is future Claude sessions — they read these
docs instead of re-exploring the repository.

**Announce at start:** "I'm using the capstone skill to
generate/refresh the architecture reference."

## Hard rules

1. **Describe, never judge.** No recommendations, no grades, no
   comparisons to standards. If the codebase mixes paradigms, say where
   and how — not whether that is good. Sole exception: the
   explicitly-invoked `review` subcommand (see Arguments).
2. **Write only `DESIGN.md` and `docs/design/*`.** Never touch source
   code, `openspec/`, or human-authored docs.
3. **Docs are skill-owned.** Re-runs may rewrite any generated section;
   manual edits are not preserved.
4. Follow `references/style.md` for every sentence you write.

## Arguments

Each subcommand is its own skill in this plugin — on Claude Code and
Copilot CLI they appear as `/capstone:<name>` commands; on other
harnesses invoke them by skill name (`check-docs`, `ask`, `architecture`, …).
The same words also work as arguments to this skill (reserved words are
parsed before topic names). To run one, read `references/core.md` plus
that one protocol file in `references/protocols/<name>.md` — nothing
else.

| Invocation | Behavior |
| --- | --- |
| `/capstone:docs` | Generate if docs are missing; otherwise refresh stale topics |
| `/capstone:docs rebuild` | Force a from-scratch rebuild of everything |
| `/capstone:docs <topic>` | Regenerate that one topic file regardless of staleness (e.g. `models`) |
| `/capstone:check-docs` | Read-only trust report: per-topic staleness + `file:line` pointer drift. No writes |
| `/capstone:ask <question>` | Answer an architecture question from the docs with citations, refreshing only the stale topics it touches |
| `/capstone:changelog [<ref>]` | Architectural change history since `<ref>` (default: oldest stamp) → append to `docs/design/changelog.md` |
| `/capstone:review` | **Opt-in judgment** — prioritized improvement report → `docs/design/review.md`, labeled as opinion |
| `/capstone:guides [<task>]` | Task runbooks → `docs/design/guides/*.md`; no arg = standard set + project-derived workflows |
| `/capstone:onboarding` | Guided reading path for new contributors → `docs/design/onboarding.md` |
| `/capstone:architecture` | Greenfield mode: exhaustive one-question-at-a-time design interview persisted to `docs/design/architecture-interview.md`; complete only when every topic template section is answerable; then a formalization gate, then generate the full (prescriptive) reference |
| `/capstone:mockup` | Product-discovery mode, upstream of `architecture`: 3 seed questions, then adaptively generated questions (persisted to `docs/design/mockup-interview.md`) until the user stops or nothing would change the mockup; then a formalization gate, then a full traceable markdown mockup in `docs/design/mockup/` |
| `/capstone:code-prefs` | Code-preferences interview (typing, libraries-vs-reinvent, paradigm, errors, testing; persisted to `docs/design/code-prefs-interview.md`) → normative `docs/design/code-prefs.md`, consumed by `architecture` and `review` |
| `/capstone:logic` | Between `mockup` and `architecture`: scenario-by-scenario business-logic interview, depth first (persisted to `docs/design/logic-interview.md`) → one file per scenario in `docs/design/logic/`, consumed by `architecture` |
| `/capstone:help` | Run `scripts/help.sh` via Bash — its stdout is the help; no analysis, no other output |
| `/capstone:start` | Greenfield pipeline runner: `mockup` → `logic` → `architecture` → `code-prefs`, stage by stage, resuming at the first incomplete stage |

`review` is the single exception to hard rule 1, and only because the
user explicitly invoked it; its output is labeled opinion and kept out
of the factual topic index. Voice rules per subcommand are in
`references/core.md`.

## help

On the `help` argument, run exactly one tool call and nothing else —
the platform-appropriate variant from this skill's `scripts/` directory:

```
bash <base>/scripts/help.sh                                    # macOS/Linux/Git Bash
powershell -ExecutionPolicy Bypass -File <base>\scripts\help.ps1   # Windows
```

The script's stdout IS the help — it is the single source of truth for
the usage text. Do not restate, summarize, format, or add any text
before or after; if the harness requires a reply, output the script's
stdout verbatim and stop. No other file reads, no subagents, no
analysis.

## Phase 0 — Mode select

0. Read `references/core.md` — shared rules and the user config
   (`docs/design/capstone.json`: expertise level, docs_dir,
   index_file, subagent_threshold, docs_in_git, language). Config keys
   override the defaults named below.
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

- **At or below the subagent threshold (default 150 source files):**
  analyze each applicable topic inline yourself, against that topic's
  required sections and checklist in `references/topics.md`.
- **Above the threshold:** dispatch one read-only subagent per
  applicable topic, in parallel (if your harness has no subagent
  capability, analyze the topics sequentially inline instead). Each
  subagent prompt must contain:
  1. The topic's required sections and checklist, copied from
     `references/topics.md`.
  2. The full module map from Phase 1, marked authoritative:
     "Do not re-derive the module map."
  3. The rules: read-only — modify nothing; facts only; a `file:line`
     pointer for every claim; no recommendations; return raw markdown
     matching the required sections, no preamble.

## Phase 3 — Compose

1. Write each topic file **chapterized** — a numbered prefix in reading
   order so the folder itself reads like a table of contents:
   `01-architecture.md`, `02-models.md`, `03-conventions.md`,
   `04-data-flow.md`, `05-dependencies.md`, `06-testing.md`,
   `07-operations.md`, `08-glossary.md` (skip absent topics without
   renumbering). If unnumbered topic files exist from an earlier
   version, rename them to the chapter names during the run and update
   every cross-reference. Use the exact headings from
   `references/topics.md`, with this frontmatter:

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
3. Ensure the config file exists by running the platform-appropriate
   initializer from this skill's `scripts/` directory (idempotent —
   never overwrites): `bash scripts/init-config.sh <docs_dir>` on
   macOS/Linux/Git Bash, or `powershell -ExecutionPolicy Bypass -File
   scripts\init-config.ps1 <docs_dir>` on Windows. If neither shell is
   available, write the JSON template from `references/core.md`
   yourself.
4. Write `DESIGN.md` **last**, so the index reflects what was actually
   generated. Structure:
   - Project one-liner, tech stack, and paradigm summary in a few lines.
   - Module map with `file:line` entry-point pointers.
   - Index table `| Topic | File | Commit | Generated |`, plus absent
     topics with their reasons.
   - If companion docs exist (`review.md`, `changelog.md`,
     `onboarding.md`, `code-prefs.md`, `guides/`, `mockup/`), list
     them in a separate "Companion docs" table below the topic index —
     the factual reference and the opinionated/instructional outputs
     stay visibly distinct. Interview Q&A files are never indexed.
5. Monorepos: split a topic per subsystem
   (`architecture-frontend.md`, `architecture-backend.md`) when one file
   would be unwieldy; the index shows the split.

## Phase 4 — Verify

1. Re-read `DESIGN.md`: every topic link resolves to an existing file;
   every listed stamp matches that file's frontmatter.
2. Spot-check three `file:line` pointers across topic files against the
   actual source.
3. Report to the user: files written, topics skipped or absent and why.
4. If the generated files are untracked and not covered by `.gitignore`:
   honor the `docs_in_git` config key when set (`commit` or `ignore`);
   when it is `ask` or unset, ask the user whether to commit them or add
   `/DESIGN.md` and `/docs/design/` to `.gitignore` — never decide
   unilaterally. On later runs, respect whichever choice is in place.

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
