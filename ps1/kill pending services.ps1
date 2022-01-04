$Services = Get-WmiObject -Class win32_service -Filter "state = 'stop pending'"
if ($Services) {
foreach ($service in $Services) {
try {
Stop-Process -Id $service.processid -Force -PassThru -ErrorAction Stop
}
catch {
Write-Warning -Message "Error. Error details: $_.Exception.Message"
}
}
}
else {
Write-Output "No services with 'Stopping'.status"
}