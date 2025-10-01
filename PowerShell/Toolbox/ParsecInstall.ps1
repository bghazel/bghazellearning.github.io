#The goal of this script is to install parsec and use their commands to set it up automatically in optimal conditions. I'd also like to be able to alter existing instillations to be "per computer" through the config
Start-Transcript -Path "C:\Toolbox\Logs\parsecinstall.log" -Append



function uninstall{
    Write-Host "Uninstalling previous Parsec Installation"
    if(Test-Path "C:\Program Files\Parsec\uninstall.exe"){
        Start-Process -FilePath "C:\Program Files\Parsec\uninstall.exe" -ArgumentList "/silent" -Wait
    }
    else {
        Write-Host "Parsec is not currenctly installed"
    }
    if(Test-Path "C:\Program Files\Parsec Virtual Display Driver\uninstall.exe"){
        Write-Host "Uninstalling previous Parsec VDD Installation"
        #Start-Process -FilePath "C:\Program Files\Parsec Virtual Display Driver\uninstall.exe" -ArgumentList "/silent" -Wait
        #no way to uninstall wihout gui pop up sadly. However learned that if I want to find uninstall paths/arguments use get-package *programname* | % { $_.metadata['uninstallstring'] }
    }
    else {
        Write-Host "Parsec VDD is not currently installed"
    }
   # Parsec Virtual USB Adapter Driver\uninstall.exe"

}

function install{
    Write-Host "Installing Parsec"
#Download Installer
    Invoke-WebRequest -Uri "https://builds.parsec.app/package/parsec-windows.exe" -OutFile $env:USERPROFILE\Downloads
#Run installer through CLI silently
    cmd.exe  /c "$env:USERPROFILE\Downloads\parsec-windows.exe /silent /percomputer /vdd"
}



#call functions
uninstall
install


Stop-Transcript

