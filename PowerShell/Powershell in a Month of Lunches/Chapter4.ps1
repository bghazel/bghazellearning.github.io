#Anatomy of a Command
    #Powershell commands always have verb-noun
    #paramters always -name value. switch parameters at the end.
    #Paramaters always start with - and always have a space after param name.
    #nothing is case sensitive
#Terminology
    #cmdlet is powershell native. built on .net. can be useful to add to google searches to reduce down to only pwershell things.
    #function similar to cmdlet but written in powershell language rather than .net.
    #application external Executable. ie: ping
    #Command broad term containg all of the above.
#Aliases
    #use get-Alias -Definition "cmd name" to get aliases and shorten how much I have to type
    #help alias to reverse that ie: help gsv  should return get-service
    #you can create new aliases with New-Alias. They only last as long as the session. can export them as a list and import them later.
        #can even do aliases for non pwrshell commandlets. like doing New-Alias -Name np -value notepad.exe. which just run notepad
#Shortcuts
    #can do shortcuts for Parameters. which is kinda like an alias. a few ways.
    #truncating - just type as much as is needed for there not to be another option. -compo -compu for composite or computername etc.
    #aliases. which are apparently a pain to find? (get-command get-eventlog | select -ExpandProperty parameters).computername.aliases 
    #positional Parameters. put them in the correct order and you dont have to use the name.
#Show-Command    
    #Grahpically prompts for the paramters when u enter a command for it. Making it nearly drag and drop commands lol. Can only do for single commands tho.
#External Commands
    #powershell basically lets u use all of the other things through powershell. Like ping running cmd or net use.
    #tends to start breaking with lots of paramters for external commands
        #can put paramters into variables to try and get past powershell trying to decipher them and failing.
        #or now you can just do --% in front of the paramters
    #Test-Connection might be a usefull one day to day.

#Lab

#1. Get-Process
#2. Get-EventLog -Logname Application -Newest 100
#3. gcm -commandtype cmdlet
#4. Get-Alias
#5. New-Alias -Name np -value notepad.exe
#6. gsv -name M*
#7. Get-NetFirewallRule
#8. Get-NetFirewallRule -Direction Inbound
