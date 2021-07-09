param($a,$b,$c,$d,$e,$f)
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
Install-ADDSDomain `
-NoGlobalCatalog:$false `
-CreateDnsDelegation:$false `
-Credential  $fuck `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012R2" `
-DomainType "TreeDomain" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NewDomainName "$f.$c" `
-NewDomainNetbiosName "$f" `
-ParentDomainName "$b.$c" `
-NoRebootOnCompletion:$false `
-SiteName "Default-First-Site-Name" `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $password ` 