toggle := false

^g::  ; Ctrl + U toggles the auto-clicker
toggle := !toggle
if (toggle)
{
    SetTimer, ClickLoop, 1
}
else
{
    SetTimer, ClickLoop, Off
}
return

ClickLoop:
    MouseClick, Left
return

*F1::  ; Ctrl + G pauses and suspends the script
Suspend
Pause, 1
return

*F2::  ; F2 exits the script
ExitApp
return