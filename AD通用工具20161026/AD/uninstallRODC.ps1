param($a,$b,$c,$d,$e)
#
# ���� AD DS ����� Windows PowerShell �ű�
#
#����޷� ��ϵ���κ������һ����ForceRemoval:$true
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
$password2 = ConvertTo-SecureString "$e" -AsPlainText -Force
$fuck=New-Object System.Management.Automation.PSCredential($d,$password2)
Import-Module ADDSDeployment
Uninstall-ADDSDomainController `
-LocalAdministratorPassword $password `
-Credential  $fuck `
-DemoteOperationMasterRole:$true `
-Force:$true `
