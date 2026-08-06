# Installing Capstone for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

Add capstone to the `plugin` array in your `opencode.json` (global or
project-level):

```json
{
  "plugin": ["capstone@git+https://github.com/GentBajko/capstone.git"]
}
```

Restart OpenCode. The plugin registers all capstone skills (generate,
verify, query, changelog, critique, runbooks, onboarding, design,
discover, logic, preferences, help).

Verify by asking: "Generate the architecture reference for this codebase."
