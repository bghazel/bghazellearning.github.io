#I'd like to have this one run the windows disk cleanup program with all boxes selected automatically then close after a prompt letting the user know its finished
#The hope is to reduce the steps in our final cleanup/tuneup checklist into a single powershell script

$cleanmgrcheck = $null
#Write-Host "checking $cleanmgrcheck"


cleanmgr /verylowdisk -Wait
#next goal is to have it close automatically so we can run without user interference

while ($null -eq $cleanmgrcheck) {
   $cleanmgrcheck = Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Select-Object MainWindowTitle
   #Write-Host $cleanmgrcheck
}
#Write-Host "pre kill"
   Get-Process | Where-Object {$_.MainWindowTitle -eq "Disk Space Notification"} | Stop-Process -Force
Read-Host -prompt "Disk Cleanup Complete: Press Enter to exit"
