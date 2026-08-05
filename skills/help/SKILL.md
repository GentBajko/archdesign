---
name: help
description: Use when asked what the archdesign plugin can do - prints the usage block.
---

# Archdesign: help

Run exactly one tool call and nothing else — the platform-appropriate
variant (both live in `../generate/scripts/` relative to this skill's
base directory):

```
bash <base>/../generate/scripts/help.sh                                  # macOS/Linux/Git Bash
powershell -ExecutionPolicy Bypass -File <base>\..\generate\scripts\help.ps1  # Windows
```

The script's stdout IS the help. Do not restate, summarize, or add any
text; if the harness requires a reply, output the script's stdout
verbatim and stop.
