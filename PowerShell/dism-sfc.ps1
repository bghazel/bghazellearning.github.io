#Plan here is to run DISM /Online /cleanup-image /restorehealth and then sfc /scannow in one click.
#Once that is working attempt to have the output logged in easily accesible file.


#Quick Google search brings me this. Will test then break it down to understand.
#Start-process is a good find. can be used for nearly anything - ${env:Windir} refers to the windows environment its being run in and references it to make more universal path. 
#-argumentlist allows for entry of the various options a program might have. -verb RunAs to run the called program as admin.

Start-Process -FilePath "dism.exe" -ArgumentList "/online /cleanup-image /restorehealth" -Wait -Verb RunAs

Start-Process -FilePath “${env:Windir}\System32\SFC.EXE” -ArgumentList “/scannow”  -Wait -Verb RunAs

Read-Host -Prompt "Scans have finished running. Press Enter to close this window now"

#-RedirectStandardOutput C:\