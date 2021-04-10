





Add-PSSnapin microsoft.exchange*
$user=Get-User -ResultSize unlimited -RecipientTypeDetails UserMailbox
$userinfo=@()
foreach($i in $user)
{
$mbxstatistics=Get-Mailbox $i.identity|Get-MailboxStatistics
$mbxsarctatistics=if((Get-Mailbox $i.identity).ArchiveDatabase -ne $null) `
{get-mailbox $i.identity -Archive|Get-MailboxStatistics -Archive}
#��ȡ���������˴浵������û���Ϣ����ǰ�治��if�жϣ����������ʱ��ʾ�Ҳ����浵����ı���
$mbxtotal=Get-Mailbox $i.identity|Select-Object @{n="��ʾ��";e={$_.displayname}},`
@{n="��¼��";e={$_.samaccountname}}, `
@{n="�����ַ";e={$_.PrimarySmtpAddress}}, `
@{n="��˾��";e={$i.company}}, `
@{n="����";e={$i.Department}}, `
@{n="��������";e={$mbxstatistics.ItemCount}},`
@{n="�����С(MB)";e={$mbxstatistics.TotalItemSize.value.tomb()}},`
@{n="�浵��������";e={$mbxsarctatistics.ItemCount}},`
@{n="�浵�����С(MB)";e={$mbxsarctatistics.TotalItemSize.value.tomb()}},`
@{n="���صķ�������";e={$mbxstatistics.ServerName}},`
@{n="���һ�ε�¼ʱ��";e={$mbxstatistics.LastLogonTime}},`
@{n="���ݿ���";e={$mbxstatistics.DatabaseName}}
$userinfo+=$mbxtotal #��ÿ�����л�ȡ�����û���Ϣ���뵽userinfo
}
$userinfo #�Ѳ�ѯ������Ϣ����Ļ��ʾ����
$userinfo|Export-Csv -Path c:\mbxinfo.csv -NoTypeInformation -Encoding utf8 #���û���Ϣ������c:\mbxinfo.csv