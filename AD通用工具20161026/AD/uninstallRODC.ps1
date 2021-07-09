param($a,$b,$c,$d,$e)
#
# 用于 AD DS 部署的 Windows PowerShell 脚本
#
#如果无法 联系到任何域请加一条命ForceRemoval:$true
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
$password2 = ConvertTo-SecureString "$e" -AsPlainText -Force
$fuck=New-Object System.Management.Automation.PSCredential($d,$password2)
Import-Module ADDSDeployment
Uninstall-ADDSDomainController `
-LocalAdministratorPassword $password `
-Credential  $fuck `
-DemoteOperationMasterRole:$true `
-Force:$true `
