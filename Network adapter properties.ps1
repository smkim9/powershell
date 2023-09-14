#Network adapter properties
$computers = "MSI"

foreach($computer in $computers){
    try{
        $adapterconfig=Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Computername $computer
        
            
            Write-Host "Network Adapter Properties for $computer"
            Write-Host "----------------------------------"
            Write-Host "IP Address: $($adapterConfig.Ipaddress)"
            Write-Host "Subnet Mask: $($adapterConfig.IPSubnet)"
            Write-Host "Default Gateway: $($adapterConfig.DefaultIPGateway)"
            Write-Host "DNS Servers: $($adapterConfig.DNSServerSearchOrder)"
            Write-Host "MAC Address: $($adapterConfig.MACAddress)"
            Write-Host "----------------------------------"

            $output = [PSCustomObject]@{
                ComputerName    = $computer
                IPAddress       = $adapterConfig.Ipaddress
                SubnetMask      = $adapterConfig.IPSubnet
                DefaultGateway  = $adapterConfig.DefaultIPGateway
                DNSServers      = $adapterConfig.DNSServerSearchOrder
                MACAddress      = $adapterConfig.MACAddress
            }
            $output += $ouput
    }   
    catch {
        Write-Host "Error retrieving network adapter properties for $computer"
    }
   
}
$output | Export-CSV -Path "C:\networkconfig.csv"