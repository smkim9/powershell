#locate and unlock a specific user account

$lockedAccount = Search-ADAccount -Lockedout

$UserToUnlock = Read-Host "Enter Username to unlock"

foreach($user in $UsertoUnlock){
    if($lockedaccount -eq $usertounlock){
        Unlock-ADAccount -identity $Usertounlock
        Write-Host "User account has been unlocked"
    }
    else{
    Write-Host "User account not found"
    }
}
