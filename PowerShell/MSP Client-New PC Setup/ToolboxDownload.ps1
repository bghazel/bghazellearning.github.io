#The goal of this script is to Download the usefull scripts that I've made onto every computer in the same spot to make a toolbox.
#https://github.com/bghazel/bghazellearning.github.io/tree/main/PowerShell/Toolbox

# Self Elevate
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
    exit
}
<#
Invoke-WebRequest -Uri https://raw.githubusercontent.com/thomasmaurer/demo-cloudshell/master/*.ps1 -OutFile .\helloworld.ps1

https://github.com/bghazel/bghazellearning.github.io/blob/main/PowerShell/Toolbox/WingetInstall.ps1
https://raw.githubusercontent.com/bghazel/bghazellearning.github.io/refs/heads/main/PowerShell/Toolbox/WingetInstall.ps1
#>
read-Host "TEST1"

#Pull List File from Github
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bghazel/bghazellearning.github.io/refs/heads/main/PowerShell/Toolbox/List.txt" -OutFile "C:\Toolbox\List.txt"

Get-Content C:\Toolbox\List.txt | ForEach-Object {
    Read-Host "processing Line $_"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bghazel/bghazellearning.github.io/refs/heads/main/PowerShell/Toolbox/$_.ps1" -OutFile "C:\Toolbox\$_.ps1"
}


