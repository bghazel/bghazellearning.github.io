#Learning about the help function (or get-help commandlet :p )
# using stars(*) as wild cards on either end of a search to help find anything including your search (help *log*)
# help searches help documents not commands us gcm(Get-Command) to find a specific command which will also provide externall commands like netevent.dll (if use gcm *event*)
    #you can reduce this using the -noun and -verb parameters bc only the pwrshell cmdlets have those.
    #or use -Command-Type

#Syntax
    #may show multiple options or "parameter sets". Each will have unique aspects
    #If you use a paremeter that is exclusive to one showed list of syntax you must stay within that sets.
    #ie, get-eventlog -list and -logname are mutually exclusive bc they show up in different sets.
    #it may run if you mix sets BUT powershell only uses the first listed set. ie, if you use both -list and -logname. -list being first would make its set take precedence
#Parameters        
    #<CommonParameters> seems important to remember
    #There are optional and mandatory parameters. *****Optional Parameters are marked in [square brackets]*****
    #you only need as much info as will allow powershell to find the command without other options. ie, abbreviate -list to -Li in get-eventlog as there is no other parameter with li in the name.
    #Positional Parameters are so common that you can enter a value without the parameter name if it is in the right location.
        #indicated by [Square brackets] around JUST THE NAME not both the name and value. ie [-Logname] <string>
        #indicated by double [square brackets] [[-InstanceId] <Int64[]>]
        #Position is based on the first UNNAMED paramter. can have as many named ones before it. It is only tracking the position of the unnamed parameters.
    #think of Switch Parameters as typing it turns on the switch. If it is in your command it is on, otherwise it is off. They dont require a value.
