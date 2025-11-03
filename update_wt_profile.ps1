param (
    [string]$gitBashPath,
    [string]$makeDefaultStr
)

$ErrorActionPreference = "Stop"

Write-Host "Starting profile update script."
Write-Host "gitBashPath: $gitBashPath"
Write-Host "makeDefaultStr: $makeDefaultStr"

try {
    $makeDefault = if ($makeDefaultStr -eq "1") { $true } else { $false }

    $wtSettingsPath = (Get-ChildItem "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal*_\LocalState\settings.json" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
    if (-not $wtSettingsPath) {
        $wtSettingsPath = (Get-ChildItem "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json" -ErrorAction SilentlyContinue | Select-Object -First 1).FullName
    }

    Write-Host "Windows Terminal settings path: $wtSettingsPath"

    if (-not (Test-Path $wtSettingsPath)) {
        Write-Error "Windows Terminal settings.json not found."
        exit 1
    }

    $json = Get-Content -Raw -Encoding UTF8 $wtSettingsPath | ConvertFrom-Json
    $gitBashProfile = $json.profiles.list | Where-Object { $_.name -eq "Git Bash" }

    $profileChanged = $false

    if ($gitBashProfile) {
        Write-Host "Updating existing Git Bash profile."
        if ($gitBashProfile.commandline -ne $gitBashPath) { $gitBashProfile.commandline = $gitBashPath; $profileChanged = $true }
        $iconPath = $gitBashPath -replace "\\bash.exe", "\\..\\..\\git-bash.exe"
        if ($gitBashProfile.icon -ne $iconPath) { $gitBashProfile.icon = $iconPath; $profileChanged = $true }
    } else {
        Write-Host "Adding new Git Bash profile."
        $newGuid = "[guid]::NewGuid().ToString()"
        $newProfile = @{
            guid = "{$newGuid}"
            name = "Git Bash"
            commandline = $gitBashPath
            hidden = $false
            icon = ($gitBashPath -replace "\\bash.exe", "\\..\\..\\git-bash.exe")
            startingDirectory = "%USERPROFILE%"
        }
        $json.profiles.list += $newProfile
        $gitBashProfile = $json.profiles.list | Where-Object { $_.guid -eq "{$newGuid}" }
        $profileChanged = $true
    }

    if ($makeDefault -and $json.defaultProfile -ne $gitBashProfile.guid) {
        Write-Host "Setting Git Bash as the default profile."
        $json.defaultProfile = $gitBashProfile.guid
        $profileChanged = $true
    }

    if ($profileChanged) {
        $json | ConvertTo-Json -Depth 10 | Set-Content -Path $wtSettingsPath -Encoding UTF8
        Write-Host "Success: Ensured 'Git Bash' profile exists in Windows Terminal settings."
    } else {
        Write-Host "No changes needed. Profile is already up to date."
    }
} catch {
    Write-Error "An error occurred: $_ "
    exit 1
}