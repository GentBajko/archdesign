---
name: verify
description: Use when asking whether the architecture reference docs (DESIGN.md + docs/design/) are still current or trustworthy - read-only report of per-topic staleness and file:line pointer drift, no writes. Part of the archdesign plugin.
---

# Archdesign: verify

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/SKILL.md` — its hard
   rules and style references govern this run.
2. Read `${CLAUDE_PLUGIN_ROOT}/skills/generate/references/subcommands.md`
   and execute the `## verify` protocol exactly.
3. Treat any arguments passed to this invocation as the subcommand's
   arguments.
