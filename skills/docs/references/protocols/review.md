# review — opt-in judgment (the one exception to "describe, never judge")

1. Ensure the reference is current (run the refresh path first if stale) —
   judgments must rest on verified facts.
2. Review across these dimensions, drawing evidence from the topic files
   and spot-checking source: boundary integrity (violations of the
   project's own layering), dead or unwired code, typing erosion
   (escape-hatch concentrations, protocol bypasses), failure-path risk
   (partial-failure consequences, swallowed errors), test-coverage gaps
   weighted by criticality, internal consistency (the project violating
   its own stated conventions), and — when
   `docs/design/code-prefs.md` exists — divergence between the user's
   stated preferences and the observed conventions.
3. Write `docs/design/review.md`: frontmatter stamps; a banner line
   "Opinion — generated judgment, not part of the factual reference.";
   findings ranked by severity, each with: the claim, evidence
   (`file:line`), why it matters, and a suggested direction (one
   sentence — no implementation plans).
4. Never edit code. Each rerun replaces the file. List it only under
   DESIGN.md's Companion docs table, never in the topic index.
