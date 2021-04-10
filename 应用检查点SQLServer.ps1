Grant-VMConnectAccess -UserName Everyone -VMName * 
Get-VM -Name * | Foreach-Object { $_| Get-VMSnapshot -Name SQLServer | Restore-VMSnapshot -Confirm:$false } 