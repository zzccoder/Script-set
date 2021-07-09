param($a,$b,$c,$d,$e,$f,$g)
#
# 用于 AD DS 部署的 Windows PowerShell 脚本
#
install-windowsfeature -configurationfilepath .\ad\1.xml 
# 下面的$password 是设置的还原模式密码
#***更改下面的abc123,为你需要的密码***
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
$password2 = ConvertTo-SecureString "$e" -AsPlainText -Force
$fuck=New-Object System.Management.Automation.PSCredential($d,$password2)
Import-Module ADDSDeployment
Install-ADDSDomainController `
-AllowPasswordReplicationAccountName @("$b\Allowed RODC Password Replication Group") `
-NoGlobalCatalog:$false `
-Credential $fuck `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-DelegatedAdministratorAccountName "$b\$f" `
-DenyPasswordReplicationAccountName @("BUILTIN\Administrators", "BUILTIN\Server Operators", "BUILTIN\Backup Operators", "BUILTIN\Account Operators", "$b\Denied RODC Password Replication Group") `
-DomainName "$b.$c" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-ReadOnlyReplica:$true `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $password `
-Force:$true


