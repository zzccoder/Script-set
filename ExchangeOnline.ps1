
#
Set-User -Identity zhichao.zhou@addaxpetroluem.com -RemotePowerShellEnabled $false
Set-User -Identity david@contoso.com -RemotePowerShellEnabled $true
Get-User -Identity <UserIdentity> | Format-List RemotePowerShellEnabled
#Run as administrator  connect to ExchangeOline  use 80 port

Set-ExecutionPolicy RemoteSigned
#Enable
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://partner.outlook.cn/PowerShell -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking
#disable




$dateEnd = get-date 
$dateStart = $dateEnd.AddHours(-8) #目前时间之前的8个小时之内
$recipient="admin@constos.com"  #导出收件人是admin@constos.com的用户
 
#自定义时间，转换时区
 
Get-MessageTrace -StartDate $dateStart -EndDate $dateEnd -RecipientAddress $recipient | Select-Object @{name='time';e={[System.TimeZone]::CurrentTimeZone.ToLocalTime($_.received)}}, SenderAddress, RecipientAddress, Subject, Status, ToIP, FromIP, Size, MessageID, MessageTraceID |export-csv  -encoding utf8 d:\Only.csv