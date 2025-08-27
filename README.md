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
<br>    - Added a whole bunch to the cleanup script including recycle/downloads cleanup, defrag/trim, and got it working with the wise cleaners. With that the last 2 steps of our checklist should be automated. Also discovered how to auto elevate a sript. Just check to see if launched as admin then startprocess with -verb -RunAs. 
<br>    - Made a PCInfo Script that just pulls all the most needed information about a computer, name,ip,serial number etc. Hoping to use that to replace the third party program we use and add it to a full script to automate out that part of our checklist.
<br>    - created a full cleanup-tuneup script. I've seperated out all the scripts ive made so far into functions to be able to easily call them and then set up a quick little interactive gui to select what someone wants to use and to use them all. Will see if I want continue expanding on this or leave this as our one click cleanup tuneup. Right now it eliminates the last 3 steps of our new pc setup checklist :)
<br><br>
8/27/25
<br>    - I think I'd like to see if I could fit the entire MSP Client: New PC Setup checklist into a script. Or at least see how much I can fit into one. Some of it will probably be less intuitive or slower than just doing it through gui but I'll be able to eliminate those once I find it. I think I'll just go down the checklist and see what I can put into script instead.