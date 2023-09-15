function New-BulkADUser{
    param(
        [string]$CSVFilePath
    )
    Import-Module ActiveDirectory 

    $userlist = Import-Csv $CSVFilePath #Filepath

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

#create ou, group, add user to group
function Set-ADpath{
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

#Fucntion to delete temp files
function Remove-TempFiles{
    param(
        [string[]]$userProfiles,
        [switch]$Force,
        [switch]$Verbose
    )
    
    foreach($user in $userProfiles){
        $tempFolder = Join-Path -Path "C:\Users" -ChildPath $user
         
        if(Test-Path -Path $tempFolder -PathType Container){
            $tempFolderPath = Join-Path -Path $tempFolder -ChildPath "AppData\Local\Temp"
            if(test-path -Path $tempFolderpath -PathType Container){
                if($Verbose){
                    Write-Host "Removing temporary files for user $user"
                }
         
            Remove-Item -Path $tempFolderPath -Recurse -Force -ErrorAction SilentlyContinue
            if($Verbose){
                Write-Host "temporary files removed for user $user"
            }
        }
    }
        else{
            if($Verbose){
                Write-Host "No temporary files found for user $user"
            }
        }      
    
    else{
        if($Verbose){
            Write-Host "User profile not found for $User"
            }
        }
    }
}
#$UserTempfiles = @("User1","User2")
#Remove-TempFiles -UserProfiles $UserTempfiles -Force -Verbose
#Force to remove without confirmatoin, verbose to see progress

#Clear eventlog function
function Clear-Eventlogs{
    param(
        [string[]]$Logs,
        [switch]$force
    )
    foreach($Log in $Logs){
        if(Get-Eventlog -List | Where-Object {$_.Log -eq $Logs}){
        Clear-Eventlog -LogName $log -Force
    }
}
}
#$Eventlogstoclear = @{"application",""}
#Clear-Eventlogs -Logs $Eventlogstoclear -Force

function Get-SystemHealthCheck{
    $healthReport = @()

    $diskSpace = Get-WmiObject -Class Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, FreeSpace, Size
    $diskSpace | Foreach-Object{
        $drive = $_.DeviceID
        $freeSpaceGB = [math]::Round($_.Freespace/1GB,2)
        $totalSpaceGB = [math]::Round($_.Size/1GB,2)
        $healthReport += "Drive $drive Free Space: $freespaceGB GB / Total Space: $totalSpaceGB GB"
    }
    $memory = Get-WmiObject -Class Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
    $totalMemoryGB = [math]::Round($memory.TotalVisibleMemorySize/1MB , 2)
    $freeMemoryGB = [math]::Round($memory.FreePhysicalMemory/1MB, 2)
    $healthReport += "Total Memory: $totalMemoryGB GB / Free Memory: $freeMemoryGB GB"

    return $healthReport
}
# $healthReport = Get-SystemHealth
#Write-Host "System Health Report:"
#$healthReport | ForEach-Object { Write-Host $_ }