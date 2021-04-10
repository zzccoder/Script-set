
$ResourceGroupName = "PRD-APPL-ARCGIS-ASIA-RG01"
$VMName = "P-Splunk-INF-EVM01"
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName 

Set-AzVMExtension -Name 'DomainJoin' -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Location $vm.Location -Publisher 'Microsoft.Compute' -ExtensionType 'JsonADDomainExtension' -TypeHandlerVersion 1.3
Set-AzVMBgInfoExtension -ResourceGroupName $vm.ResourceGroupName -VMName $vm.Name -Name "BIGInfo" -TypeHandlerVersion "2.1" -Location $vm.Location
Set-AzVMExtension -ExtensionName "Microsoft.Azure.Monitoring.DependencyAgent" -ResourceGroupName $vm.ResourceGroupName `
-VMName $vm.Name `
-Publisher "Microsoft.Azure.Monitoring.DependencyAgent" `
-ExtensionType "DependencyAgentWindows" `
-TypeHandlerVersion 9.5 `
-Location $vm.Location
Set-AzVMExtension -ResourceGroupName $vm.ResourceGroupName -Location $vm.Location `
-VMName $VMName `
-Name "networkWatcherAgent" `
-Publisher "Microsoft.Azure.NetworkWatcher" `
-Type "NetworkWatcherAgentWindows" `
-TypeHandlerVersion "1.4"

# $PublicSettings = @{"workspaceId" = "myWorkspaceId"}
# $ProtectedSettings = @{"workspaceKey" = "myWorkspaceKey"}

# Set-AzVMExtension -ExtensionName "MicrosoftMonitoringAgent" -ResourceGroupName $vm.ResourceGroupName -Location $vm.Location -vmname $vmname -Publisher "Microsoft.EnterpriseCloud.Monitoring" -ExtensionType "MicrosoftMonitoringAgent" -TypeHandlerVersion 1.0 -Settings $PublicSettings -ProtectedSettings $ProtectedSettings


