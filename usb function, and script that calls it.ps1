#usb
#enable usb
function Enable-USBPort {
    param (
        [string]$port
    )

    Write-Host "Enabling USB port $port"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR\$port" -Name "Start" -Value 3
}

#Disable usb
function Disable-USBPort {
    param (
        [string]$port
    )

    Write-Host "Disabling USB port $port"
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR\$port" -Name "Start" -Value 4
}

#List of usb ports, retrieve function Enable-USBPort and Disable-USBPort
$usbPorts = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR\*" | ForEach-Object { $_.PSChildName }
#Displays usb ports to user
Write-Host "List of USB Ports:"
$usbPorts | Foreach-object {write-host "$_ - $($_.ToString())"}
$inputPort = Read-Host "Enter the USB port you want to enable"

#if it's a valid entry
if($usbPorts -contains $inputPort){
    $input = Read-Host "Enter 'enable' to enable the usb prot or 'disable' to disable the port"
    
    if($input -eq "enable"){
        Enable-USBPort -port $inputPort
    }
    elseif($input -eq "disable"){
        Disable-USBPort -port $inputPort
    }
    else{
        Write-Host "Invalide inpupt, enter 'enable' or 'disable'"
    }
}
else{
    Write-Host "Invalid USB port, enter a valid port"
}
