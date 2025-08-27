#The goal of this script is to take the information given and set the computers settings accordingly. Create New user, set comp name/description, adjust windows settings, turn off bitlocker. Will Work in conjunction with ITGluetxt.ps1


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}


#Finding what kind of computer (ripped from ITGlue.txt)
$comptype = (get-computerinfo).CsPCSystemType 
if($comptype -eq "mobile"){
        "Computer Type: Laptop">> C:\ITGlueInfo.txt
        $comptype = "Laptop"
      }
if($comptype -eq "desktop"){
        "Computer Type: Desktop">> C:\ITGlueInfo.txt
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
Disable-BitLocker -MountPoint "C:"

