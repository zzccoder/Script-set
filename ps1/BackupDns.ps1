#Get Name of the server with env variable
$DnsServer = $env:computername

#Define date / time variable
$DateTime = Get-Date -Format yyMMddHHmmss

#Define folder where to store backup
$BckPath =”c:\windows\system32\dns\backup\$DateTime"

#Create backup folder
$Create = New-Item -Path $BckPath -ItemType Directory -ErrorAction SilentlyContinue

if($Create) {
    
   $File = Join-Path $BckPath “Zones.csv”
   $List = Get-WmiObject -ComputerName $DnsServer -Namespace root\MicrosoftDNS -Class MicrosoftDNS_Zone
   $List | Select-Object Name,ZoneType,AllowUpdate,@{Name="MasterServers";Expression={$_.MasterServers}},DsIntegrated | Export-csv $File -NoTypeInformation 
   $List | ForEach-Object {

       $ZonePath = ”backup\$($DateTime)\$($_.Name).dns"
       &"C:\Windows\system32\dnscmd.exe" /ZoneExport $_.Name $ZonePath

   } #end of ForEach-Object
   } #end of if($Create)
else {
    
    Write-Error "Failed to create backup folder...exiting script"
    } #end of else ($Create)