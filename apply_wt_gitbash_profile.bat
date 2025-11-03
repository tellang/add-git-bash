@echo off
:: This is a comment to create a new commit.
setlocal

:: Default value for MAKE_DEFAULT
set "MAKE_DEFAULT=0"
if defined MAKE_DEFAULT (set "MAKE_DEFAULT=%MAKE_DEFAULT%")

:: Find Git Bash executable
set "GIT_BASH_PATH="
if exist "%ProgramFiles%\Git\bin\bash.exe" (
    set "GIT_BASH_PATH=%ProgramFiles%\Git\bin\bash.exe"
) else if exist "%ProgramFiles(x86)%\Git\bin\bash.exe" (
    set "GIT_BASH_PATH=%ProgramFiles(x86)%\Git\bin\bash.exe"
) else if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
    set "GIT_BASH_PATH=%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
)

if not defined GIT_BASH_PATH (
    echo [ERROR] Git Bash (bash.exe) not found. Please make sure Git is installed.
    exit /b 1
)

:: Get the directory of the currently running script
set "SCRIPT_DIR=%~dp0"

:: Execute the PowerShell script
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%update_wt_profile.ps1" -gitBashPath "%GIT_BASH_PATH%" -makeDefaultStr "%MAKE_DEFAULT%"

exit /b %ERRORLEVEL%