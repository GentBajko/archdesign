# preferences — code-preferences interview, then a normative standards doc

Elicits how the user **wants** code written in this project — independent
of what the code currently does. The output is normative (the one other
place besides `critique` allowed to say "do X, never Y" — because every
rule is the user's own recorded decision, not the skill's opinion).

Interview state: `docs/design/preferences-interview.md` — same resumable
format as the other interviews (status frontmatter, `### Q<n>` entries
appended before the next question, live `## Open questions` queue).
Interview files are never indexed. Output:
`docs/design/preferences.md` — indexed under Companion docs.

## Phase A — setup / resume

Read the interview file if it exists and resume; never re-ask. If the
codebase already exists and the conventions topic
(`docs/design/conventions.md`) is present, read it first: ask preference
questions as confirmations of observed reality ("the code currently uses
exceptions everywhere — preference or accident?") rather than from
scratch.

## Phase B — the interview

One question per turn; offer concrete options when enumerable; adaptive
follow-ups until each answer is concrete; record the normalized decision
immediately. Walk these domains, skipping any the user rules out:

- **Typing**: strict or loose; escape-hatch policy (`Any`, casts,
  ignores); structural (protocols/interfaces) vs nominal; enums vs raw
  strings; annotation coverage expectations.
- **Libraries vs reinventing**: default posture (buy/adopt vs build);
  preferred libraries per capability (HTTP, validation, ORM, testing,
  state, CLI, ...); the vetting bar (maturity, license, bus factor);
  dependency budget and when hand-rolling is preferred.
- **Paradigm**: OO / functional / procedural mix; immutability stance;
  inheritance policy; dependency-injection style.
- **Error handling**: exceptions vs result types; error taxonomy;
  logging rules; what must never be swallowed.
- **Organization**: package-by-feature vs by-layer; file-size
  discipline; naming conventions; comment and docstring policy.
- **Testing**: TDD or not; fakes vs mocks; coverage philosophy; what
  must always have tests.
- **Tooling**: formatter, linter and strictness, type-checker config.
- **Process**: commit message style; PR conventions (keep light).
- **Agent rules**: anything an AI assistant must always or never do in
  this codebase.

## Phase C — the gate

When the queue is empty (or the user stops), present the decision
summary by domain and ask the user to formalize. Do not write the output
until they do.

## Phase D — the output

Write `docs/design/preferences.md`: frontmatter stamps (no
`paths_covered` — preferences don't go stale with code); banner
"User-stated preferences — normative, not a description of current
code."; rules organized by the domains above, each traceable to its
`§Q` entry; imperative voice.

Then update the DESIGN.md index per core.md, and suggest — never do
unasked — seeding the project's `AGENTS.md`/`CLAUDE.md` from it.

**Consumers:** the `design` interview pre-fills its conventions answers
from this file and never re-asks; `critique` gains a
preference-divergence dimension when this file exists.
