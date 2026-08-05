---
name: changelog
description: Use when asked how the architecture changed since a commit or ref - reads the git diff at architecture level (modules, boundaries, routes, tables, dependencies) and appends a dated entry to docs/design/changelog.md. Part of the archdesign plugin.
---

# Archdesign: changelog

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/SKILL.md` — its hard
   rules and style references govern this run.
2. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/references/subcommands.md`
   and execute the `## changelog` protocol exactly.
3. The arguments passed to this invocation are the base ref (optional).
