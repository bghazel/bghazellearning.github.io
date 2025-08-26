#The plan for this one is to try and replace the system info application we use to pull all the info about a computer into a txt file. I'm think that Get-ComputerInfo might do the trick

#found a command to make a self elevating script to bypass admin. Just seems to check if current user has the admin role. then does the verb runas admin command. This might be a good default header??
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

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