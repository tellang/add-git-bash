# Windows Terminal Git Bash Profile Updater

These scripts automatically add or update the Git Bash profile in Windows Terminal.

## Prerequisites

- [Windows Terminal](https://aka.ms/terminal)
- [Git for Windows](https://git-scm.com/download/win)
- PowerShell 5+ (included in Windows 10 and later)

## Usage

1.  Run the `apply_wt_gitbash_profile.bat` script.

    ```batch
    .\apply_wt_gitbash_profile.bat
    ```

2.  The script will automatically find your Git Bash installation and add or update the profile in your Windows Terminal `settings.json`.

### Set as Default Profile

To set Git Bash as your default profile, set the `MAKE_DEFAULT` environment variable to `1` before running the script:

```batch
set MAKE_DEFAULT=1
.\apply_wt_gitbash_profile.bat
```

## Testing

To verify that the profile was created successfully, you can run the `test.ps1` script:

```powershell
.\test.ps1
```

If the script outputs "PASS", the profile was created successfully.

## Scripts

-   `apply_wt_gitbash_profile.bat`: The main script that finds Git Bash and executes the PowerShell script to update Windows Terminal settings.
-   `update_wt_profile.ps1`: The PowerShell script that modifies the Windows Terminal `settings.json` file.
-   `test.ps1`: A PowerShell script to verify that the Git Bash profile was successfully added.
