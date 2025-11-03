$ErrorActionPreference = "SilentlyContinue"

$wtSettingsPath = (Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*_\LocalState\settings.json" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
if (-not $wtSettingsPath) {
    $wtSettingsPath = (Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
}

if (-not (Test-Path $wtSettingsPath)) {
    Write-Host "FAIL: Windows Terminal settings.json not found."
    exit 1
}

$content = Get-Content -Raw -Encoding UTF8 $wtSettingsPath | ConvertFrom-Json
$gitBashProfile = $content.profiles.list | Where-Object { $_.name -eq 'Git Bash' }

if ($gitBashProfile -and $gitBashProfile.commandline) {
    Write-Host "PASS: Git Bash profile found."
    Write-Host "Commandline: $($gitBashProfile.commandline)"
    exit 0
} else {
    Write-Host "FAIL: Git Bash profile not found."
    exit 1
}
