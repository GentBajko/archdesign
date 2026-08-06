# start — the greenfield pipeline, one stage at a time

Entry point when the user says just "capstone" or asks to start or
continue the pipeline. Runs the interview chain in order, resuming
wherever it stopped:

1. `mockup` → `docs/design/mockup/` (+ `mockup-interview.md`)
2. `logic` → `docs/design/logic/` (+ `logic-interview.md`)
3. `architecture` → the prescriptive reference
   (+ `architecture-interview.md`)
4. `code-prefs` → `docs/design/code-prefs.md`
   (+ `code-prefs-interview.md`)

## Procedure

1. Per core.md: read the config (expertise governs every stage's
   conversation).
2. Determine each stage's state from its interview file and output:
   **not started** (no interview file) / **in progress** (status
   `interviewing` or `awaiting-formalization`) / **done** (status
   `formalized` and the output exists).
3. Show the pipeline as a short checklist (done / in progress /
   pending) so the user sees where they are.
4. If the project already has source code and no stage has started,
   ask once whether they want this greenfield pipeline or `docs` (the
   reference generator) — "capstone" alone on an existing codebase
   usually means `docs`.
5. Run the first non-done stage by executing its protocol file
   (`mockup.md`, `logic.md`, `architecture.md`, `code-prefs.md`)
   exactly — including its own formalization gate. Do not blend
   stages.
6. When a stage formalizes, announce it in one line and continue to
   the next ("mockup done — moving to logic; say stop to pause").
   Stopping is always safe: every stage persists its interview file,
   and the next `start` resumes exactly here.
7. After `code-prefs`, close out: point at everything generated, and
   note that once code exists, plain `docs` runs replace prescriptive
   intent with observed fact.
