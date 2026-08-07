#!/usr/bin/env bash
# Asserts every keep-in-sync-by-hand invariant in this plugin.
# Run from the repo root. Exit non-zero listing each failure.
# help-hook.sh is exempt from the .sh/.ps1 pair rule: hooks.json invokes
# bash explicitly, so it is bash-only by design.
set -u
cd "$(dirname "$0")/../../.." || exit 1
FAIL=0
err() { echo "FAIL: $*"; FAIL=1; }

# 1. help.sh body == help.ps1 body
if ! diff <(bash skills/docs/scripts/help.sh) \
          <(grep -v "^Write-Output @'\|^'@\|^# Prints" skills/docs/scripts/help.ps1) >/dev/null 2>&1; then
  err "help.sh and help.ps1 texts differ"
fi

# 2. exactly one version string across all manifests
VERSIONS=$(grep -h '"version"' .claude-plugin/plugin.json .claude-plugin/marketplace.json \
  .codex-plugin/plugin.json .cursor-plugin/plugin.json .kimi-plugin/plugin.json \
  gemini-extension.json | sed 's/.*: *"\([^"]*\)".*/\1/' | sort -u)
[ "$(echo "$VERSIONS" | wc -l)" -eq 1 ] || err "version mismatch across manifests: $(echo $VERSIONS)"

# 3. protocol files <-> skill dirs (docs and help have no protocol; start..code-prefs all do)
for p in skills/docs/references/protocols/*.md; do
  n=$(basename "$p" .md)
  [ -d "skills/$n" ] || err "protocol $n.md has no skills/$n/ wrapper"
done
for d in skills/*/; do
  n=$(basename "$d")
  case "$n" in docs|help) continue;; esac
  [ -f "skills/docs/references/protocols/$n.md" ] || err "skill $n has no protocol file"
done

# 4. protocol H1 stem == filename
for p in skills/docs/references/protocols/*.md; do
  n=$(basename "$p" .md)
  head -1 "$p" | grep -q "^# $n\b" || err "H1 of $n.md does not start '# $n' ($(head -1 "$p"))"
done

# 5. every skill name appears in help.sh, README command table, README routing snippet, INSTALL.md
HELPTXT=$(bash skills/docs/scripts/help.sh)
for d in skills/*/; do
  n=$(basename "$d")
  echo "$HELPTXT" | grep -q "^  $n\b" || err "help.sh missing command line for $n"
  grep -q "/capstone:$n[\` ]" README.md || err "README command table missing /capstone:$n"
  grep -q "$n[,)]" .opencode/INSTALL.md || err "INSTALL.md missing $n"
done
ROUTE=$(sed -n '/matches a capstone skill/,/invoke capstone:/p' README.md)
for d in skills/*/; do
  n=$(basename "$d")
  echo "$ROUTE" | grep -q "\b$n\b" || err "README routing snippet missing $n"
done

# 6. hook wiring: matcher == script guard == existing skill
grep -q '"matcher": "capstone:help"' hooks/hooks.json || err "hooks.json matcher is not capstone:help"
grep -q '"command_name":"capstone:help"' skills/docs/scripts/help-hook.sh || err "help-hook.sh guard string wrong"
grep -q 'skills/docs/scripts/help-hook.sh' hooks/hooks.json || err "hooks.json does not point at help-hook.sh"

# 7. config template keys identical everywhere they appear
KEYS=$(sed -n '/^{/,/^}/p' <<'EOF'
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
)
for f in skills/docs/scripts/init-config.sh skills/docs/scripts/init-config.ps1 \
         skills/docs/references/core.md README.md; do
  for k in expertise docs_dir index_file subagent_threshold docs_in_git language pipeline; do
    grep -q "\"$k\"" "$f" || err "$f config template missing key $k"
  done
done

# 8. .sh/.ps1 pairing (help-hook.sh exempt, lint-sync pairs with itself)
for s in skills/docs/scripts/*.sh; do
  b=$(basename "$s" .sh)
  case "$b" in help-hook) continue;; esac
  [ -f "skills/docs/scripts/$b.ps1" ] || err "$b.sh has no $b.ps1 twin"
done

# 9. no dead names anywhere tracked (lint scripts excluded: they carry
# the search literal themselves)
if git grep -l 'archdesign' -- . ':!skills/docs/scripts/lint-sync.*' >/dev/null 2>&1; then
  err "stale 'archdesign' references: $(git grep -l 'archdesign' -- . ':!skills/docs/scripts/lint-sync.*' | tr '\n' ' ')"
fi

# 10. bash syntax of every .sh
for s in skills/docs/scripts/*.sh; do
  bash -n "$s" 2>/dev/null || err "bash syntax error in $s"
done

[ "$FAIL" -eq 0 ] && echo "lint-sync: all invariants hold" || echo "lint-sync: FAILURES above"
exit $FAIL
