#The goal of this script is to install our RMM and all the various standard apps.

#Self Elevate
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

#Defining Variables
$script:company = $null
$script:enduser = Read-Host -Prompt "End Users Name" #Will be pulled from full script C:\Users\Ben\Downloads


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

#Install Winget

function wingetinstall{
    # Get the download URL of the latest winget installer from GitHub:
$API_URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$DOWNLOAD_URL = $(Invoke-RestMethod $API_URL).assets.browser_download_url |
    Where-Object {$_.EndsWith(".msixbundle")}

    # Download the installer:
Invoke-WebRequest -URI $DOWNLOAD_URL -OutFile winget.msixbundle -UseBasicParsing

    # Install winget:
Add-AppxPackage winget.msixbundle

    # Remove the installer:
Remove-Item winget.msixbundle
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


Read-Host -Prompt "asdf"

