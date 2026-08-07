# Capstone

AI coding agents have no memory. Every session starts with your agent
poking around the repo, guessing at module boundaries, and rebuilding a
mental model it throws away an hour later. You pay for that in tokens
and minutes, every day, and the model still gets things subtly wrong.

Capstone is the fix. It writes architecture docs meant for an AI
reader, stamps them with the git commit they came from, and on later
runs rewrites only the parts the code actually changed. Your agent
opens one index and eight chapters and already knows the codebase. No
exploration phase, no guessing.

For new projects it works in the other direction: four interviews that
pull the product, the business rules, the architecture, and your coding
taste out of your head before any code exists.

It runs in Claude Code, Copilot CLI, Gemini CLI, Antigravity, and
OpenCode today. Codex, Cursor, and Kimi manifests ship in the repo but
those stores need a listing first. The skills are plain `SKILL.md`
files, so wherever skills work, this works.

## The docs

`/capstone:docs` on an existing repo produces a `DESIGN.md` index and
eight numbered chapters in `docs/design/`:

```
01-architecture.md   layers, boundaries, entry points, dispatch tables
02-models.md         entities, relationships, schema DDL, validation
03-conventions.md    paradigm, typing level, error handling, DI
04-data-flow.md      lifecycles hop by hop, state ownership, failure paths
05-dependencies.md   every package, what it's for, where it's wired
06-testing.md        layout, test doubles, coverage shape
07-operations.md     how to run it, env vars, infra, deploy
08-glossary.md       the domain words your codebase invented
```

Everything is facts with `file:line` citations. No advice, no grades,
no "consider refactoring". The one exception is `/capstone:review`,
which judges only because you asked it to.

Refreshes are cheap. Each chapter's frontmatter lists the paths it was
derived from; `git diff` against the stamped commit decides what's
stale. Untouched chapters are never rewritten. `/capstone:check-docs`
reports staleness without writing anything, and `/capstone:ask` answers
questions from the docs with citations instead of re-reading your
source.

## The four interviews

Type `capstone` with nothing else and it runs them in order, resuming
wherever you stopped last time. Or run any one directly. Every answer
is written to a file before the next question, so a dead session loses
nothing.

### mockup

Product discovery. Three fixed questions (what is it, who's it for,
what does success look like in numbers), then every question after that
is generated from your answers. The driving rule: "if I had to build
the mockup right now, what would I have to invent?" It keeps asking
until the answer is nothing, or you tell it to stop. You get one
markdown file per screen — an ASCII wireframe, every element with its
exact copy and behavior, the empty/error/success states — each
annotated with the interview answers it implements. Anything it had to
assume is flagged for you to check.

### logic

A mockup shows what screens exist; `logic` pins down what actually
happens. It takes one scenario at a time and walks it until a developer
could implement it without inventing a single rule: the exact steps,
the formulas with real numbers, what happens when the payment fails,
when the user clicks twice, when two people edit at once. One markdown
file per scenario. This is the part of a spec that everyone skips and
then pays for.

### architecture

The big interview. It isn't done until every section of the future docs
is answerable from your recorded decisions. One question at a time. It
reads the mockup and logic files first and never re-asks what they
already answer. At the end you approve the summary, and it writes the
same eight chapters as `docs`, marked prescriptive. Once real code
exists, refresh runs replace intent with observation and note where the
implementation diverged from the plan.

### code-prefs

How you want code written: strict typing or loose, a library or
hand-rolled, exceptions or result types, what an AI assistant must
never do in your repo. If a codebase already exists it reads the
conventions chapter first and asks "the code does X everywhere, is that
a preference or an accident?" The output is a normative doc that the
architecture interview and `review` both consume. It's also a decent
starting point for a CLAUDE.md.

## Who it's for

If you vibe-code: set `expertise: 1` and the interviews switch to plain
language. It asks how many people might use the thing, not what your
p99 latency budget is, then derives the technical targets itself and
confirms them in words you can sanity-check. You end up with real specs
and real docs anyway, because expertise changes the conversation, never
the output.

If you're a seasoned engineer: set `expertise: 5`, get terse questions
and trade-off tables, and skip the hand-holding. The value for you is
the maintained reference: agents stop re-deriving your layering every
session, and stop guessing wrong about it.

## Settings

First run creates `docs/design/capstone.json` with every key spelled
out:

```json
{
  "expertise": null,
  "docs_dir": "docs/design",
  "index_file": "DESIGN.md",
  "subagent_threshold": 150,
  "docs_in_git": "ask",
  "language": "en",
  "pipeline": null
}
```

`expertise` is 1 to 5 as above. It starts `null` so the first
interactive command asks once, saves your answer, and never asks again.
`docs_in_git` set to `"commit"` or `"ignore"` skips the question about
whether generated docs belong in version control, which also makes
headless runs possible. `subagent_threshold` is the source-file count
above which `docs` fans out parallel subagents instead of reading
everything itself. `pipeline` records the answer to the one-time
question `start` asks on repos that already have code: pipeline or
docs.

## Install

Claude Code:

```
/plugin marketplace add GentBajko/capstone
/plugin install capstone@capstone-marketplace
```

Copilot CLI uses the same marketplace format:

```bash
copilot plugin marketplace add GentBajko/capstone
copilot plugin install capstone@capstone-marketplace
```

Gemini CLI: `gemini extensions install https://github.com/GentBajko/capstone`

Antigravity: `agy plugin install https://github.com/GentBajko/capstone`

OpenCode, in `opencode.json`:

```json
{ "plugin": ["capstone@git+https://github.com/GentBajko/capstone.git"] }
```

Commands come out namespaced (`/capstone:docs`). If you want a bare
`/capstone` in Claude Code, drop this in `~/.claude/commands/capstone.md`:

```markdown
---
description: Capstone entry - no args runs the pipeline; args route to the matching skill
argument-hint: [command] [args...]
---

No arguments: invoke the capstone:start skill. If the first argument
matches a capstone skill (docs, check-docs, ask, changelog, review,
guides, onboarding, mockup, logic, architecture, code-prefs, start, help),
invoke capstone:<that skill> with the remaining arguments.

ARGUMENTS: $ARGUMENTS
```

## Commands

| Command | What it does |
| --- | --- |
| `/capstone:start` | The pipeline: mockup, then logic, then architecture, then code-prefs, resuming at the first unfinished stage |
| `/capstone:docs` | Generate or refresh the reference (`rebuild` forces, a topic name targets one chapter) |
| `/capstone:check-docs` | Staleness and citation-drift report, read-only |
| `/capstone:ask <question>` | Answer from the docs, with citations |
| `/capstone:changelog [<ref>]` | Architecture-level change history since a ref |
| `/capstone:review` | The opt-in judgment: ranked findings with evidence |
| `/capstone:guides [<task>]` | Runbooks: run locally, deploy, plus workflows mined from your repo's patterns |
| `/capstone:onboarding` | A reading path for someone's first day in the codebase |
| `/capstone:mockup` | Interview 1, standalone |
| `/capstone:logic` | Interview 2, standalone |
| `/capstone:architecture` | Interview 3, standalone |
| `/capstone:code-prefs` | Interview 4, standalone |
| `/capstone:help` | Usage. In Claude Code a hook answers this before the model is invoked, so it costs zero tokens |

## Rough edges

The zero-token help trick is Claude Code only; other harnesses spend one
small model turn on it. The PowerShell scripts are syntax-checked but
not yet tested on a real Windows box. The `logic` interview on a real
app is an afternoon, not ten minutes, and that's by design. Retrieval
is grep over eight markdown files, which is plenty at this scale and
unproven on giant monorepos.

MIT. Issues and PRs welcome.
