Grant-VMConnectAccess -UserName Everyone -VMName * 
Get-VM -Name * | Foreach-Object { $_| Get-VMSnapshot -Name PrivateCloud | Restore-VMSnapshot -Confirm:$false } 
