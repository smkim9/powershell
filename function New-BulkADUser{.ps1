function New-BulkADUser{
    param(
        [string]$CSVFilePath
    )
    Import-Module ActiveDirectory 

    $userlist = Import-Csv $CSVFilePath <Filepath>

    foreach($user in $userlist){
        $FirstName = $user.FirstName
        $LastName = $user.Lastname
        $Username = $user.username
        $emailaddress = $user.emailaddress
        $ou = $user.ou
        $department = $user.department
        $password = $user.password

        New-ADUser -Name "$Firstname $Lastname" -GivenName $FirstName -Surname $Lastname `
        -UserPrincipalName $Username + "@contoso.com"-AccountPassword (Converto-SecureString $password -AsPlainText -Force) `
        -EmailAddress $emailaddress -ChangePasswordAtLogon $true -Enabled $true

        Write-Host "User $FirstName $lastName created"
    }
    catch{
        write-host "An error occurred: $($Error.Exception.Message)"
    }
}