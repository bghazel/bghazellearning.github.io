#Plan here is to run DISM /Online /cleanup-image /restorehealth and then sfc /scannow in one click.
#Once that is working attempt to have the output logged in easily accesible file.
Start-Transcript -Path "C:\Toolbox\Logs\dismsfcTranscript.log" -Append

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#allow scripts
    #Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine -Force


Start-Process -FilePath "dism.exe" -ArgumentList "/online /cleanup-image /restorehealth" -Wait -Verb RunAs
Read-Host "DISM"
Start-Process -FilePath "${env:Windir}\System32\SFC.EXE" -ArgumentList "/scannow" -Wait -Verb RunAs
Read-Host "SFC"
Read-Host -Prompt "Scans have finished running. Press Enter to close this window now"

#-RedirectStandardOutput C:\

Stop-Transcript