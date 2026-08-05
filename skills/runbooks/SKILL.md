---
name: runbooks
description: Use when asked to generate how-to runbooks for this project - run locally, deploy, and workflows derived from the project's own extension patterns (add a command, add a migration, ...) - written to docs/design/runbooks/. Part of the archdesign plugin.
---

# Archdesign: runbooks

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/SKILL.md` — its hard
   rules and style references govern this run.
2. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/references/subcommands.md`
   and execute the `## runbooks` protocol exactly.
3. The arguments passed to this invocation are the single guide to
   generate (optional; none = the standard set).
