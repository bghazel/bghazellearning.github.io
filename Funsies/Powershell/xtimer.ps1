#was hoping to create a script that would quietly be in the background waiting for a certain key press then start a timer and a beep at the end of the timer. It is unfortunately not possible in powershell, switching to AHK

<#
Start-Job -ScriptBlock{
    do {
        $key = [System.Console]::ReadKey($true) # $true hides the key input
    } until ($key.KeyChar -eq 'q') # Wait until 'q' is pressed
    Write-Host "test"
    $timerDuration = 42
    Start-Sleep -Seconds $timerDuration
    [console]::beep(1000, 500)
}

#>

<#
Start-Process powershell -ArgumentList "-NoExit", "-Command", {
    do {
        $key = [System.Console]::ReadKey($true)
    } until ($key.KeyChar -eq 'q')

    Write-Host "test"
    Start-Sleep -Seconds 5
    [console]::beep(1000, 500)
}

#>