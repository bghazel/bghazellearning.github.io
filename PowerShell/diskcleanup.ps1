#I'd like to have this one run the windows disk cleanup program with all boxes selected automatically then close after a prompt letting the user know its finished
#The hope is to reduce the steps in our final cleanup/tuneup checklist into a single powershell script

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$cleanmgrcheck = $null

cleanmgr /verylowdisk -Wait
#next goal is to have it close automatically so we can run without user interference

while ($null -eq $cleanmgrcheck) {
   $cleanmgrcheck = Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Select-Object MainWindowTitle
   }

Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Stop-Process -Force

#Optimize/defrag drive
Optimize-Volume -DriveLetter C -ReTrim -Defrag

#Empty Recycle Bin
Clear-RecycleBin -Force

Read-Host -prompt "Disk Cleanup Complete: Press Enter to exit"
