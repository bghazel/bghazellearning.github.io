#page 107

#Objects
    #Object—This is what we’ve been calling a table row. It represents a single thing,such as a single process or a single service.
    #Property—This is what we called a table column. It represents one piece of information about an object, such as a process name, process ID, or servicestatus.
    #Method—This is what we called an action. A method is related to a singleobject and makes that object do something—for example, killing a processor starting a service.
    #Collection—This is the entire set of objects, or what we’ve been calling a table.
    #Objects remain in their entirety until the end of the pipleine where it is reduced to be visually understandable.
#get-member (gm) **********
    #use this to learn more about an object. It is the object version of help. Alias is Gm
    #it gives a list of every single property and method(action) available for the info that the piped in cmdlet has.
    #property, methods, events etc are known as members.
        #There are 4 property types?   ScriptProperty, Property, NoteProperty, AliasProperty
            #Effectively the same
            #powershell adds these itself to make things a bit more consistent as some dont have parity? 
#You can use methods(actions) but often cmdlets will do it for you.
    #ie stop-process -name notepad
#Event is an object notifying that something happened. Can be used to trigger other actions. When something has an exit even trigger a popup message etc
#cmdlets produce objects in a defined order by default. 
    #can use Sort-Object(sort) to change that
        #ie:: gps | sort-object -property(is a positional) VM -desc(ending)
            #doesnt seem like VM is shown. PM(paged memory) worked though.
            #can add a comma for another property and it will prioritze them in order. like gps|sort pm, id -desc would sort by pm and if there is an equal it will then sort by id.
#Use Select-Object(select) to pick out the properties that you want. ie: gps | Select -Property Name,ID,VM,PM | ConvertTo-Html |out-file  test2.html
    #you can just pick the first or last # of properties as well. Select -first 10
    #think of it as highlighting the columns in the table before pasting them into the next command.
    #Where-Object does the opposite of select. It removes the listed properties from the pipeline.

#Lab
    #1. Get-Random
    #2. Get-Date
    #3. System.DateTime
    #4. Get-Date | Select DayOfWeek 
    #5. Get-HotFix
    #6. Get-HotFix | Sort-Object InstalledOn | Select InstalledOn,InstalledBy,HotFixID
    #7. Get-HotFix | Sort-Object -Property Description | Select-Object Description,HotfixID,InstalledOn | ConvertTo-Html |Out-File lab87.html  ***********why does installdate not work?  - seems like it just tends to be neglected to be filled.
    #8. get-eventLog -Logname System -Newest 50 | Sort-Object TimeGenerated,Index | Select-Object -Property Index,TimeGenerated,Source | Out-File lab88.txt  ********default order is ascending dont need another tag?