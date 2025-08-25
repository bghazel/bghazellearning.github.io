#Plan here is to run DISM /Online /cleanup-image /restorehealth and then sfc /scannow in one click.
#Once that is working attempt to have the output logged in easily accesible file.


#Quick Google search brings me this. Will test then break it down to understand.

Start-Process -FilePath “${env:Windir}\System32\SFC.EXE” -ArgumentList “/scannow” 
Read-Host -Prompt "Press Enter to Exit"