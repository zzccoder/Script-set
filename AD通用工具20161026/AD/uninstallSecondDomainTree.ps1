param($a,$b,$c,$d,$e)
#
# ���� ����ADԤ�� ����� Windows PowerShell �ű� 
# �����$password �����õĻ�ԭģʽ����
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