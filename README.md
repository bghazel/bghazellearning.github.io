# Ben Hazel's Learning Repository

This is my github Repository where I am learning powershell and other tools to further my IT Career. In this read me will be a log of my goals.

# Progress Log

8/25/25 
<br>    - The first longterm goal I'd like to set is to understand powershell at a basic level and gain the ability to automate more of the tasks I repeatedly do. First project to bang my head aginst is to run DISM and SFC scans through a .ps1 script. Not the most usefull but should hopefully help me get the basics of how to call a command like that
<br>    - I reorganized my GitHub Repo and seperated out the old files into folders. Setup github remote repo on VSCode and installed all my needed extensions. Turns out you have to clone the repo as PS run+debug doesn't run through remote repo. Got the PS extension working on work computer through threatlocker in a safe manner by adding an exclusion that had the conditions that it was in a specific folder and created by my VSCode client.(With aproval of manager)
<br>    -Created a quick hello world script to test.
<br><br>
8/26/25
<br>    - Created a script that runs the dism and SFC scans consecutively then leaves a notification and ends. Learned about the run-process command and how to use file path or just shortened title. learned about run-process different modifiers like -runAs to run as admin.  -argument list allows me to input commands that a certain program might request. Have to find documentation for what arguments can be input can also try the /? parameter if its supported
<br>    - Created a script to run the disk cleanup tool with all option selected and then automatically close it. The automatically close it part was what ended up being more difficult as the running it is a single line of code. Learned about the get-process command which was fun, it has lots of different modifiers/parameters. Ended up using the mainwindowtitle as the end result screen would be different than the actual cleaning program. used a while loop to check it until done. Maybe later I'll check to see if there is a more efficient way to do this as right now I think it just spams it really fast until it finds what its looking for.