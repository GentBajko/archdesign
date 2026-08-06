# logic — scenario-by-scenario business-logic interview

Sits between `mockup` and `architecture`: takes every scenario the product
has and lays its business logic bare — one scenario at a time, depth
first, until a developer could implement it without inventing a single
rule. Like `code-prefs`, the output is normative but records only the
user's own stated decisions.

Interview state: `docs/design/logic-interview.md` (same resumable
format; never indexed). Output: `docs/design/logic/` — one chapterized
file per scenario (`01-<scenario>.md`, `02-…`), the folder indexed under
Companion docs.

## Phase A — setup / resume

Resume from the interview file if present. Build the scenario list:
from `docs/design/mockup/README.md` and `mockup-interview.md` if they
exist (each journey/screen flow is a candidate scenario — confirm the
list with the user); otherwise elicit it ("walk me through everything a
user can do, headline by headline"). Order by importance; record the
agreed list.

## Phase B — one scenario at a time, depth first

Finish a scenario completely before touching the next. The generation
rule: **"if I had to implement this scenario right now, what rule would
I have to invent?"** — the next question is whatever tops that list.
One question per turn; concrete options when enumerable; per the
expertise level in config.

Per scenario, cover until nothing is left to invent:

- **Trigger & preconditions** — who starts it, from where, in what
  state; what must already be true.
- **Steps** — the happy path, numbered, each step's exact rule: what is
  checked, what is computed (formulas, limits, rounding — exact
  numbers), what is read/written, who is allowed.
- **Branches** — every decision point and the rule that decides it.
- **Unhappy paths** — for each step: what if it fails, is invalid,
  happens twice, happens late, happens concurrently, is cancelled
  midway? Expected behavior for each, including what the user sees.
- **State transitions** — which entity lifecycle states this scenario
  moves, and which transitions are forbidden.
- **Invariants** — what must never be true afterwards, no matter what.
- **Outcomes & side effects** — success and failure endings;
  notifications, records, money moved.

When a scenario has nothing left to invent, present its summary, get
the user's confirmation ("laid bare?"), then write
`docs/design/logic/<NN>-<scenario>.md` immediately — sections exactly
as the bullets above, every rule traceable to its `§Q` entry — and move
to the next scenario. The user may stop at any point; written scenarios
stand, the remaining list is recorded in the interview file.

## Phase C — wrap

When all scenarios are written (or the user stops), update the index
per core.md (one Companion docs row for `logic/`), and note any
cross-scenario contradictions discovered — surface them as questions,
not verdicts.

**Consumers:** `architecture` reads `docs/design/logic/` to pre-fill models
(entities, invariants, consistency needs), data-flow (lifecycles), and
quality-attribute scenarios — never re-asking what a scenario file
answers.
