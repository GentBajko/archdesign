#!/usr/bin/env bash
# UserPromptExpansion hook: answers /capstone:help without invoking the model.
# hooks.json's matcher targets command_name "capstone:help"; the stdin check
# below is a second guard so a broad matcher can never hijack other commands.
# Verified payload fields: hook_event_name, expansion_type, command_name,
# command_args, command_source, prompt.
# The reason text is sourced from help.sh (single source of truth) — keep
# that file free of double quotes and backslashes so the JSON escaping
# below stays trivial.
INPUT="$(cat)"
if printf '%s' "$INPUT" | grep -q '"command_name":"capstone:help"'; then
  HELP="$(bash "$(dirname "$0")/help.sh" | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}')"
  printf '{"decision": "block", "reason": "%s"}' "$HELP"
fi
exit 0
