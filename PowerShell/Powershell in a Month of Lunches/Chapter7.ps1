#Microsoft Management Console (MMC)
    #Used it plenty just didn't know what its base was called.
    #snapins are what the different modules are called.
    #can get them from management tools associated with products. Most of which auto download and give u a preconfigured mmc with just their addins
    #can mix and match however you want.
    #Powershell works the exact same way.
#product specific Management shells
    #all are powershell and there is only one powershell they just import-module their specific module. like Import-Module ActiveDirectory
    #exception is SQL server 2008. they have their own thing called a mini-shell. was a method microsoft tried and abandoned.
#Powershell Snap-ins (PSSnapin)
    #microsoft moving away from it. In fact they have been replaced by modules now. this section is somewhat obsolete.
#Modules!
    #I think at this point have replaced snapins
    #env:PSModulePath is what defines where ps will look for the modules.
        #there are quite a few including one for vscode.
        #it is a variable set by windows enviroment. Can be changed via control panel or gpo
        #put modules there and ps will auto discover htem and load them all the time. will also updated them when update-help is ran.
        #find the path for them using properties in context menu.
    #can load providers too.
    #module commands tend to just add a prefix to their commands. like get-ADUser. Is best practice to avoid conflicts with other similar commands
    # Console File 
        #load in all the modules that you would like to have be default
        #do export-console C:\path to wherever
        # create powershell shortcut pointing to %windir%\system32\WindowsPowerShell\v1.0\powershell.exe -noexit -psconsolefile c:\myshell.psc
        # This might be deprecated bc snapins are outdated and modules are auto loaded? ************** This is correct you can just use the profile variable/file. $Profile | Select-object * make a ps1 file with all the modules you want to load in
#powershellget
    #find-module to see list
    #install-module to download one of them

#Lab
    #help *trouble* help *get-trouble* help *invoke-troub*.  shows the basic path for the trouble shootingpacks and how to use them. 
    #Followed the path up until it selected audio. typed n and tabbed to networking. 
    #then did Get-TroubleshootingPack 'C:\Windows\diagnostics\system\Networking' | Invoke-TroubleshootingPack and followed the instructions

