# agent-arena CLI installer for Windows.
#   irm https://raw.githubusercontent.com/amarcu/agent-arena/main/install.ps1 | iex
$ErrorActionPreference = "Stop"
$repo = "amarcu/agent-arena"
$binDir = Join-Path $env:LOCALAPPDATA "agent-arena"
$asset = "aa-windows-x64.exe"
$url = "https://github.com/$repo/releases/latest/download/$asset"

New-Item -ItemType Directory -Force -Path $binDir | Out-Null
$dest = Join-Path $binDir "aa.exe"
Write-Host "Downloading $asset ..."
Invoke-WebRequest -Uri $url -OutFile $dest

# add to the user PATH if missing
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$binDir*") {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$binDir", "User")
  Write-Host "Added $binDir to your PATH (restart the terminal to pick it up)."
}
Write-Host "Installed aa to $dest. Run 'aa doctor' to check your setup."
