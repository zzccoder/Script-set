param($a,$b,$c,$d,$e)
#
# 用于 额外AD预控 部署的 Windows PowerShell 脚本 
# 下面的$password 是设置的还原模式密码
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
$password2 = ConvertTo-SecureString "$e" -AsPlainText -Force
$fuck=New-Object System.Management.Automation.PSCredential($d,$password2)
Import-Module ADDSDeployment
Uninstall-ADDSDomainController `
-LocalAdministratorPassword $password `
-Credential  $fuck `
-DemoteOperationMasterRole:$true `
-DnsDelegationRemovalCredential  $fuck `
-IgnoreLastDnsServerForZone:$true `
-LastDomainControllerInDomain:$true `
-RemoveDnsDelegation:$true `
-RemoveApplicationPartitions:$true `
-IgnoreLastDCInDomainMismatch:$true `
-Force:$true 