#The goal of this script is to Download the usefull scripts that I've made onto every computer in the same spot to make a toolbox.
#https://github.com/bghazel/bghazellearning.github.io/tree/main/PowerShell/Toolbox

# Self Elevate
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`""
    exit
}

#Create Toolbox Folder
$path = "C:\Toolbox"
If(!(test-path -PathType container $path))
{
      New-Item -ItemType Directory -Path $path | Out-Null
}

#Create Toolbox Log Folder
$path = "C:\Toolbox\Logs"
If(!(test-path -PathType container $path))
{
      New-Item -ItemType Directory -Path $path | Out-Null
}

#Pull List File from Github
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bghazel/bghazellearning.github.io/refs/heads/main/PowerShell/Toolbox/List.txt" -OutFile "C:\Toolbox\_List.txt"

#Parse each line of list for tool name
Get-Content C:\Toolbox\_List.txt | ForEach-Object {
    $line = $_ -replace '\(.*?\)', ''
    Write-Host "Processing $line"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/bghazel/bghazellearning.github.io/refs/heads/main/PowerShell/Toolbox/$line" -OutFile "C:\Toolbox\$line"
}

Write-Host "ToolBox Creation Complete"

