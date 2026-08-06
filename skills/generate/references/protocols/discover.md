# discover — adaptive product-discovery interview, then the full mockup

Upstream of `design`: defines the product (purpose, business plan, usage
scenarios) before any architecture exists. Philosophy is the opposite of
`design`'s checklist-driven interview — only the seed questions are
predetermined; every question after them must be **generated from the
answers**.

## The generation rule

After each answer, ask yourself: "If I had to build the full mockup
right now, what would I have to invent?" The next question is whatever
tops that list. The interview is complete when the user says stop, or
when nothing remains that would change the mockup.

## Phase A — setup / resume

State lives in `docs/design/mockup-interview.md`, same resumable format
as `design`'s interview file (frontmatter with `status: interviewing |
awaiting-formalization | formalized`, numbered `### Q<n>` entries with
question, answer as given, and normalized decision, plus a live
`## Open threads` list rewritten every turn). Append each entry before
asking the next question. Resume = read the file, never re-ask.

## Phase B — the seeds (the only predetermined questions)

1. "Describe the project as you would to a friend — what is it, and why
   should it exist?"
2. "Who exactly is it for, and what do they do today instead?"
3. "A year after launch, what does success look like — in numbers if you
   can?"

## Phase C — generated questions

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

## Phase D — the gate

Set `status: awaiting-formalization`; present the summary organized as
purpose / business plan / scenarios, plus what is still vague. The user
formalizes or amends; do not generate until they do.

## Phase E — the mockup

On formalization, write `docs/design/mockup/`: one static
self-contained HTML file per screen the scenarios imply (no external
deps), each annotated with the scenario and `§Q` entries it implements.
The mockup's **only index is `README.md`** — a markdown table mapping
screens → scenarios → interview entries, with anything invented marked
"assumed" there for the user to review. Do not generate an index.html.
Use the frontend-design skill if available for visual quality; every
element must trace to an interview answer.

**Handoff:** the `design` skill run afterwards must read
`mockup-interview.md` first and never re-ask what it already answers —
its framing section (§0 of `../interview.md`) is largely pre-filled by
this interview.
