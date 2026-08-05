# Subcommand Protocols

Reserved words (`rebuild`, `verify`, `query`, `changelog`, `critique`,
`runbooks`, `onboarding`, `design`, `discover`, `help`) are parsed
before topic names. `help` just runs `scripts/help.sh` (one Bash call,
its stdout is the help, no analysis); it has no protocol here — the
script is the single source of truth for the usage text, so update it
whenever the command surface changes.

Each subcommand (except `rebuild`, which is a plain argument) also has a
picker-visible thin wrapper skill at
`${CLAUDE_PLUGIN_ROOT}/skills/<name>/SKILL.md` that delegates to the
protocol here (`help` runs the same script).
When adding, renaming, or removing a subcommand, update its wrapper too.
Everything a subcommand writes is skill-owned and carries the same
frontmatter stamps as topic files (`generated_at_commit`,
`generated_date`, plus `paths_covered` where the refresh protocol
applies).

Voice rules: `verify`/`query`/`changelog` follow `style.md` unchanged
(facts only). `critique` is the one explicitly opinionated output.
`runbooks` and `onboarding` may use imperative/narrative voice, but
every command must be verified and every step must cite the files it
touches — the density and naming rules of `style.md` still bind.

## verify — read-only trust report

No writes. Two parts:

1. **Staleness**: for each topic file, read its stamp and `paths_covered`,
   run `git diff --stat <stamp>..HEAD -- <globs>`, and report a table:
   topic | stamp | files changed since | verdict (current / stale /
   stamp unreachable).
2. **Pointer drift**: sample ≥5 `file:line` pointers across different
   topic files, check each against the source, and report hits/misses
   with the drifted lines' new locations when findable.

End with one sentence: whether the reference can be trusted as-is, needs
`/archdesign:generate` (refresh), or needs `/archdesign:generate rebuild`.

## query <question> — cited Q&A

1. From the DESIGN.md index, pick the topics the question touches.
2. Run the `verify` staleness test on just those topics; refresh any
   that are stale before answering.
3. Answer from the docs, citing the doc sections and the `file:line`
   pointers they carry. Spot-check pointers you rely on.
4. If the docs cannot answer, say so explicitly, answer from targeted
   code reading instead, and name which topic file should have covered
   it — that gap is a template bug worth reporting to the user.

## changelog [<ref>] — architectural change history

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

## critique — opt-in judgment (the one exception to "describe, never judge")

1. Ensure the reference is current (run the refresh path first if stale) —
   judgments must rest on verified facts.
2. Review across these dimensions, drawing evidence from the topic files
   and spot-checking source: boundary integrity (violations of the
   project's own layering), dead or unwired code, typing erosion
   (escape-hatch concentrations, protocol bypasses), failure-path risk
   (partial-failure consequences, swallowed errors), test-coverage gaps
   weighted by criticality, and internal consistency (the project
   violating its own stated conventions).
3. Write `docs/design/critique.md`: frontmatter stamps; a banner line
   "Opinion — generated judgment, not part of the factual reference.";
   findings ranked by severity, each with: the claim, evidence
   (`file:line`), why it matters, and a suggested direction (one
   sentence — no implementation plans).
4. Never edit code. Each rerun replaces the file. List it only under
   DESIGN.md's Companion docs table, never in the topic index.

## runbooks [<task>] — how-to guides

Output: `docs/design/runbooks/<slug>.md`, one file per guide,
frontmatter with stamps and `paths_covered` (the guide participates in
the normal refresh protocol).

With no argument, generate the applicable standard set:
- `run-locally` and `deploy` (from the operations topic's facts),
- plus 2–4 workflows derived from the project's own extension patterns —
  read the architecture topic and pick the seams a contributor most
  likely extends (e.g. for a command-dispatch engine: add a command +
  handler + test; for a migration-managed DB: add a migration; for a
  registry-driven domain: add a registry entry).

With an argument, generate that one guide.

Guide format: goal (one line) → prerequisites → numbered steps, each
citing the file it touches and quoting exact commands → how to verify it
worked. Commands must come from verified sources (manifests, compose
files, README, or tested patterns in the repo) — never invented. If a
step cannot be verified, mark it "unverified" inline.

## discover — adaptive product-discovery interview, then the full mockup

Upstream of `design`: defines the product (purpose, business plan, usage
scenarios) before any architecture exists. Philosophy is the opposite of
`design`'s checklist-driven interview — only the seed questions are
predetermined; every question after them must be **generated from the
answers**.

### The generation rule

After each answer, ask yourself: "If I had to build the full mockup
right now, what would I have to invent?" The next question is whatever
tops that list. The interview is complete when the user says stop, or
when nothing remains that would change the mockup.

### Phase A — setup / resume

State lives in `docs/design/mockup-interview.md`, same resumable format
as `design`'s interview file (frontmatter with `status: interviewing |
awaiting-formalization | formalized`, numbered `### Q<n>` entries with
question, answer as given, and normalized decision, plus a live
`## Open threads` list rewritten every turn). Append each entry before
asking the next question. Resume = read the file, never re-ask.

### Phase B — the seeds (the only predetermined questions)

1. "Describe the project as you would to a friend — what is it, and why
   should it exist?"
2. "Who exactly is it for, and what do they do today instead?"
3. "A year after launch, what does success look like — in numbers if you
   can?"

### Phase C — generated questions

One per turn, each derived from prior answers via the generation rule.
Angles to mine (a compass, not a checklist):

- **Purpose**: the problem, why now, non-goals, what it must never become.
- **Business plan**: who pays and how much; pricing model; market size
  and reachable slice; competition and the differentiator; acquisition
  channel; unit economics; run costs; regulatory exposure; biggest risk.
- **Scenarios**: personas; each core journey walked step by step ("then
  what happens?"); the first-run experience; unhappy paths and edge
  users; frequency of use; a day-in-the-life.
- **Probes**: vague words → numbers; contradictions between answers;
  superlatives ("simple", "seamless") → what specifically; unstated
  assumptions said back for confirmation.

Drill each answer until concrete before moving on. The user may stop at
any time — jump to Phase D and record remaining vagueness honestly.

### Phase D — the gate

Set `status: awaiting-formalization`; present the summary organized as
purpose / business plan / scenarios, plus what is still vague. The user
formalizes or amends; do not generate until they do.

### Phase E — the mockup

On formalization, write `docs/design/mockup/`: static self-contained
HTML (no external deps), an index page linking every screen the
scenarios imply, each screen annotated with the scenario and `§Q`
entries it implements. Use the frontend-design skill if available for
visual quality. Every element must trace to an interview answer;
anything invented is marked "assumed" in the screen annotation and
listed on the index page for the user to review. Add a `README.md`
mapping screens → scenarios → interview entries.

**Handoff:** `/archdesign:design` run afterwards must read
`mockup-interview.md` first and never re-ask what it already answers —
its framing section (§0 of `interview.md`) is largely pre-filled by this
interview.

## design — interview-driven architecture for a greenfield project

Design-time mode: there is no code to describe, so the reference is
built from an exhaustive interview instead. Three strict phases with a
user gate between the last two.

**The exhaustiveness criterion is twofold.** The interview is complete
only when (a) every applicable item in `references/interview.md` — the
merged question inventory — has been asked, answered, or recorded as
not-applicable, AND (b) every required section of every applicable topic
in `topics.md` can be written from recorded answers. Both are checkable
conditions — sweep them and ask about whatever is not yet answerable.
Never assume: any default you want to apply must be surfaced as a
question or an explicitly-confirmed default, not silently adopted.
Read `references/interview.md` in full before asking the first question;
its Conduct rules section governs the whole interview.

### Phase A — setup / resume

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

### Phase B — the interview loop

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
- **Question order:** walk `references/interview.md` top to bottom —
  Framing (§0), then the one-way-door shape decisions (§1, with 2–3
  candidates for macro-structure), then the topic-mapped checklists
  (§2), quality attributes with response measures (§3), the conditional
  modules that apply (§4), and the wrap-up sweep + red-flag screen
  (§5–6) before the gate.
- **Maintain the queue.** Rewrite `## Open questions` every turn so the
  file always shows what is still unknown. The interview ends when this
  list is empty after a full topics × sections sweep.

### Phase C — formalization gate

When the queue is empty, set `status: awaiting-formalization`, present
the complete decision summary organized by topic — including the agreed
walking-skeleton slice, the deferred-decisions list with their triggers,
the risk/assumption log, and any red-flag screen hits the user accepted
— and ask the user to formalize it. Amendments update the interview file
and re-run the sweep. Do not generate anything until the user explicitly
formalizes.

### Phase D — generation

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

**Lifecycle:** once code exists, plain `/archdesign:generate` refresh replaces
intent with observation topic by topic. Where implementation diverges
from the interview, record the divergence as a fact ("designed as X
(interview §Q7), implemented as Y (`file:line`)") — describing, not
judging.

## onboarding — reading path

Output: `docs/design/onboarding.md`, frontmatter stamps. A guided tour
for a new contributor, ordered: each stop names the file or doc to read,
why now, and 1–3 things to notice there. Start at DESIGN.md; route
through the code's load-bearing files (entry point, dispatch, one
representative handler, the persistence seam); end by pointing at the
runbook guides and the test suite's conventions. ~10 stops maximum;
narrative voice allowed; every stop cites its target.
