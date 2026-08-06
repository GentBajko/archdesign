#!/usr/bin/env bash
# Creates <docs_dir>/capstone.json with all default settings if absent.
# Idempotent: never overwrites an existing config.
# Usage: init-config.sh [docs_dir]   (default: docs/design)
set -eu
DOCS_DIR="${1:-docs/design}"
FILE="$DOCS_DIR/capstone.json"
mkdir -p "$DOCS_DIR"
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
  "language": "en"
}
EOF
  echo "created: $FILE"
fi
