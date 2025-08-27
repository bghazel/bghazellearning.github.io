#The goal for this script is to create a txt file that contains all the info requested in IT Glue to be copy and pasted easily.

#Self Elevate
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#Preliminary Info (Technician, Company, User, Date Started Computer Info)

#Check Computer Type
function compinfo{
    #$comptype = (get-computerinfo).CsPCSystemType          more simplified comp info
    $comptype = get-ciminstance -ClassName Win32_SystemEnclosure | Select-Object ChassisTypes
    $compmake = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Manufacturer
    $compmodel = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Model
    $serialnumber = Get-CimInstance -classname Win32_BIOS | Select-Object SerialNumber
    if(comptype -eq mobile){
        "Computer Type: Laptop">> C:\ITGlueInfo.txt
    }
    if(comptype -eq "desktop"){
        "Computer Type: Desktop">> C:\ITGlueInfo.txt
    }
}


Write-Host "Welcome to the MSP Client: New PC Setup Checklist Script"
$technician=Read-Host -Prompt "Technician Name:"
    "Technician: $technician" >> C:\ITGlueInfo.txt
