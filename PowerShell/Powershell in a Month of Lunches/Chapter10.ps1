#page 141

#Formatting
    #It seems like the dotnettypes.format.ps1xml isn't the way anymore startin in PS6. Its now directly in the source code
        #quick search says we can still just make our own and it should override the default.
        #looks like its essential just changing xml properties in a txt file. 
            #find the property or object you are looking for then adjust it accordingly?
        #goes through a few formatting rules. If the default doesn't work (dotnettypes.format.ps1xml) which goes basedo n cmdlet 
        #it goes to the next one which checks if there is any eclared default disply property for an object type. which is in Types.ps1.xml
        #Finally it decides what kind of out put.
            #if 4 or less it uses a table. More it uses a list
    #Format-Table (Ft)
        #-autoSize - makes it size each column to hold its contents and no more. Makes shell take longer. Default is it makes the table fill the width of the window
        #-property - lets you pick and choose the properties that are included. it is positional. and only displays the amount that it can fit on a table.
        #-groupBy - splits the tables up by the selected property. making new tables for each. Works well when you first sort the objects with that same property . Get-Service | Sort-Object Status | Format-Table -groupBy Status
        #-wrap - removes the ... from the end of table when info has to be truncated. expands the table to fit all info.
    #Format-List (Fl)
        #fl displays all the values in each property. an alternative to gm to view the properties in an object
            #"formats the output of acommand as a list of properties in which each proprty is displayed ona seperate line."
            #tends to display more information/propertys of an object than a table.
        #uses a lot of the same propertys as Ft. 
    #Format-Wide (Fw)
        #can only display values in a single property. Default searches for names
        #-column changes # of columns displayed.
    #Using Hash Tables to Format
        #Can use to change column headersGet-Service | Format-Table @{name='ServiceName';expression={$_.Name}},Status,DisplayName
        #Get-Process | Format-Table Name,@{name='VM(MB)';expression={$_.VM / 1MB -as [int]}} -autosize
            #this one uses hash table to do some math in a script block to the content. In this case converts to mbs. Divides the output by 1mb. Then uses -as to make sure its a whole integer.
        #for FT Hash Tables
            #FormatString - lets you pick certain automatic formatting. ie: date, scientific etc.
            #Width - to specify column width
            #Alignment - lets choose wether to align text to left or right.
                #use these to simplify the above command to Get-Process | Format-Table Name,@{name='VM(MB)';expression={$_.VM};formatstring='F2';align='right'} -autosize
                    #format string applys to the expression(value) and makes it in mb
    #If you put a command in that ends in a pipe or unclosed brackets PS will wait for further information.
#Outputting the Formatted information
    #By default everything goes to out-default(which is out-host)
    #can also send to Out-File or Out-Printer
        #these have default width params as well and will need to be configured with -width to display correctly.
    #Out-Gridview 
        #DOES NOT ACCEPT FORMAT CMDLET
        #sends to an ISE pop up window thing.
#Gotchas
    #Format Right
        #format cmdlets should always be the last thing. outside of out-file and out-printer
            #only "out" cmdlets can read the output of format.
#************** ";" Lets you put two commands in the same line without piping. run 2 commands independently and pipe them at the same time **********************
    #Format cannot take multiple kinds of objects. Just takes the first

#Lab
    #1. gps | Format-Table -Property Name,Id,Responding -AutoSize -Wrap
    #2. gps | Format-Table -Property Name,Id,@{name='VM(MB)';e={$_.VM/1MB}, @{name='WS(MB)';e={$_.WS/1MB};}
    #3. Get-EventLog -list | Format-Table -Property @{n='LogName';e={$_.Log}},@{n='RetDays';e={$_.MinimumRetentionDays}}  
    #4. gsv | Sort-Object -Property Status | Format-Table -GroupBy Status
    #5. dir c:\ | Format-Wide -Column 4
    #6. dir C:\Windows *.exe | Format-List -Property Name,VersionInfo,@{n='Size';e={$_.length}}