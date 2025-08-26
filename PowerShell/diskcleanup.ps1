#I'd like to have this one run the windows disk cleanup program with all boxes selected automatically then close after a prompt letting the user know its finished
#The hope is to reduce the steps in our final cleanup/tuneup checklist into a single powershell script


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

$cleanmgrcheck = $null

cleanmgr /verylowdisk
#next goal is to have it close automatically so we can run without user interference

while ($null -eq $cleanmgrcheck) {
   $cleanmgrcheck = Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Select-Object MainWindowTitle
   }
         Write-Host "this is a test"
Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Stop-Process -Force


#Optimize/defrag drive
Optimize-Volume -DriveLetter C -ReTrim -Defrag
         Write-Host "finished defrag"


#Empty Recycle Bin
Clear-RecycleBin -Force
         Write-Host "finished recycle"



#Wise Disk Cleaner // Will want to check for pop up to close it then move on to registry cleaner.
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Disk Cleaner\WiseDiskCleaner.exe" -argumentlist "-a" -wait

#Wise Registry Cleaner
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Registry Cleaner\WiseregCleaner.exe" -argumentlist "-a -safe" -wait



Read-Host -prompt "Disk Cleanup Complete: Press Enter to exit"
