#!/usr/bin/env bash
# Prints archdesign usage. Single source of truth for the help text.
cat <<'EOF'
archdesign — codebase architecture reference generator

Usage: /archdesign:<command>

  generate             Generate docs if missing; otherwise refresh stale topics
  generate rebuild     Force a from-scratch rebuild of everything
  generate <topic>     Regenerate one topic file regardless of staleness
                       (architecture, models, conventions, data-flow,
                        dependencies, testing, operations, glossary)
  verify               Read-only trust report: topic staleness + pointer drift
  query <question>     Answer an architecture question from the docs, with citations
  critique             Opt-in judgment: prioritized improvement report -> critique.md
  changelog [<ref>]    Architectural change history since <ref> -> changelog.md
  runbooks [<task>]    How-to guides: run-locally, deploy, project workflows
  onboarding           Guided reading path for new contributors -> onboarding.md
  design               Greenfield: exhaustive architecture interview -> prescriptive reference
  discover             Product discovery: seed + adaptive interview -> traceable HTML mockup
  logic                Business-logic interview, scenario by scenario -> docs/design/logic/
  preferences          Code-preferences interview -> normative preferences.md
  help                 Show this message

Output: DESIGN.md (root index) + docs/design/*.md topic files, each stamped
with the commit it was derived at. Re-runs refresh only drifted topics.
Docs are strictly descriptive; only `critique` judges.

Config: docs/design/archdesign.json — expertise 1-5 (vibe coder ...
architect; how technical conversations are, asked once then saved),
docs_dir, index_file, subagent_threshold, docs_in_git, language.
EOF
