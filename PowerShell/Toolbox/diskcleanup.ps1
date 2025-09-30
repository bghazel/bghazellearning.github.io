#I'd like to have this one run the windows disk cleanup program with all boxes selected automatically then close after a prompt letting the user know its finished
#The hope is to reduce the steps in our final cleanup/tuneup checklist into a single powershell script
Start-Transcript -Path "C:\Toolbox\Logs\DiskCleanup.log" -Append

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
         
Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Stop-Process -Force
         Write-Host "finished windows disk cleanup"

#Optimize/defrag drive
Optimize-Volume -DriveLetter C -ReTrim -Defrag
         Write-Host "Finished Defrag/Trim"

#Empty Recycle Bin
Clear-RecycleBin -Force
         Write-Host "Finished Recycle Bin Clear"

#Clear Recent Items List
Remove-Item -Path "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Recent\*" -Force -Recurse
         Write-Host "Cleared recent Items From This profile"

#Clear Downloads Folder
$downloadcheck = Read-Host -Prompt "Do you want to clear your downloads folder? Y\N"
if($downloadcheck -eq "Y"){
   Remove-Item -Path "$env:USERPROFILE\Downloads\*" -Force -Recurse
         Write-Host "Cleared the Downloads Folder From this profile"
}
else{
         Write-Host "Skipping over download folder deletion"
}


#Wise Disk Cleaner // Will want to check for pop up to close it then move on to registry cleaner.
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Disk Cleaner\WiseDiskCleaner.exe" -argumentlist "-a" -wait
         Write-Host "Finished Wise Disk Cleaner"

#Wise Registry Cleaner
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Registry Cleaner\WiseregCleaner.exe" -argumentlist "-a -safe" -wait
         Write-Host "Finished Wise Registry Cleaner"


Read-Host -prompt "Disk Cleanup Complete: Press Enter to exit"

Stop-Transcript
