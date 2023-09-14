import-module-activedirectory
$presentTime = Get-Date
$last24Hours = $presentTime.AddHours(-24)
$180days = (Get-Date).AddDays(-180)

$expiredUsers = Get-ADUser -Filter{AccountExpirationDate -le $presentTime -and AccountExpirationDate -ge $last24Hours} -Properties AccountExpirationDate | select name, accountexpirationdate 

New-ADGroup -Name "InactiveGroup" -GroupScope Global -GroupCategory security -DisplayName "Inactive Users" -Path "CN=Users,DC=Adatum,DC=com" -Description "Inactive for more than 180 Days"
$inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $180days} -properties LastLogonDate

foreach($user in $inactiveUsers){
    Add-ADGroupMember -Identity InactiveUsers -Members $user
    write-host "Moved User $user to Inactive Group"
}

$240days = (Get-Date).AddDays(-210)
Foreach($item in $inactiveusers){
    if($item.LastLogonDate -lt (Get-Date).AddDays(-210)){
        Disable-ADAccount -Identity $item
    }
}

#removing users from security groups except domain users
$security = Get-ADGroup -Filter {GroupCategory -eq "Security"}
$disabled = Get-ADuser -Filter {Enabled -eq $false}
foreach($user in $disabled){
    $userGroup = Get-ADPrincipalGroupMembership -Identity $user.SamAccountName | Where-Object {$_.GroupCategory -eq "security"}

    foreach($account in $userGroup){
        if($account.Name -ne "Domain Users"){
            Remove-ADGroupMember -Identity $account -Members $user
            Write-Host "removed $user from group"
        }
    }
}

