#locate and unlock a specific user account
Import-Module ActiveDirectory
$lockedAccount = Search-ADAccount -Lockedout

$UserToUnlock = Read-Host "Enter Username to unlock"

foreach($user in $UserToUnlock){
    if($lockedaccount -eq $UserTounlock){
        Unlock-ADAccount -identity $UserTounlock
        Write-Host "User account has been unlocked"
    }
    else{
    Write-Host "User account not found"
    }
}
#expand on the script above

$passwordLog = "C:\PasswordResetLog.txt"
$Administrator = [bool](New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())) | Out-Null

if($Administrator -eq $false){
    Write-Host "You do not hold power here. Contact your administrator"
    $logEntry= "$(get-date) unaurhotrized access attempted by $env:USERNAME"
    Add-Content -Path $PasswordLog -value $logentry

    Exit
}
$username = Read-Host "Enter your Username"

$account = Get-ADUser -Filter{SamAccountName -eq $username}
if($account -eq $null){
    write-host "Account not found"
    $logEntry= "$(get-date) $account not found"
    Add-Content -Path $PasswordLog -value $logentry

} elseif ($account.Enabled -eq $false){
    Write-Host "Account locked. Would you like reset the password?"
    Write-Host "Enter Y to unlock"
    $answer = Read-Host
    if($answer -eq "Y" -or $answer -eq "y"){
        Unlock-ADAccount -Identity $account
        $newPassword = Read-Host "Enter your new password" -AsSecureString
        Set-ADAccountpassword -Identity $account -NewPassword $newPassword -Reset
        Write-Host "Passwword reset successful"

        $logEntry= "$(get-date) Password reset successful for user $account"
        Add-Content -Path $PasswordLog -value $logentry
    }
    else{
        write-host "Tough luck"
        $logEntry= "$(get-date) Account remains locked for $account"
        Add-Content -Path $PasswordLog -value $logentry
    }
    else {
        $newPassword = Read-Host "Enter the new password" -AsSecureString

        Set-ADAccountPassword -Identity $account -NewPassword $newPassword -Reset
        Write-Host "Password reset success"

        $logEntry= "$(get-date) password reset success"
        Add-Content -Path $PasswordLog -value $logentry
    }
}
