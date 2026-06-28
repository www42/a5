### 1. Prerequisites: Windows Terminal and winget

<img src="./media/Install_and_configure_VSCode_0.png" alt="Start with Terminal" width="500">

<br>


## Install VS Code and even more packages

### Install Packages

```powershell
$packages = @(
    "Git.Git",
    "Microsoft.Bicep",
    "Microsoft.AzureCLI",
    "Microsoft.PowerShell",
    "Microsoft.VisualStudioCode"
)

foreach ($pkg in $packages) {
    Write-Host "Installing $pkg ..." -ForegroundColor Cyan
    winget install --id $pkg --exact --silent --accept-package-agreements --accept-source-agreements
}
```

```powershell
# Reload PATH variable
Write-Host "Refreshing PATH ..." -ForegroundColor Cyan
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("PATH", "User")

```

### Install VS Code extensions

```powershell
$extensions = @(
    "ms-vscode.powershell",
    "ms-vscode.azurecli",
    "ms-azuretools.vscode-bicep",
    "redhat.vscode-yaml",
    "eriklynd.json-tools",
    "tomoki1207.pdf"
)

foreach ($ext in $extensions) {
    Write-Host "Installing Extension $ext ..." -ForegroundColor Cyan
    code --install-extension $ext --force
}
```

<br>


## 3. Configure VS Code

- Start VS Code, ignore GitHub Copilot

<img src="./media/Install_and_configure_VSCode_1.png" alt="Ignore GitHub Copilot" width="500">





```powershell
```
