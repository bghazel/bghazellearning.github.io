#The goal of this script is to combine the various cleanup/setup and settings changing scripts into one that should knock out a large # of the steps in our setup checklist.

#Self Elevate
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}
    #IT Glue Info TXT
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

#Create User Profile
New-LocalUser -Name "$enduser" -Password "$password" -Description "$enduser's Profile"
Add-LocalGroupMember -Group "Administrators" -Member "$enduser"             #Adding as admin



