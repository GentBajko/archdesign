# Creates docs/design/capstone.json with all default settings if absent.
# The config path is fixed regardless of docs_dir (see core.md).
# Idempotent: never overwrites an existing config. Writes UTF-8 without BOM.
# Usage: powershell -ExecutionPolicy Bypass -File init-config.ps1
$Dir = Join-Path "docs" "design"
$File = Join-Path $Dir "capstone.json"
New-Item -ItemType Directory -Force -Path $Dir | Out-Null
if (Test-Path $File) {
  Write-Output "exists: $File"
} else {
  $Json = @'
{
  "expertise": null,
  "docs_dir": "docs/design",
  "index_file": "DESIGN.md",
  "subagent_threshold": 150,
  "docs_in_git": "ask",
  "language": "en",
  "pipeline": null
}
'@
  $Full = Join-Path (Get-Location).Path $File
  [System.IO.File]::WriteAllText($Full, ($Json -replace "`r`n", "`n") + "`n")
  Write-Output "created: $File"
}
