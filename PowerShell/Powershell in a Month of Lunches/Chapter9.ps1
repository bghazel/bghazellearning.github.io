#page 119

#Pipeline Parameter Building
    #default way of getting info from pipeline onto a paramater is starting with ByValue if that fails then it moves on to ByPropertyName
    #ByValue
        #checks the type of object produced from the first command and tries to fit it into a matching paramater type in the second command.
            #the example is a text file get-content (string) into Get-Service. But in gsv there is only one string parameter which is Name. which we cant use
            #Powershell only allows one parameter per type when getting info ByValue.
        #if commands have same noun odds are it will work.
    #ByPropertyName
        #This compares the names of each of the members in the first command and trys to match them up with the name of a paramater in the second.
            #ie property "name" into the paramater "-name"
            #The entrys have ot make sense to the ending command though. If it doesn't know what to do with a .exe it fails regardless of if there is a match up.
        #It then cheks whether that Paramater accepts inputs from "ByPropertyName" (which can be found in help -full)
        #can use a CSV file with seperated comma lists to put into different commands. using the top line to create parameters by matching the names to whatever command you want to use.
            #the example they used was creating aliases. labeling the first two columns(by using the top row) as name and value. Which both align with new-alias parameters.
            #think of the object table again. top row is the parameters. each row after is a new entry into the parameters.
            #would allow you to much more quickly run large datasets through commands? design csv for use of certain commands.

#When things dont line up
    #Hash Table   ********************important to review*************
        # made with @{ }
        # essentially equating to things together a=1 b=2 c=3? then using that to understand data better for powershell.
        # start with defining the name of the ending parameter. (first key) 
            #this has aliases it can be name, n, or label.
        #then you assign its equivalent in the data set using expression (second key)
            #alise is "e"
            #you can use {} to create a script block. self contained bit of code.
        #use this whole thing as a single value which can be added to a parameter in a comma list.
        #looks like this
            #@{name(or n or label) ='desiredparametername' ; expression(or "e") = {$_.originaldata}}
            #@{n='name';e={$_.login}}
    #Can also use (parentheses) to organize where a cmdlets output goes directly.
        #Like putting it directly int oa parameter
        #get-wmiobject -class wind32_BIOS -computerName (Get-content .\text)   ******************************** Also important to review****************************
            #instead of putting the output of the getcontent into wmiobject. and having to pipe it in. (which the param doesnt accept) it does the get-content cmdlet right away and puts that output(which is a string) directly into the parameter. NO Piping required  
            #think of a cmdlet thats been run as its output. so if its self contained and prioritzed in () then it is basically just a string ready to be used.
            #has to be the correct type of output.
                #if it isnt you can use the select-object -expandproperty(expand) parameter  ************************
                    #you can select just the property you want and outputs its value in its type.
                    #ie: Select-Object -expandpropert name. Name would have the type of Name so it wouldn't work in another cmdlet. but expand takes names value (which is a string) and sends that as the output.
    #Looks like computername for get-process doesn't exist anymore and we have ot use invoke-command?
        #gotta have winrm running? and then approve it as aconnection from my side. 
            #Enable-PSRemoting -Force
                #would have to move the network settings to be on private. or allow public. Dont want to change anything at work rn though.
            #Set-Item WSMan:\localhost\Client\TrustedHosts -Value (Import-Csv .\computers.csv | select -ExpandProperty hostname) to trust a computer on the local network
            #Invoke-Command -ComputerName (Import-Csv .\computers.csv | select -ExpandProperty hostname) -ScriptBlock {Get-Process}


#Lab

    #1. yes, the content inside the parentheses takes the ADcomputer types and expands it to take the string thats within that. which is then directly put into the -computername parameter
    #2. No, get-ADcomputer returns an adcomputer type which odds are get-hotfix does not accept
    #3. yes, get hotfix takes pipeline. this equates the name to the correct name.  ******************* Need to remember to check what accepts what. Got stuck in the mindset that I was working through before and almost answered incorrectly
    #4. get-ADComputer -filter * | select-object -expand name  | get-process   *********same goes here.
    #5. again -computername i believe has been removed but if I were doing the invoke command instead. Invoke-Command -ComputerName (get-ADComputer -filter * | select-object -expand name) -ScriptBlock {get-service}
    #6. Im assuming no. but wmi and computername for wmi have been deprecated since the making of this book.