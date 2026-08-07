# Prints capstone usage. Keep in sync with help.sh (same text; lint-sync.ps1 asserts it).
Write-Output @'
capstone — codebase architecture reference generator

Usage: /capstone:<command>

  start                Run the greenfield pipeline stage by stage:
                       mockup -> logic -> architecture -> code-prefs
                       (resumes at the first incomplete stage; also
                        triggers on a bare "capstone" prompt)

  docs                 Generate the reference docs; refresh stale topics on re-runs
  docs rebuild         Force a from-scratch rebuild of everything
  docs <topic>         Regenerate one topic file regardless of staleness
                       (architecture, models, conventions, data-flow,
                        dependencies, testing, operations, glossary)
  check-docs           Read-only trust report: topic staleness + pointer drift
  ask <question>       Answer an architecture question from the docs, with citations
  review               Opt-in judgment: prioritized improvement report -> review.md
  changelog [<ref>]    Architectural change history since <ref> -> changelog.md
  guides [<task>]      How-to guides: run-locally, deploy, project workflows
  onboarding           Guided reading path for new contributors -> onboarding.md
  mockup               Product discovery: seed + adaptive interview -> traceable markdown mockup
  logic                Business-logic interview, scenario by scenario -> docs/design/logic/
  architecture         Greenfield: exhaustive architecture interview -> prescriptive reference
  code-prefs           Code-preferences interview -> normative code-prefs.md
  help                 Show this message

Output: DESIGN.md (root index) + docs/design/*.md topic files, each stamped
with the commit it was derived at. Re-runs refresh only drifted topics.
Docs are strictly descriptive; only `review` judges.

Config: docs/design/capstone.json — expertise 1-5 (vibe coder ...
architect; how technical conversations are, asked once then saved),
docs_dir, index_file, subagent_threshold, docs_in_git, language, pipeline.
'@
