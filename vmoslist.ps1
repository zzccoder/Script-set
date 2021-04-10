$VMs = Get-AzureRmVM 
$vmlist = @() 
$VMs | ForEach-Object {  
    $VMObj = New-Object -TypeName PSObject 
    $VMObj | Add-Member -MemberType Noteproperty -Name "VM Name" -Value $_.Name 
    $VMObj | Add-Member -MemberType Noteproperty -Name "OS type" -Value $_.StorageProfile.ImageReference.Sku 
    $vmlist += $VMObj 
} 
$vmlist 