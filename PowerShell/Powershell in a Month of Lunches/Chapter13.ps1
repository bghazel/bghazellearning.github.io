#on Page 171

#Remote Control! *******kinda worried this one is out of date based on previous mentions...****
    #looks like that isnt the case. -computername was somewhat abandoned. and swapped to remoting.
    #dont even have to have the same modules

#Remote Powershell
    #Powershell uses WS-MAN primarily
        #SSH is still an option and has been pushed more recently.
        #Goes through HTTP or HTTPS
        #WinRM is what it works through
            #Auto on on servers but not on regular pc clients'
    #Powershell takes objects returned from cmdlets and turns them into XML's that are transmitted nad then deserialized
        #Serialization is a form of format conversion. XML->object or back.
        #These only return snapshots. they dont update themselves.
            #Cant instruct it to stop itself. ******meaning any commands would have to be one line with piping?
    #Ideally you want to be part of the same/trusted domain :/
        #help about_remote_troubleshooting     for help on doing a non domain option.
        #I think this is where I need to stop and setup a domain at home or on a vm.
        