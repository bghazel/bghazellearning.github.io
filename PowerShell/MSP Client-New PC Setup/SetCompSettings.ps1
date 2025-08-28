#The goal of this script is to take the information given and set the computers settings accordingly. Create New user, set comp name/description, adjust windows settings, turn off bitlocker. Will Work in conjunction with ITGluetxt.ps1

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#Regedit user selection | Put this at very top right after self elevate.
#Reg path will be hkey_users\$sid\...
$tempsid = Get-WmiObject Win32_UserAccount -Filter "Name = '$enduser'"
$sid = $tempsid.sid
$regloadpath = "C:\Users\$enduser\NTUSER.DAT"

if ($null -eq $sid) {
        Write-Host "Failed to Pull User SID"
}
else {
        reg load "HKU\$sid" "$regloadpath"
}



#Auto Set Time Zone Based on Location
$locpermpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
$autosettime = "HKLM:\SYSTEM\CurrentControlSet\Services\tzautoupdate"
Set-ItemProperty -Path $locpermpath -Name "Value" -Value "Allow"
Set-ItemProperty -Path $autosettime -Name "Start" -Value "3"

#Finding what kind of computer (ripped from ITGluetxt.ps1)
$comptype = (get-computerinfo).CsPCSystemType 
if($comptype -eq "mobile"){
        $comptype = "Laptop"
      }
if($comptype -eq "desktop"){
        $comptype = "Desktop"
      }

#Getting Computer Name
$compname = Read-Host -Prompt "Desired Computer Name (ORG-##TT ie: PAL-72LT)"
        Rename-Computer -NewName "$compname"

#Changing Computer Description to "FirstName Lastname's Desk/laptop"
$tempdesc = Get-CimInstance -ClassName Win32_OperatingSystem
        $tempdesc.Description = "$($enduser)'s $comptype "
        Set-CimInstance -InputObject $tempdesc
Write-Host "Computer Name Change will be applied on next restart"

#Disabling Bitlocker Encryption
if ((Get-BitLockerVolume -MountPoint "C:").VolumeStatus -eq "FullyEncrypted") {
    Disable-BitLocker -MountPoint "C:"
}

#UAC
$UACPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $UACPath -Name "EnableLUA" -Value "1"
Set-ItemProperty -Path $UACPath -Name "PromptOnSecureDesktop" -Value "0"
Set-ItemProperty -Path $UACPath -Name "ConsentPromptBehaviorAdmin" -Value "0"

#Show More Options
$optionsenduser = "HKU:\$($sid)\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" #set for End User
$newoptionspath = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" ##set for current user

New-Item -Path $newoptionspath -Force
Set-ItemProperty -Path $newoptionspath -Name "(Default)" -Value ""

New-Item -Path $optionsenduser -Force
Set-ItemProperty -Path $optionsenduser -Name "(Default)" -Value ""

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

#Unload
reg load "HKU\$sid" "$regloadpath"


#####################################################################################################[WIP] NOT ADDED TO FULL SETUP SCRIPT###########################################################################################################################

#need to add end user registry change to the full script.


#Taskbar Settings