# design — interview-driven architecture for a greenfield project

Design-time mode: there is no code to describe, so the reference is
built from an exhaustive interview instead. Three strict phases with a
user gate between the last two.

**The exhaustiveness criterion is twofold.** The interview is complete
only when (a) every applicable item in `../interview.md` — the merged
question inventory — has been asked, answered, or recorded as
not-applicable, AND (b) every required section of every applicable topic
in `../topics.md` can be written from recorded answers. Both are
checkable conditions — sweep them and ask about whatever is not yet
answerable. Never assume: any default you want to apply must be surfaced
as a question or an explicitly-confirmed default, not silently adopted.
Read `../interview.md` in full before asking the first question; its
Conduct rules section governs the whole interview. Then check for
upstream artifacts — each read only if it exists:
`docs/design/preferences.md`, `docs/design/mockup-interview.md`, and
the mockup itself (`docs/design/mockup/README.md`, plus individual
screens when a question touches the flows they depict — the screens
define scope, entities, and journeys that pre-fill models and data-flow
answers). Record everything they answer as derived decisions — never
re-ask it.

## Phase A — setup / resume

The interview state lives in `docs/design/interview.md`. If it exists,
read it and resume — never re-ask an answered question. If not, create
it:

```markdown
---
project: <name>
started: <date>
status: interviewing   # interviewing | awaiting-formalization | formalized
---

# Architecture Interview

## Decisions
(numbered Q&A entries appended here)

## Open questions
(the current queue, maintained every turn)
```

## Phase B — the interview loop

- **One question per turn.** Offer concrete options when the choice
  space is enumerable; open-ended otherwise. Ask follow-ups spawned by
  answers before moving to the next area.
- **Record immediately.** After each answer, append an entry before
  asking the next question — the file must survive a dead session:

  ```markdown
  ### Q<n> — <topic>/<section> (<date>)
  **Q:** <question as asked>
  **A:** <answer as given>
  **Decision:** <the normalized decision this implies>
  ```

  Decisions derivable from earlier answers are recorded as
  `### D<n> — derived` entries with the reasoning, not re-asked — but
  state them to the user as you go so wrong derivations get caught.
- **Question order:** walk `../interview.md` top to bottom — Framing
  (§0), then the one-way-door shape decisions (§1, with 2–3 candidates
  for macro-structure), then the topic-mapped checklists (§2), quality
  attributes with response measures (§3), the conditional modules that
  apply (§4), and the wrap-up sweep + red-flag screen (§5–6) before the
  gate.
- **Maintain the queue.** Rewrite `## Open questions` every turn so the
  file always shows what is still unknown. The interview ends when this
  list is empty after a full topics × sections sweep.

## Phase C — formalization gate

When the queue is empty, set `status: awaiting-formalization`, present
the complete decision summary organized by topic — including the agreed
walking-skeleton slice, the deferred-decisions list with their triggers,
the risk/assumption log, and any red-flag screen hits the user accepted
— and ask the user to formalize it. Amendments update the interview file
and re-run the sweep. Do not generate anything until the user explicitly
formalizes.

## Phase D — generation

On formalization, set `status: formalized` and write the full reference
— DESIGN.md plus every applicable topic file — exactly as a normal run
would, with these differences:

- Frontmatter gains `mode: prescriptive`; stamps are date-only unless a
  git repo already exists.
- Citations point at interview entries (`interview.md §Q12`) and at
  planned paths from the decided layout, since no code exists.
- `paths_covered` uses the planned layout's globs so the refresh
  protocol engages as soon as code appears.
- A banner on each file: "Prescriptive — written from the design
  interview, not from code."

**Lifecycle:** once code exists, a plain refresh (the `generate` skill)
replaces intent with observation topic by topic. Where implementation
diverges from the interview, record the divergence as a fact ("designed
as X (interview §Q7), implemented as Y (`file:line`)") — describing, not
judging.
