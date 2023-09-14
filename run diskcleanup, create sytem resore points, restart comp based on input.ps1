 #run diskcleanup, create system restore point, restarts computer based on user input

$RemoteComp = Read-Host "Enter name of remote computer"
enable-psremoting
$Session = New-PSSession -ComputerName $RemoteComp

$RemoteCommand ={
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "\sageset:1" -Wait

    CheckPoint-Computer -Description "Before Restart" -RestorePointType "MODIFY_Settings"

    $RestartChoice = Read-Host "Do you want to restart the computer? (Y/N)"
    if($RestartChoice -eq "y" -or $RestartChoice -eq "y"){
      Restart-Computer -Force
    }
    else{
        Write-Host "Your computer will not restart"
    }
}
Invoke-Command -Session $Session -ScriptBlock $RemoteCommand

$Action = Read-Host "Do you want to Stop or Restart services? S or R"
if($Action -eq "S"  -or $Action -eq "s" ){
    $Servicestop = Read-Host "Enter the name of the service to stop"
    Invoke-Command -Session $Session -ScriptBlock {Stop-Service -Name $Using:Servicestop -Force}
    Write-Host "$Servicestop has stopped"
}
elseif($Action -eq "R" -or $Action -eq "r"){
    $Servicerestart = Read-Host "Enter the name of the service to restart"
    Invoke-Command -Session $Session -ScriptBlock {Start-Service -Name $Using:Servicerestart}
    Write-Host "$Servicerestart has started"
}
else{
    Write-Host "no action taken."
}

$Action2 = Read-Host "Do you want to Stop or Restart processes? S or R"
if($Action2 -eq "S" -or $Action -eq "s"){
    $ProcessStop = Read-Host "Enter the name of the process to stop"
    Invoke-Command -Session $Session -ScriptBlock{Stop-Process -Name $Using:Processstop -Force}
    Write-Host "$Processstop has stopped"
}
elseif($Action2 -eq "R" -or $Action2 -eq "r"){
    $ProcessStart = Read-Host "Enter the name of the process to start"
    Invoke-Command -Session $Session -ScriptBlock {Start-Process -Name $Using:ProcessStart} 
    Write-Host "$ProcessStart has started"
}
else{
    Write-Host "No action taken"
}

Remove-PSSession -Session $Session

