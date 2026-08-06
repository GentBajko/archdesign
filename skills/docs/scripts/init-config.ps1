# Creates <docs_dir>/capstone.json with all default settings if absent.
# Idempotent: never overwrites an existing config.
# Usage: powershell -ExecutionPolicy Bypass -File init-config.ps1 [docs_dir]
param([string]$DocsDir = "docs/design")
$File = Join-Path $DocsDir "capstone.json"
New-Item -ItemType Directory -Force -Path $DocsDir | Out-Null
if (Test-Path $File) {
  Write-Output "exists: $File"
} else {
  @'
{
  "expertise": null,
  "docs_dir": "docs/design",
  "index_file": "DESIGN.md",
  "subagent_threshold": 150,
  "docs_in_git": "ask",
  "language": "en"
}
'@ | Set-Content -Path $File -Encoding utf8
  Write-Output "created: $File"
}
