

$ip="192.168.1.15"
$mask="255.255.255.0"
$gateway="192.168.1.1"
$dns="8.8.8.8"
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic($ip,$mask )
$wmi.SetGateways($gateway, 1)
$wmi.SetDNSServerSearchOrder($dns)
