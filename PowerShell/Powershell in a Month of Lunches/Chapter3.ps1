#Learning about the help function (or get-help commandlet :p )
# using stars(*) as wild cards on either end of a search to help find anything including your search (help *log*)
# help searches help documents not commands us gcm(Get-Command) to find a specific command which will also provide externall commands like netevent.dll (if use gcm *event*)
    #you can reduce this using the -noun and -verb parameters bc only the pwrshell cmdlets have those.
    #or use -Command-Type

#Syntax
    #may show multiple options or "parameter sets". Each will have unique aspects
    #If you use a paremeter that is exclusive to one showed list of syntax you must stay within that sets.
    #ie, get-eventlog -list and -logname are mutually exclusive bc they show up in different sets.
    #it may run if you mix sets BUT powershell only uses the first listed set. ie: if you use both -list and -logname. -list being first would make its set take precedence
#Parameters        
    #<CommonParameters> seems important to remember
        #Debug (db)
        #ErrorAction (ea)
        #ErrorVariable (ev)
        #InformationAction (infa)
        #InformationVariable (iv)
        #OutVariable (ov)
        #OutBuffer (ob)
        #PipelineVariable (pv)
        #ProgressAction (proga)
        #Verbose (vb)
        #WarningAction (wa)
        #WarningVariable (wv)
    #There are optional and mandatory parameters. *****Optional Parameters are marked in [square brackets]*****
    #you only need as much info as will allow powershell to find the command without other options. ie: abbreviate -list to -Li in get-eventlog as there is no other parameter with li in the name.
    #Positional Parameters are so common that you can enter a value without the parameter name if it is in the right location.
        #indicated by [Square brackets] around JUST THE NAME not both the name and value. ie [-Logname] <string>
        #indicated by double [square brackets] [[-InstanceId] <Int64[]>]
        #Position is based on the first UNNAMED paramter. can have as many named ones before it. It is only tracking the position of the unnamed parameters.
    #think of Switch Parameters as typing it turns on the switch. If it is in your command it is on, otherwise it is off. They dont require a value.
    #Values will always be seperated from name with a space and be surrounded by <hairpins>
        #String - a series of letters and numbers. if there is a space must be surrounded by 'quotes'. use single quotes as best practice
        #Int,int32, int63 - any whole number(no decimal)
        #DateTime - just date and time based on your region. ie: US would use 10-10-2026 (m-d-y)
        #Extra [square brackets] (ie: <string[]>)mean it CAN accept an array, collection or list of strings.
            #you CAN do single values
            #If you are putting values with spaces. EACH value has its own 'quotations' not the whole list. You can use quotations even if there is no space.
            #can enter it in a txt file, each line in the file is a new value.
                #use (parentheses) to force commands to execute first.
                    #ie: Get-EventLog Application -computer (Get-Content names.txt)
#Use -online to pull up the webpage based help. Often more up to date.

#Lab
    #2. did help *html* which gave ConvertTo-Html
    #3. did help *printer* most likely option seemed to be Out-Printer. same with help *file* gave Out-file. help *out* returned a good number of those output options.
    #4. did gcm -noun *process* gave me 14 options. 2 of which are functions. so 12 cmdlets that deal with processes.
    #5. help *write*. Write-EventLog seems the correct option
    #6. help *alias* export/import/new/set-alias seem to be what they are looking for.
    #7. help *transcript* . Start and stop -transcript 
    #8. help *event* returns "Get-EventLog" | help Get-EventLog should want to use newest and entry type?| Get-EventLog -EntryType 'Security' -Newest 100 not entrytype thats the fail not which log use? logname instead?|  Yes, Get-EventLog -LogName 'Security' -Newest 100 seems correct.
    #9. help *service* help *remote* it looks like they want the computer name parameter but that is outdated maybe they want Connect-PSSession?. -online shows Invoke-Command might be the solution. Would maybe have to do a script block? or just a file with a script. help about_script_Blocks |  Invoke-Command -ComputerName example -ScriptBlock {Get-Service}
    #10. Same idea as #9 but with Get-Process instead, Invoke-Command -ComputerName example -ScriptBlock {Get-Process}
    #11. help Out-File it has the same display as the terminal. interestingly you can use > to do outfile. Use the -width parameter to change it. 
    #12. Use -Append to not have it erase but add on to a file               *********** -NoClobber *************
    #13. help about_aliases? Get-Alias seems to do it
    #14. I am assuming they want gps -ComputerName Server1? doesn't seem to be a alias or shorthand for computername in modern pwrshell. 
    #15. 12 in modern powershell. did help *object* *************couldve done gcm -noun object
    #16. did help *array* which pulled up About_Arrays which I coudlve done with help About_Arrays. you just assign multiple things to a variable $ with a comma and space in between between the equal and beginning of the list. can do ranges with ..


