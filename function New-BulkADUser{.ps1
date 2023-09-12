function New-BulkADUser{
    param(
        [string]$CSVFilePath
    )
    Import-Module ActiveDirectory 

    $userlist = Import-Csv $CSVFilePath #<Filepath>

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

function New-UserInput {
    param(
        [string]$FirstName, 
        [string]$LastName, 
        [string]$Username, 
        [SecureString]$Password, 
        [string]$Department, 
        [string]$OU 
    )
    if (-not $FirstName) {
        $FirstName = Read-Host "Enter the first name"
    }
    if (-not $LastName) {
        $LastName = Read-Host "Enter the last name"
    }
    if (-not $Username) {
        $Username = Read-Host "Enter the username"
    }
    if (-not $Password) {
        $Password = Read-Host "Enter the password" -AsSecureString
    }
    if (-not $Department) {
        $Department = Read-Host "Enter the department"
    }
    if (-not $OU) {
        $OU = Read-Host "Enter the OU (Organizational Unit)"
    }
    $commonName = $firstname + ' ' + $LastName
    New-ADUser -Name $commonName -UserPrincipalName $firtname + "@contoso.com" -GivenName $firstname -Surname $LastName `
    -Department $Department -Path $OU -AccountPassword (Converto-SecureString $password -AsPlainText -Force) -Enabled $true
}

function Set-ADEnvironment{
    Param(
        [string]$OU,
        [string]$Group,
        [string]$UserToAdd
    )
    #create OU
    $ouPath = "OU=$OU,DC=Adatum,DC=com"
    if(-not(Get-ADOrganizationalUnit -Filter {Name -eq $OU})){
        New-ADOrganizaitonalUnit -Name $OU -Path "DC=Adatum,DC=com"
        Write-Host"$ou created"
    }
    #creates group
    $groupPath = "CN=$group,OU=$OU,DC=Adatum,DC=Com"
    if(-not (Get-ADGroup -Filter{Name -eq $Group})){
        New-ADGroup -Name $Group -GroupScope Global -GroupCategory Security -Path $ouPath
        Write-Host "$Group created"
    }    
    $user = Get-ADUser -Filter{SamAccountName -eq $UserToAdd}
    if($user = $UserToAdd){
        Add-GroupMember -Identity $groupPath -Member $user
        Write-Host "Added $($user.SamAccountName) to Group: $GroupName"
    } else{
        Write-Host "User not found"
    }
}
#$OUName = Read-Host "Enter OU Name"
#$GroupName = Read-Host "Enter Group Name"
#$UserToAdd = Read-Host "Enter User to Add"
