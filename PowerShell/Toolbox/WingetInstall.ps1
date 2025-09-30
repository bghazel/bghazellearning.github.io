# Goal: One button to install latest winget version and update all winget apps
Start-Transcript -Path "C:\Toolbox\Logs\Wingetinstall.log" -Append
# Self Elevate
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
    exit
}

function wingetinstall {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Output "Winget not found. Installing latest version..."

        $release = Invoke-RestMethod -Uri "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $asset = $release.assets | Where-Object { $_.name -like "*.msixbundle" } | Select-Object -First 1
        $downloadUrl = $asset.browser_download_url

        Invoke-WebRequest -Uri $downloadUrl -OutFile "Setup.msix"

        try {
            Add-AppxPackage -Path "Setup.msix"
            Write-Output "Winget installed successfully."
        } catch {
            Write-Error "Winget installation failed: $_"
        } finally {
            Remove-Item "Setup.msix" -ErrorAction SilentlyContinue
        }
    } else {
        Write-Output "Winget is already installed."
    }
}

function wingetupgrade {
    Write-Output "Upgrading all available Winget apps..."
    winget upgrade --all --force
}

# Run the functions
wingetinstall
wingetupgrade