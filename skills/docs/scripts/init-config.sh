#!/usr/bin/env bash
# Creates docs/design/capstone.json with all default settings if absent.
# The config path is fixed regardless of docs_dir (see core.md).
# Idempotent: never overwrites an existing config.
# Usage: init-config.sh
set -eu
FILE="docs/design/capstone.json"
mkdir -p "docs/design"
if [ -f "$FILE" ]; then
  echo "exists: $FILE"
else
  cat > "$FILE" <<'EOF'
{
  "expertise": null,
  "docs_dir": "docs/design",
  "index_file": "DESIGN.md",
  "subagent_threshold": 150,
  "docs_in_git": "ask",
  "language": "en",
  "pipeline": null
}
EOF
  echo "created: $FILE"
fi
