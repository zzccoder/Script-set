$ASName = "TestAS"
$Location = "WestUS2"
$ResourceGroupName = "RG-SCUSA"

Write-Host "Trying to create with three fault domains"
New-AzureRmAvailabilitySet -Location $Location -Name $ASName -ResourceGroupName $ResourceGroupName -PlatformFaultDomainCount 3 `
-PlatformUpdateDomainCount 5 -Sku Aligned -EA SilentlyContinue
if ($error.Count -gt 0)
{
Write-Host "Failed to create with three, creating with two fault domains"
New-AzureRmAvailabilitySet -Location $Location -Name $ASName -ResourceGroupName $ResourceGroupName `
-PlatformFaultDomainCount 2 -PlatformUpdateDomainCount 5 -Sku Aligned
}

Remove-AzureRmAvailabilitySet -Name $ASName -ResourceGroupName $ResourceGroupName -Force