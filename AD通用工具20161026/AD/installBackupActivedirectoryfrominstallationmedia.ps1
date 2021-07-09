param($a,$b,$c,$d,$e,$f)
#
# 用于 额外AD预控 部署的 Windows PowerShell 脚本 

install-windowsfeature -configurationfilepath .\ad\1.xml 
# 下面的$password 是设置的还原模式密码
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
$password2 = ConvertTo-SecureString "$e" -AsPlainText -Force
$fuck=New-Object System.Management.Automation.PSCredential($d,$password2)
Import-Module ADDSDeployment
Install-ADDSDomainController `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$false `
-Credential  $fuck `
-CriticalReplicationOnly:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainName "$b.$c" `
-InstallationMediaPath "$f" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $password ` 

