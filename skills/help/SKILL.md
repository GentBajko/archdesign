---
name: help
description: Use when asked what the archdesign plugin can do or how to use its commands - prints the archdesign usage block listing every command. Equivalent to /archdesign:help.
---

# Archdesign: help

Run exactly one tool call and nothing else:

```
bash "${CLAUDE_PLUGIN_ROOT}/skills/generate/scripts/help.sh"
```

The script's stdout IS the help — the single source of truth for the
usage text. Do not restate, summarize, format, or add any text before
or after; if the harness requires a reply, output the script's stdout
verbatim and stop. No other file reads, no subagents, no analysis.
