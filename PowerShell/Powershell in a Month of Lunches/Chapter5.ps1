#Currently on page 69

#Providers
    #an adapter designed to make some data look like a drive.
    #What Providers exists
        #Alias, Environment, FileSystem, Function, Registry, Variable, WSMan(remote)
    #Capabilities
        #ShouldProcess—The provider supports the use of the -WhatIf and -Confirm parameters, enabling you to “test” certain actions before committing to them.  
        #Filter—The provider supports the -Filter parameter on the cmdlets that manipulate providers’ content.  
        #Credentials—The provider permits you to specify alternate credentials when connecting to data stores. There’s a -credential parameter for this.  
        #Transactions—The provider supports the use of transactions, which allows you  to use the provider to make several changes, and then either roll back or com- mit those changes as a single unit.
    #PSDrive is like mapping a drive on windows explorerer. YOU USE A PROVIDER TO CREATE A PSDRIVE
        #get-psdrive to see all currently setup ones
        #Provider adapts data, psdrive makes it accessible.
        #Usually used in cmdlets that have "Item" in the name. get-item, clear-item etc

#Powershell lumps files and folders both into the term "Item"
    #Some have properties or "ChildItem"s.
#Each provider gives access to something different, and not all can use every property or cmdlet.

#Set-Location to change shells current location. use -path to set a path. ie: Set-Location -Path C:\Windows
    #aka cd from cmd. -path not needed as its now a positional parameter.

#When making an item you have to specify types. like a directory for a folder.
    #there is mkdir to make a folder. its a function that auto adds the type. 

#Wildcards
    # * stands in for 0 or more characters. so any amount.
    # ? stands in for only a single character
        #not useable for names in file systems.  
        # * and ? can be in some drives like it IS IN Registry. Use -LiteralPath to tell pwrshell to not accept wild cards
        #while -path can be a positional param -literalpath is not.

#dir is alias for get-childitem
    #I am a bit confused on how doing just dir *.exe pulled up as it did in the example. I am not prompted for a directory when doing that, maybe just a version dif. I did dir -path C:\Windows\*.exe

#can set location to a registry path. Then empty get-children will just provide info on current location
#End of registry paths have the actual keys as propertys. So you get to the end folder(item) then change the property 