#This is a script to test Initializing a newly created user without leaving the script


"Username: $script:enduser" >> C:\ITGlueInfo.txt


New-LocalUser -Name "$script:enduser" -Password $script:password -Description "$script:enduser's Profile"
Add-LocalGroupMember -Group "Administrators" -Member "$script:enduser"             #Adding as admin

  try {
    $username = "$env:COMPUTERNAME\$($script:enduser)"
    $cred = New-Object System.Management.Automation.PSCredential($username, $script:password)

    Write-Host "Triggering profile creation for $username..."

    # random command to initialize profile
    Start-Process -FilePath "cmd.exe" -Credential $cred -ArgumentList "/c exit" -WindowStyle Hidden -Wait

    Start-Sleep -Seconds 15  # Give Windows a moment to finish writing the profile
  }
  catch {
    Write-Host "Failed to initialize the user profile: $_"
  }


#####################


Add-Type -TypeDefinition @"
using System;
using System.Security.Principal;
using System.Runtime.InteropServices;

namespace UserProfile {
    public static class Class {
        [DllImport("userenv.dll", SetLastError = true, CharSet = CharSet.Auto)]
        public static extern int CreateProfile(
            [MarshalAs(UnmanagedType.LPWStr)] String pszUserSid,
            [MarshalAs(UnmanagedType.LPWStr)] String pszUserName,
            [Out][MarshalAs(UnmanagedType.LPWStr)] System.Text.StringBuilder pszProfilePath,
            uint cchProfilePath
        );
    }
}
"@

$UserA = Get-LocalUser -Name 'UserA'

Write-Output "Erstelle Benutzerprofil von 'UserA' ..."
$sb      = New-Object System.Text.StringBuilder(260)
$pathLen = $sb.Capacity

try {
    $CreateProfileReturn = [UserProfile.Class]::CreateProfile($UserA.SID, "UserA", $sb, $pathLen)
}
catch {
    Write-Error $_.Exception.Message
}

switch ($CreateProfileReturn) {
    0 {
        Write-Output "User profile created successfully at path: $($sb.ToString())"
    }
    -2147024713 {
        Write-Output "User profile already exists."
    }
    default {
        throw "An Error occurred when creating the user profile: $CreateProfileReturn"
    }
}


#############

$Username = "UserA"
$Password = "Pa$$w0rd!"  # Replace with the actual password
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential("$env:COMPUTERNAME\$Username", $SecurePassword)

# Create temporary file to run under the user session
$TempScript = "$env:TEMP\TriggerProfile.ps1"
"Write-Output 'User profile triggered.'" | Out-File -Encoding UTF8 -FilePath $TempScript

# Start a PowerShell process as the user to trigger profile creation
Start-Process -FilePath "powershell.exe" `
    -ArgumentList "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$TempScript`"" `
    -Credential $Credential `
    -WindowStyle Hidden

Start-Sleep -Seconds 5

# Cleanup
Remove-Item $TempScript -Force

# Check if profile path now exists
$UserObj = Get-LocalUser -Name $Username
$SID = $UserObj.SID.Value
$ProfileRegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$SID"

if (Test-Path $ProfileRegPath) {
    $ProfilePath = Get-ItemProperty -Path $ProfileRegPath -Name ProfileImagePath
    Write-Output "Profile created at: $($ProfilePath.ProfileImagePath)"
} else {
    Write-Warning "Profile was not created. Ensure the password is correct and the process ran."
}