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
    if($script:comptype -eq "mobile"){
        $script:comptype = "Laptop"
      }
    if($script:comptype -eq "desktop"){
        $script:comptype = "Desktop"
      }
}



#Required Inputs
Write-Host "Welcome to the MSP Client: New PC Setup Checklist Script"
Write-Host "All information needed to put into IT Glue will be put into ITGlueinfo.txt in the C Drive"
  $technician = Read-Host -Prompt "Technician Name:"
  $script:enduser = Read-Host -Prompt "End Users Name"
  $script:password = Read-Host -Prompt "End Users Password" -AsSecureString
  $compname = Read-Host -Prompt "Desired Computer Name (ORG-##TT ie: PAL-72LT)"

#Call Function
  compinfo

#Writing to file
"Title: MSP Client: New PC Setup - <$compname> - <$script:enduser>" >> C:\ITGlueInfo.txt
"Technician: $technician" >> C:\ITGlueInfo.txt
"End User: $script:enduser" >> C:\ITGlueInfo.txt
"Date Setup Started $script:datetime" >> C:\ITGlueInfo.txt
"Computer Type: $script:comptype" >> C:\ITGlueinfo.txt
"Computer Info: Make: $compmake, Model: $compmodel, Serial Number: $serialnumber" >> C:\ITGlueInfo.txt
"Computer Name: $compname" >> C:\ITGlueInfo.txt
"Username: $script:enduser" >> C:\ITGlueInfo.txt
  $unsecurePassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($script:password)
  )
"Password: $unsecurePassword" >> C:\ITGlueInfo.txt

#Removing anything after first space in enduser.
$script:enduser = ($script:enduser -split ' ', 2)[0]



    #\\\Applying Settings\\\
function Applysettings {
#Set Default Task Bar  ||||||||||||||||||||||||||||||||Must be done before user creation|||||||||||||||||||||||
$xmlstring = @"
<?xml version="1.0" encoding="utf-8"?>
<LayoutModificationTemplate
    xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification"
    xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout"
    xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout"
    xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout"
    Version="1">
  <CustomTaskbarLayoutCollection PinListPlacement="Replace">
    <defaultlayout:TaskbarLayout>
      <taskbar:TaskbarPinList>
        <taskbar:UWA AppUserModelID="MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe!App" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="Chrome" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="MSEdge" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="308046B0AF4A39CB" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.OUTLOOK.EXE.15" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.EXCEL.EXE.15" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Office.WINWORD.EXE.15" PinGeneration="1"/>
        <taskbar:DesktopApp DesktopApplicationID="MSTeams_8wekyb3d8bbwe!MSTeams" PinGeneration="1"/>

      </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
  </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>

"@

$xmldoc = New-Object System.Xml.XmlDocument
$xmldoc.LoadXml($xmlstring)
$outputpath = "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
$xmldoc.Save($outputpath)

#Create and Initialize User Profile
New-LocalUser -Name "$script:enduser" -Password $script:password -Description "$script:enduser's Profile"
Add-LocalGroupMember -Group "Administrators" -Member "$script:enduser"             #Adding as admin

  try {
    $username = "$env:COMPUTERNAME\$($script:enduser)"
    $cred = New-Object System.Management.Automation.PSCredential($username, $script:password)

    Write-Host "Triggering profile creation for $username..."

    # random command to initialize profile
    Start-Process -FilePath "cmd.exe" -Credential $cred -ArgumentList "/c exit" -WindowStyle Hidden -Wait

    Start-Sleep -Seconds 15  # Give Windows a moment to finish writing the profile
  }
  catch {
    Write-Host "Failed to initialize the user profile: $_"
  }

#Reg Load
$tempsid = Get-WmiObject Win32_UserAccount -Filter "Name = '$script:enduser'"
$sid = $tempsid.sid
$regloadpath = "C:\Users\$script:enduser\NTUSER.DAT"

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
        $tempdesc.Description = "$($script:enduser)'s $comptype "
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

#Taskbar Settings
$registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$userregpath = "HKU:\$($sid)\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
$Al = "TaskbarAl" # Shift Start Menu Left 
$value = "0"

Set-ItemProperty -Path $registryPath -Name $Al -Value $value -PropertyType DWORD -Force -ErrorAction Ignore
Set-ItemProperty -Path $userregpath -Name $Al -Value $value -PropertyType DWORD -Force -ErrorAction Ignore

#Logon Disclaimer
$logdiscpath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
Set-ItemProperty -Path $logdiscpath -Name "legalnoticecaption" -Value "Important Message From Tech Wizards"
Set-ItemProperty -Path $logdiscpath -Name "legalnoticetext" -Value "ALL COMPUTERS SHOULD ALWAYS BE KEPT POWERED ON WHENEVER POSSIBLE.  You can log out of Windows, but never Shut Down your computer overnight or over a weekend.  Tech Wizards performs automated and manual maintenance procedures and updates to your computer during evening and weekend hours, and if your computer is powered down, asleep, or in hibernation mode then we cannot perform these functions to keep your PC running at optimal performance and maximum speed.  Your monitor will automatically go dark after 15 minutes of computer inactivity.  Move your mouse or press any key to return to the Windows Desktop.  After 30 minutes of inactivity, you will need to enter your computer password (or PIN) to return to the Windows Desktop. You can power off your monitor if you want to, but there is no need to do so.  If this is a laptop computer, it is understood that this is a mobile device. Obviously, it will not always be powered on and connected to the Internet, especially when it is in transit.  But whenever possible, please keep your laptop plugged in, awake, and connected to the Internet so we can perform important maintenance and update procedures.  Thank you for helping Tech Wizards keep your company's network and computers working efficiently."

#Stop Widget Popup
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Force
Set-ItemProperty -Path "HKU:\$($sid)\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value 0 -Force

}
  
  
  #\\\Cleanup-Tuneup\\\
#Install winget                   \\\\\\\\\\\\\\\\\\\\ADD IF TO CHECK IF INSTALLED\\\\\\\\\\\\\\\\\\\\
function wingetinstall{
    # Get the download URL of the latest winget installer from GitHub:
$API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url |
    Where-Object {$_.EndsWith(".msixbundle")}

    # Download the installer:
Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle 

    # Install winget:
Add-AppxPackage winget.msixbundle

    # Remove the installer:
Remove-Item winget.msixbundle
}

#Winget Upgrade
function wingetupgrade{
winget upgrade --all --force
Install-Module PSWindowsUpdate -Force
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll
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

#VSA Agent + Wallpaper Install Script
function VSAbkg{
    $script:company = Read-Host -Prompt "Company code shorthand:  (ie: PAL, VLT, AUTH \\ exit to end)"

switch ($script:company) {

    "exit" {
        exit
    }

    "ACS" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=bcd711e04e534afcb0240b65c17e090e"
        $bkg = "http://208.106.176.175/Images/Wallpapers/ACS_Wallpaper.bmp"
    }

    "AHT" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=da36bb68171f46d1830ab41f01d08350"
        $bkg = "http://208.106.176.175/Images/Wallpapers/AmericanHerosWallpaper.jpg"
    }

    "AUTH" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=7d8e106872264a7ab5cee8b035a59921"
        $bkg = "http://208.106.176.175/Images/Wallpapers/Authentic%20Title%20Wallpaper.jpg"
    }

    "BIC" {
        $url = "https://na1vsa14.kaseya.net/deploy/#/76182152372222312513798251/bic.main"
        $bkg = "http://208.106.176.175/Images/Wallpapers/BryantIndustrialWallpaper.bmp"
    }

    "CAD" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=ef1af3ba9c5446c8b7c88ac3a1bb4603"
        $bkg = "http://208.106.176.175/Images/Wallpapers/CaryAudioWallpaper.bmp"
    }

    "FRE" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=ec5c337984f64571ab56f112114d37ad"
        $bkg = "http://208.106.176.175/Images/Wallpapers/FRE_Wallpaper.jpg"
    }

    "NRLG" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=9f6823e88b634176b9f6628474064be0"
        $bkg = "http://208.106.176.175/Images/Wallpapers/NRLG_Wallpaper.bmp"
    }

    "PAL" {
        $pal = Read-Host -Prompt "You have selected Palomino. Is this a (1) Main Office, (2) Home User, or (3) In-Office Remote Client?"

        switch ($pal) {
            1 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=afbd4ebaae7947d5a07d43ace5e70d3d" }
            2 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=098c3e7b97bc47538a565213023c8df7" }
            3 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=51f369a453b444b9b39930a95ab01b70" }
            default { Write-Host "Invalid PAL option selected."; return }
        }
        $bkg = "http://208.106.176.175/Images/Wallpapers/PalominoGroupWallpaper.bmp"
    }

    "QBI" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=7985a846c0a24ea1957e5729090e8568"
        $bkg = "http://208.106.176.175/Images/Wallpapers/QBIwallpaper.jpg"
    }

    "SHO" {
        $sho = Read-Host -Prompt "You have selected Shoaf Law. Is this a (1) Raleigh, (2) Charlotte, or (3) Remote User?"

        switch ($sho) {
            1 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=85ea809cbfe54db8884122f1445b83d1" }
            2 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=6f735f69dbdf454fb1c97ef56300c5aa" }
            3 { $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=a75a8ca6848e4235a228c5f7522f0a5f" }
            default { Write-Host "Invalid SHO option selected."; return }
        }
        $bkg = "http://208.106.176.175/Images/Wallpapers/ShoafLawWallpaper.bmp"
    }

    "SKY" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=c7d83a62f72843b3afad6fad91b84dc9"
        $bkg = "http://208.106.176.175/Images/Wallpapers/Skyrock%20Wallpaper.jpg"
    }

    "TWIZ" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=07c71a86ed3745c8981a054a70bd4c51"
        $bkg = "http://208.106.176.175/Images/Wallpapers/Twiz%20Local%20Profile%20Wallpaper%20(new).jpg"
    }

    "VLT" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=138bf200d88a43b5ad42d4dc757505a3"
        $bkg = "http://208.106.176.175/Images/Wallpapers/VLT_Wallpaper.jpg"
    }

    "VIL" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=fc675d22a6bf4a1f95db490f6f02e1e8"
        $bkg = "http://208.106.176.175/Images/Wallpapers/VillageLawGroupLogo.jpg"
    }

    "VLS" {
        $url = "https://twiznc.vsax.net/installer?type=windows_agent_x64&secret=e7a175a4fbae4dd29a3b36e09b420ae5"
        $bkg = "http://208.106.176.175/Images/Wallpapers/Village%20Surrogacy%20Wallpaper.jpg"
    }

    default {
        Write-Host "That does not align with any known company. Please try again or exit."
        return
    }
}

# Run the download if a URL was set
if ($url) {
    Invoke-WebRequest -Uri $url -OutFile "C:\Users\$($script:enduser)\Downloads\VSAInstaller.msi"
}
if($bkg){
    Invoke-WebRequest -Uri $bkg -OutFile "C:\Users\$($script:enduser)\Downloads\wallpaper.bmp"

    #Set Wallpaper
    $wallpaperPath = "C:\Users\$($script:enduser)\Downloads\wallpaper.bmp"

    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "WallPaper" -Value $wallpaperPath
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "WallpaperStyle" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "TileWallpaper" -Value 0
      # Refresh the desktop to apply the changes without rebooting
    RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters 1, True
}



}

#App install through Winget
function standardwinget{

    winget install --id=Google.Chrome -e --accept-package-agreements --accept-source-agreements
    winget install --id=Zoom.Zoom -e --accept-package-agreements --accept-source-agreements
    winget install --id=WiseCleaner.WiseDiskCleaner -e --accept-package-agreements --accept-source-agreements
    winget install --id=WiseCleaner.WiseRegistryCleaner -e --accept-package-agreements --accept-source-agreements
    winget install --id=voidtools.Everything -e --accept-package-agreements --accept-source-agreements
    winget install --id=Greenshot.Greenshot -e --accept-package-agreements --accept-source-agreements
    winget install --id=Open-Shell.Open-Shell-Menu -e --accept-package-agreements --accept-source-agreements
    winget install --id=VideoLAN.VLC -e --accept-package-agreements --accept-source-agreements
    winget install --id=Foxit.FoxitReader -e --accept-package-agreements --accept-source-agreements
    winget install --id=Google.EarthPro -e --accept-package-agreements --accept-source-agreements
}

#App install through Permanent URLS
function standardweb{
    #BrandOS
    invoke-Webrequest -uri "http://208.106.176.175/BrandOS.zip" -OutFile "C:\Users\$($script:enduser)\Downloads\BrandOS.zip"

    #M365 w/ Classic Outlook
    $exePackageToInstall = "C:\Users\$($script:enduser)\Downloads\OfficeSetup.exe"  
    $arguments = "/quiet" 
    invoke-Webrequest -uri "https://go.microsoft.com/fwlink/?linkid=2276500&clcid=0x409" -OutFile $exePackageToInstall
    Start-Process -FilePath $exePackageToInstall -ArgumentList $arguments -Wait

}



<#
   
$functionselection = Read-Host -Prompt "Would you Like to perform the Cleanup/Tuneup script? [Winget and Windows Updates, Disk Cleanup, SFC/DISM, PCInfo Text File Creation](Y/N)"
   if ($functionselection -eq "Y") {
      wingetupgrade
      diskcleanup
      sfcdism
      PCInfotxt
   }
   Write-Host "" #Used to break up the repeats


#>

#Call Functions
Applysettings
VSAbkg
wingetinstall
standardwinget
standardweb
wingetupgrade
diskcleanup
sfcdism
PCInfotxt


#Reg Unload
if (Test-Path "HKU\$sid") {
    reg unload "HKU\$sid"
}

Read-Host -Prompt "Thank you for using Ben's TechWizard MSP Client PC Setup Script (Press Enter to Exit)"