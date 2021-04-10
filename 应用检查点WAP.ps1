Grant-VMConnectAccess -UserName Everyone -VMName * 
Get-VM -Name * | Foreach-Object { $_| Get-VMSnapshot -Name WAP | Restore-VMSnapshot -Confirm:$false } 
