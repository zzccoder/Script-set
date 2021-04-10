Grant-VMConnectAccess -UserName Everyone -VMName * 
Get-VM -Name * | Foreach-Object { $_| Get-VMSnapshot -Name Domain | Restore-VMSnapshot -Confirm:$false } 
