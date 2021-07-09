param($a)
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
Import-Module ADDSDeployment
Uninstall-ADDSDomainController `
-DemoteOperationMasterRole:$true `
-ForceRemoval:$true `
-Force:$true
