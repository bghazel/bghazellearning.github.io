#This script is to combine the various cleanup/tuneup scripts created into one for a one button press cleanup process. Using functions for the first time to try and organize well.

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#Winget Upgrade
function wingetupgrade{
winget upgrade --all --force
}

#Disk Cleanup
function diskcleanup{
         Write-Host "Starting Disk Cleanup Function"

$cleanmgrcheck = $null

$downloadcheck = Read-Host -Prompt "Do you want to clear your downloads folder? Y\N"

cleanmgr /verylowdisk
while ($null -eq $cleanmgrcheck) {
   #Closes the popup automatically
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
if($downloadcheck -eq "Y"){
   Remove-Item -Path "$env:USERPROFILE\Downloads\*" -Force -Recurse
         Write-Host "Cleared the Downloads Folder From this profile"
}
else{
         Write-Host "Skipping over download folder deletion"
}


#Wise Disk Cleaner // Will want to check for pop up to close it then move on to registry cleaner.
         Write-Host "Starting Wise Disk Cleaner. Please Wait..."
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Disk Cleaner\WiseDiskCleaner.exe" -argumentlist "-a" -wait
         Write-Host "Finished Wise Disk Cleaner"

#Wise Registry Cleaner
         Write-Host "Starting Wise Registry Cleaner. Please Wait..."
Start-Process -FilePath "C:\Program Files (x86)\Wise\Wise Registry Cleaner\WiseregCleaner.exe" -argumentlist "-a -safe" -wait
         Write-Host "Finished Wise Registry Cleaner"


Write-Host "Disk Cleanup Complete"

}

#DISM // SFC Scans
function sfcdism {

         Write-Host "Starting SFC/DISM Function"

#Start-Process -FilePath "dism.exe" -ArgumentList "/online /cleanup-image /restorehealth" -Wait -Verb RunAs

Start-Process -FilePath "${env:Windir}\System32\SFC.EXE" -ArgumentList "/scannow"  -Wait -Verb RunAs

Write-Host "DISM\SFC Corruption Scans have finished running."
}

#Create PCInfo File
function PCInfotxt{
      
         Write-Host "Creating PCInfo File in C:\ Drive"

    #most pertinent info to access

"Quick Access Information" >> C:\pcinfo.txt
Get-ComputerInfo -Property CSName,CSModel,OsName,WindowsInstallDateFromRegistry | Format-List >> C:\pcinfo.txt
Get-WmiObject win32_bios | Select-Object SerialNumber >> C:\pcinfo.txt
"IP:Address " >> C:\pcinfo.txt ;"----------" >> C:\pcinfo.txt
(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*") >> C:\pcinfo.txt
"">>C:\pcinfo.txt ; "Date Configured" >> C:\pcinfo.txt ; "----------" >> C:\pcinfo.txt ; get-date >> C:\pcinfo.txt
"Hard Drive Information" >> C:\pcinfo.txt ; get-volume >> C:\pcinfo.txt
"Installed Applications" >> C:\pcinfo.txt ; Get-Package >> C:\pcinfo.txt

   #Just straight sysinfo command. Harder to parse but more information
"Further Information" >> C:\pcinfo.txt
systeminfo >> C:\pcinfo.txt
}  





#Function Selection
while ($functionselection -ne 6) {
   
Write-Host "Welcome to Ben's TechWizard Cleanup/Tuneup Script"
Write-Host "There are several functions please enter which function(s) you would like to use (This prompt will repeat upon completion of a function)"
Write-Host "(1) Winget Upgrade"
Write-Host "(2) Disk Cleanup"
Write-Host "(3) DISM/SFC Scans"
Write-Host "(4) PCInfo File Creation"
Write-Host "(5) All of the above"
Write-Host "(6) Exit"
$functionselection = Read-Host -Prompt "Enter a number (1-6)"

   #Winget Upgrade
   if ($functionselection -eq 1) {
      wingetupgrade
   }

   #Windows Disk Cleanup
   if ($functionselection -eq 2) {
      diskcleanup
   }

   #DISM // SFC Scans
   if ($functionselection -eq 3) {
      sfcdism
   }

   #Create PCInfo File
   if ($functionselection -eq 4) {
      PCInfotxt
   }

   #All
   if ($functionselection -eq 5) {
      wingetupgrade
      diskcleanup
      sfcdism
      PCInfotxt
   }
   Write-Host "" #Used to break up the repeats
}

Read-Host -Prompt "Thank you for using Ben's TechWizard Cleanup/Tuneup Script (Press Enter to Exit)"
