---
name: query
description: Use when asking a question about this codebase's architecture that the generated docs/design reference can answer - cited Q&A from the docs, refreshing only the stale topics the question touches. Part of the archdesign plugin.
---

# Archdesign: query

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/SKILL.md` — its hard
   rules and style references govern this run.
2. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/references/subcommands.md`
   and execute the `## query` protocol exactly.
3. The arguments passed to this invocation are the question.
