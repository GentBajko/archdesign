# Installing Archdesign for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

Add archdesign to the `plugin` array in your `opencode.json` (global or
project-level):

```json
{
  "plugin": ["archdesign@git+https://github.com/GentBajko/archdesign.git"]
}
```

Restart OpenCode. The plugin registers all archdesign skills (generate,
verify, query, changelog, critique, runbooks, onboarding, design,
discover, preferences, help).

Verify by asking: "Generate the architecture reference for this codebase."
