Start-Transcript -Path "C:\Toolbox\Logs\OfficeFullRepair.log" -Append

# Self-elevate if not running as Administrator
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
    exit
}

# Common OfficeClickToRun locations
$possiblePaths = @(
    "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe",
    "C:\Program Files\Microsoft Office\root\ClientX64\OfficeClickToRun.exe",
    "C:\Program Files (x86)\Microsoft Office\root\ClientX86\OfficeClickToRun.exe",
    "C:\Program Files\Microsoft Office 15\ClientX64\OfficeClickToRun.exe",
    "C:\Program Files (x86)\Microsoft Office 15\ClientX86\OfficeClickToRun.exe"
)

# Find the first valid path
$officeExe = $possiblePaths | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($officeExe) {
    Write-Host "Found OfficeClickToRun.exe at: $officeExe"
    
    # Run Quick Repair
    Start-Process $officeExe -ArgumentList "scenario=repair platform=x64 culture=en-us forceappshutdown=true RepairType=FullRepair DisplayLevel=true" -Wait
    Write-Host "Repair completed."
} else {
    Write-Warning "OfficeClickToRun.exe not found in standard locations."
}

Stop-Transcript
