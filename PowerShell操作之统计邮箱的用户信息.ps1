





Add-PSSnapin microsoft.exchange*
$user=Get-User -ResultSize unlimited -RecipientTypeDetails UserMailbox
$userinfo=@()
foreach($i in $user)
{
$mbxstatistics=Get-Mailbox $i.identity|Get-MailboxStatistics
$mbxsarctatistics=if((Get-Mailbox $i.identity).ArchiveDatabase -ne $null) `
{get-mailbox $i.identity -Archive|Get-MailboxStatistics -Archive}
#获取所有启用了存档邮箱的用户信息，如前面不加if判断，会出现运行时提示找不到存档邮箱的报错。
$mbxtotal=Get-Mailbox $i.identity|Select-Object @{n="显示名";e={$_.displayname}},`
@{n="登录名";e={$_.samaccountname}}, `
@{n="邮箱地址";e={$_.PrimarySmtpAddress}}, `
@{n="公司名";e={$i.company}}, `
@{n="部门";e={$i.Department}}, `
@{n="邮箱数量";e={$mbxstatistics.ItemCount}},`
@{n="邮箱大小(MB)";e={$mbxstatistics.TotalItemSize.value.tomb()}},`
@{n="存档邮箱数量";e={$mbxsarctatistics.ItemCount}},`
@{n="存档邮箱大小(MB)";e={$mbxsarctatistics.TotalItemSize.value.tomb()}},`
@{n="挂载的服务器名";e={$mbxstatistics.ServerName}},`
@{n="最后一次登录时间";e={$mbxstatistics.LastLogonTime}},`
@{n="数据库名";e={$mbxstatistics.DatabaseName}}
$userinfo+=$mbxtotal #把每次运行获取到的用户信息存入到userinfo
}
$userinfo #把查询到的信息在屏幕显示出来
$userinfo|Export-Csv -Path c:\mbxinfo.csv -NoTypeInformation -Encoding utf8 #把用户信息导出到c:\mbxinfo.csv