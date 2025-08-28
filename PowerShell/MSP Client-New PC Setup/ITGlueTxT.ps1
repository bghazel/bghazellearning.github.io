#The goal for this script is to create a txt file that contains all the info requested in IT Glue to be copy and pasted easily.

#Self Elevate
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

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
  $script:enduser = Read-Host -Prompt "End Users Name"
  $password = Read-Host -Prompt "End Users Password"
  $script:company = Read-Host -Prompt "Company code shorthand: (ie: PAL,VLT,AUTH)"    #Checking company for vsa install purposes, but added for extra info in itglue
  $compname = Read-Host -Prompt "Desired Computer Name (ORG-##TT ie: PAL-72LT)"

#Call Function
  compinfo

#Writing to file
"Title: MSP Client: New PC Setup - <$compname> - <$enduser>" >> C:\ITGlueInfo.txt
"Technician: $technician" >> C:\ITGlueInfo.txt
"Company: $script:company" >> C:\ITGlueInfo.txt
"End User: $enduser" >> C:\ITGlueInfo.txt
"Date Setup Started $datetime" >> C:\ITGlueInfo.txt
"Computer Type: $comptype" >> C:\ITGlueinfo.txt
"Computer Info: Make: $compmake, Model: $compmodel, Serial Number: $serialnumber" >> C:\ITGlueInfo.txt
"Computer Name: $compname" >> C:\ITGlueInfo.txt
"Username: $enduser" >> C:\ITGlueInfo.txt
"Password: $password" >> C:\ITGlueInfo.txt
