#Page 100

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

