1. Start Windows Terminal

![Start with Terminal](./media/Install_and_configure_VSCode_0.png)
<img src="./media/Install_and_configure_VSCode_0.png" alt="Start with Terminal" width="400">


2. Install VS Code and some more packages

```powershell
$packages = @(
    "Git.Git",
    "Microsoft.PowerShell",
    "Microsoft.Bicep",
    "Microsoft.VisualStudioCode"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg ..." -ForegroundColor Cyan
    winget install --id $pkg --exact --silent --accept-package-agreements --accept-source-agreements
}
```

- Ignore GitHub Copilot

![Ignore GitHub Copilot](./media/Install_and_configure_VSCode_1.png)

![alt](https://)