#!/usr/bin/env bash
# UserPromptExpansion hook: answers /capstone:help without ever invoking
# the model. The reason text is sourced from help.sh (single source of
# truth) — keep that file free of double quotes and backslashes so the
# JSON escaping below stays trivial. Non-matching prompts pass through.
INPUT="$(cat)"
if printf '%s' "$INPUT" | grep -Eq '"user_prompt": ?"/capstone:help'; then
  HELP="$(bash "$(dirname "$0")/help.sh" | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')"
  printf '{"decision": "block", "reason": "%s"}' "$HELP"
fi
exit 0
