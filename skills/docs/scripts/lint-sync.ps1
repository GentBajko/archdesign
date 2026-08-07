# PowerShell twin of lint-sync.sh — asserts the same cross-file invariants.
# Run from anywhere; resolves the repo root from its own location.
$Root = Resolve-Path (Join-Path $PSScriptRoot "../../..")
Set-Location $Root
$Fail = 0
function Err($msg) { Write-Output "FAIL: $msg"; $script:Fail = 1 }

# 1. help.sh body == help.ps1 body
$sh = (Get-Content skills/docs/scripts/help.sh) | Where-Object { $_ -notmatch "^#!/|^# |^cat <<'EOF'$|^EOF$" }
$ps = (Get-Content skills/docs/scripts/help.ps1) | Where-Object { $_ -notmatch "^Write-Output @'$|^'@$|^# Prints" }
if (($sh -join "`n") -ne ($ps -join "`n")) { Err "help.sh and help.ps1 texts differ" }

# 2. one version across manifests
$versions = @('.claude-plugin/plugin.json', '.claude-plugin/marketplace.json',
  '.codex-plugin/plugin.json', '.cursor-plugin/plugin.json', '.kimi-plugin/plugin.json',
  'gemini-extension.json') | ForEach-Object {
    (Select-String -Path $_ -Pattern '"version": *"([^"]+)"').Matches |
      ForEach-Object { $_.Groups[1].Value }
  } | Sort-Object -Unique
if ($versions.Count -ne 1) { Err "version mismatch across manifests: $($versions -join ', ')" }

# 3/4. protocol <-> skill pairing and H1 stems
Get-ChildItem skills/docs/references/protocols/*.md | ForEach-Object {
  $n = $_.BaseName
  if (-not (Test-Path "skills/$n")) { Err "protocol $n.md has no skills/$n/ wrapper" }
  $h1 = Get-Content $_.FullName -First 1
  if ($h1 -notmatch "^# $n\b") { Err "H1 of $n.md does not start '# $n' ($h1)" }
}
Get-ChildItem skills -Directory | ForEach-Object {
  $n = $_.Name
  if ($n -in @('docs', 'help')) { return }
  if (-not (Test-Path "skills/docs/references/protocols/$n.md")) { Err "skill $n has no protocol file" }
}

# 5. every skill name in help text, README table + routing, INSTALL list
$help = Get-Content skills/docs/scripts/help.ps1 -Raw
$readme = Get-Content README.md -Raw
$install = Get-Content .opencode/INSTALL.md -Raw
$route = if ($readme -match '(?s)matches a capstone skill.*?invoke capstone:') { $Matches[0] } else { '' }
if (-not $route) { Err "README routing snippet not found" }
Get-ChildItem skills -Directory | ForEach-Object {
  $n = $_.Name
  if ($help -notmatch "(?m)^  $n\b") { Err "help missing command line for $n" }
  if ($readme -notmatch [regex]::Escape("/capstone:$n")) { Err "README missing /capstone:$n" }
  if ($install -notmatch "$n[,)]") { Err "INSTALL.md missing $n" }
  if ($route -and $route -notmatch "\b$n\b") { Err "README routing snippet missing $n" }
}

# 6. hook wiring
$hooks = Get-Content hooks/hooks.json -Raw
if ($hooks -notmatch '"matcher": "capstone:help"') { Err "hooks.json matcher wrong" }
if ($hooks -notmatch 'skills/docs/scripts/help-hook\.sh') { Err "hooks.json does not point at help-hook.sh" }
if ((Get-Content skills/docs/scripts/help-hook.sh -Raw) -notmatch '"command_name":"capstone:help"') { Err "help-hook guard wrong" }

# 7. config template keys everywhere
$files = @('skills/docs/scripts/init-config.sh', 'skills/docs/scripts/init-config.ps1',
  'skills/docs/references/core.md', 'README.md')
$keys = @('expertise', 'docs_dir', 'index_file', 'subagent_threshold', 'docs_in_git', 'language', 'pipeline')
foreach ($f in $files) {
  $c = Get-Content $f -Raw
  foreach ($k in $keys) { if ($c -notmatch "`"$k`"") { Err "$f config template missing key $k" } }
}

# 8. .sh/.ps1 pairing (help-hook.sh exempt: hooks.json invokes bash explicitly)
Get-ChildItem skills/docs/scripts/*.sh | ForEach-Object {
  $b = $_.BaseName
  if ($b -eq 'help-hook') { return }
  if (-not (Test-Path "skills/docs/scripts/$b.ps1")) { Err "$b.sh has no $b.ps1 twin" }
}

# 9. no dead names
$stale = git grep -l 'archdesign' -- . 2>$null
if ($stale) { Err "stale 'archdesign' references: $stale" }

if ($Fail -eq 0) { Write-Output "lint-sync: all invariants hold" } else { Write-Output "lint-sync: FAILURES above" }
exit $Fail
