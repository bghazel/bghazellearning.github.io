#pipline ||||
    #It takes the output of one command and puts it into another using |
#export/import
    #there are a lot of export and import options. The ones touched on are csv for excel and clixml for xml docs.
    #sometimes the exports contain more info than displayed on the terminal like gps to csv
    #diff (compare-object) sounds amazing. can compare two datasets easily.
        #-reference[object] will be the "correct" or what you compare others to while -difference will be what you compare against the reference
        #you can put paths or put commands in parentheses after -reference[object] or -difference[object]. ie: diff -reference (Import-CliXML reference.xml) -difference (gps)
            #parenthese make certain cmds run first.
        #you can specify what to focus on with -property param. Not sure how it would find that though if for example I made a CSV file manually.********
            #seems like for csv its juist based on the top row.
        #Doesn't work well with text files
#Another option for out putting files is > or out-file .
    #can use > but outfile allows for more params
    #Default only 80 characters wide.
        #there is nonewline or width which might alter that limit
    #very usefull
#can do convertto-* Html was the example which is fun. 
    #just displayed it all in console at first
    #my test was Get-Date | ConvertTo-Html | Out-File test.html
    #oh skipped ahead before the book described the issue i ran into
# commands with the same noun can usually pass info between each other.    
    #getprocess *Chrome* | stop-Process
    #Could be great for mass ending those things that have a million little tabs of processes.
#All cmdlets that modify the system have an impact level that cant be changed unless by the cmdlets creator.
    #if the internal impact is below the systems set $confirmpreference it doesnt ask permission. If above you have to approve.
    #can use -confirm to bypass it
    #can use -whatif to see what would have happened. can use it to preview consequences.

#using get-content tends to just pull raw data and should be used when you want to work with a text file and want the raw text. 
    #use imports for particular formats to get much mroe digestible info

#Lab
    #1. Just shoed the one different line.Not super helpful though as it did specify where.
    #2. sent back path is null. Need to add a path for the out-file
    #3. could i use a wild card? ie stop-service *chrome.exe *********could also do multiple service names as param values.
    #4. can use -delimiter. can use double quotes to specify what to use as the character. -delimiter ('|')
    #5. use the -NoTypeInformation and its a switch.
    #6. -noclobber, -confirm
    #7 -useculture