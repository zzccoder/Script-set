param($a,$b,$c,$d,$e,$f)
#
# ���� ����ADԤ�� ����� Windows PowerShell �ű� 

install-windowsfeature -configurationfilepath .\ad\1.xml 
# �����$password �����õĻ�ԭģʽ����
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

