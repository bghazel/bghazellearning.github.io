#page 157

#Filtering and Comparisons
    #Early Filtering
        #The ideal method, Retrieve only what you specify.
        #ie: gsv -name e*,s*
        #but not all params can be done so easily.
        #-filter works for alot of cmdlets
    #Filtering Left
        #Idea is the earlier you can filter stuff out the better. 
        #lots of interactions to understand.
        #There are different types of filtering. Where-object, get- cmdlets. can use comparison operators. Others cant like wmi
        #this includes location of data. If you are in a remote computer. try to filter data there before moving to local.
    #Where-Object(Where)
        #Can filter pretty much any object once retrieved and put into the pipeline.
    #Comparison Operators
        #takes 2 objects/values and tests their relationship to each other.
        #result is always a boolean (true/false)
        #when comparing strings they are not case sensitive.
        #-eq(equality)
            #ie: 5 -eq 5 (returns true) or "asdf" -eq "sad" (returns false)
        #-ne(not equal) - returns true if not equal.
            #opposite of above. 5 -ne 5 (returns false) or "asdf" -ne "sad" (returns true)
        #-ge/-le (greater than or equal to / Less than or equal to)
            # just >= or <= . if the comparison tracks it returns true. otherwise false
        #-gt/lt (Greater than / Less than)
            # just > and <.
        #for strings you can add a c before any of these to make them case sensitive (-ceq/-cne/-cge/-cle/-cgt/-clt)
        #for multiple comparisons use -and / -or
            #(5 -gt 10) -and (10 -gt 100) is false bc at least one is false
            #(5 -gt 19) -or (1 -lt 100) is true bc at least one is true.
        #Use $false $true to represent true and false boolean values.
        # can use -not(!) to reverse true and false 
            #usefull when dealing with something that already returns a boolean
            #replace $_.responding -eq $False. with -not $_.responding
                #since responding has boolean value reversing it would return $true.
                #kind alike asking "is this program not responding?" (not responding?) and it tells you yes or no
        #-like
            #accepts wild cards so you can do rough comparisons
            #"test" -like "*st" would return true.
        #-notlike
            #does the opposite of above.
        #again add a c for case sensitivity (-clike / -cnotlike)
        #If a cmdlet doesnt take pwrshell comparitors it may take og coding one (< > <= >= = <> !=)
        #Use it going into the filter parameter of where-object
            # gsv | where-object -filter {$_.Status -eq 'running'}
            # read it as a sentence, where status equals running/
            #one object at a time gets put hrough for hte comparison. If false it gets dropped from the pipeline. If true it stays and moves down the pipelin.
        #Use Measure-object to Calculate the numeric properties of objects, and the characters, words, and lines in string objects, such as files of text.
        #Do iterative testing. Like you can slowly add on to your script while testing each step of the way.

#Lab PAGE 165
    #1. Get-NetAdapter | Where-Object {$_.virtual -eq $true}
    #2. Get-DnsClientCache -type A,AAAA         *****************check the main cmdlet dont bury head in the new stuff only.
    #3. dir -path C:\Windows\System32\*.exe | where {$_.Length -gt 5MB}
    #4. Get-HotFix | where -Filter {$_.description -eq 'Security Update'}
    #5. Get-HotFix -Description 'Update' | where {$_.InstalledBy -eq 'NT Authority\System'}      **********same dang issue of only doing the one cmd. Remember to test the base command to see if you can skip any later filtering.
    #6. gps | where {($_.Name -eq 'conhost') -or ($_.Name -eq 'svchost')}        **********gps -Name conhost, svchost there was a simpler way......