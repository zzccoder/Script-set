param($a,$b,$c)
#
# 用于 AD DS 部署的 Windows PowerShell 脚本
#
install-windowsfeature -configurationfilepath .\ad\1.xml 
# 下面的$password 是设置的还原模式密码
#***更改下面的abc123,为你需要的密码***
$password = ConvertTo-SecureString "$a" -AsPlainText -Force
Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainName "$b.$c" `
-DomainNetbiosName "$b" `
-ForestMode "Win2012R2" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $password ` 
