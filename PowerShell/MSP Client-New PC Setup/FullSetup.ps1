#WIP as of 8/28/25
#The goal of this script is to combine the various cleanup/setup and settings changing scripts into one that should knock out a large # of the steps in our setup checklist.
<#Script Functions include, Automatically aquiring system information and creating an a copy paste for itglue + PCinfo txt file in C: Drive, 
Applying our standard windows settings(Comp Name, Comp Description, Disabling Bitlocker, Setting UAC, Disabling Show more Options, Applying Power Settings, Scheduling Windows Auto Maintenence and creating the User Profile)
Performing Our Cleanup/Tuneup Process including winget and windows updates, diskcleanup(w/wise cleaners), SFC/Dism Scanes.
#>



#Self Elevate
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}


    #\\\IT Glue Info TXT\\\
#Defining Variables
$script:comptype = $null
$script:compmake = $null
$script:compmodel = $null
$script:serialnumber = $null
$script:datetime = $null

#Check Computer Type
function compinfo{
    $script:comptype = (get-computerinfo).CsPCSystemType         # more simplified comp info
    #$comptype = get-ciminstance -ClassName Win32_SystemEnclosure | Select-Object ChassisTypes          More complex computer type info (laptop,desktop,notebook,sff,etc)
    $script:compmake = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer
    $script:compmodel = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Model
    $script:serialnumber = Get-CimInstance -classname Win32_BIOS | Select-Object SerialNumber
    $script:datetime = Get-Date
    if($comptype -eq "mobile"){
        $comptype = "Laptop"
      }
    if($comptype -eq "desktop"){
        $comptype = "Desktop"
      }
}



#Required Inputs
Write-Host "Welcome to the MSP Client: New PC Setup Checklist Script"
Write-Host "All information needed to put into IT Glue will be put into ITGlueinfo.txt in the C Drive"
  $technician = Read-Host -Prompt "Technician Name:"
  $enduser = Read-Host -Prompt "End Users Name"
  $password = Read-Host -Prompt "End Users Password"
  $compname = Read-Host -Prompt "Desired Computer Name (ORG-##TT ie: PAL-72LT)"

#Call Function
  compinfo

#Writing to file
"Title: MSP Client: New PC Setup - <$compname> - <$enduser>" >> C:\ITGlueInfo.txt
"Technician: $technician" >> C:\ITGlueInfo.txt
"End User: $enduser" >> C:\ITGlueInfo.txt
"Date Setup Started $datetime" >> C:\ITGlueInfo.txt
"Computer Type: $comptype" >> C:\ITGlueinfo.txt
"Computer Info: Make: $compmake, Model: $compmodel, Serial Number: $serialnumber" >> C:\ITGlueInfo.txt
"Computer Name: $compname" >> C:\ITGlueInfo.txt
"Username: $enduser" >> C:\ITGlueInfo.txt
"Password: $password" >> C:\ITGlueInfo.txt



    #\\\Applying Settings\\\
#Create User Profile
New-LocalUser -Name "$enduser" -Password "$password" -Description "$enduser's Profile"
Add-LocalGroupMember -Group "Administrators" -Member "$enduser"             #Adding as admin

#Reg Load
$tempsid = Get-WmiObject Win32_UserAccount -Filter "Name = '$enduser'"
$sid = $tempsid.sid
$regloadpath = "C:\Users\$enduser\NTUSER.DAT"

if ($null -eq $sid) {
        Write-Host "Failed to Pull User SID"
}
else {
        reg load "HKU\$sid" "$regloadpath"
}

#Setting Computer Name
Rename-Computer -NewName "$compname"

#Setting Computer Description to "FirstName Lastname's Desk/laptop"
$tempdesc = Get-CimInstance -ClassName Win32_OperatingSystem
        $tempdesc.Description = "$($enduser)'s $comptype "
        Set-CimInstance -InputObject $tempdesc
Write-Host "Computer Name Change will be applied on next restart"

#Disabling Bitlocker Encryption
Disable-BitLocker -MountPoint "C:"

#UAC
$UACPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $UACPath -Name "EnableLUA" -Value "1"
Set-ItemProperty -Path $UACPath -Name "PromptOnSecureDesktop" -Value "0"
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorAdmin" -Value "0"

#Show More Options
$newoptionspath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
New-Item -Path $newoptionspath -Force
Set-ItemProperty -Path $newoptionspath -Name "(Default)" -Value ""
Stop-Process -Name explorer -Force 

#Power Settings
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg.exe -x -monitor-timeout-ac 30
powercfg.exe -x -monitor-timeout-dc 0
powercfg.exe -x -disk-timeout-ac 120
powercfg.exe -x -disk-timeout-dc 120
powercfg.exe -x -standby-timeout-ac 0
powercfg.exe -x -standby-timeout-dc 0
powercfg.exe -x -hibernate-timeout-ac 0
powercfg.exe -x -hibernate-timeout-dc 0

#Schedule Maintenance
$maintenancepath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance"
Set-ItemProperty -Path $maintenancepath -Name "Activation Boundary" -Value "2001-01-01T02:00:00"




    #\\\Cleanup-Tuneup\\\
#Winget Upgrade
function wingetupgrade{
winget upgrade --all --force
Install-Module PSWindowsUpdate -Force
Get-WindowsUpdate
Install-WindowsUpdat
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



   
$functionselection = Read-Host -Prompt "Would you Like to perform the Cleanup/Tuneup script? [Winget and Windows Updates, Disk Cleanup, SFC/DISM, PCInfo Text File Creation](Y/N)"
   if ($functionselection -eq "Y") {
      wingetupgrade
      diskcleanup
      sfcdism
      PCInfotxt
   }
   Write-Host "" #Used to break up the repeats
#Reg Unload
reg unload "HKU\$sid" "$regloadpath"


Read-Host -Prompt "Thank you for using Ben's TechWizard MSP Client PC Setup Script (Press Enter to Exit)"