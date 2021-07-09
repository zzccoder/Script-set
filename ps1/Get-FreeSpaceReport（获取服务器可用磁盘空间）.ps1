<#
 * File: Get-FreeSpaceReport.ps1
 * Version: 1.0.20140428
 * Author: tangtianhao<tangtianhao@msn.com>
 * Requires: Powershell -Version 2
 * Brief: This Script Was Used to Get Server FreeSpace Report from txt File or OU
#>

<#
.SYNOPSIS
�ýű��������ɷ��������̿��ÿռ䱨�档֧�ִ��ı��ļ���AD OU�н��м�������������֧�����ʼ���ʽ���͸ñ��档

.DESCRIPTION
�ýű��������ɷ��������̿��ÿռ䱨�棬֧�ִ��ı��ļ���AD OU�н��м�������������֧�����ʼ���ʽ���͸ñ��档

.NOTES
 * File: Get-FreeSpaceReport.ps1
 * Version: 1.0.20140428
 * Author: tangtianhao<tangtianhao@msn.com>
 * Requires: Powershell -Version 2
 * Brief: This Script Was Used to Get Server FreeSpace Report from txt File or OU
 
 .LINK
 http://www.microsoft.com

.PARAMETER OutFile
���屨������ļ�·����Ĭ�ϻᱣ���ڽű��ļ���ǰ·��FreeSpaceReport.html��

.PARAMETER ServerList
ָ�������������б���ı��ļ�·����ÿ��������һ�С�Ĭ�ϻ�ӽű��ļ���ǰ·��ServerList.txt�н��в��ҡ�

.PARAMETER ServerFromOU
�����Ƿ��OU�����������б�Ĭ�ϲ���OU��ȡ�����Ǵ�ServerList�ı��ļ���ȡ��

.PARAMETER OU
������Ҫ����������б��OU����ȷ��OU��Ψһ������������OU��LDAP����DN����

.PARAMETER SendMail
�����Ƿ���Ҫ�����ʼ���Ĭ�ϲ����͡�

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1
��ȡ���������̿��ÿռ䱨�档�����κβ������ӽű��ļ���ǰ·��ServerList.txt�н��з��������ң����ڽű��ļ���ǰ·���д��������ļ�FreeSpaceReport.html���Ҳ��Ὣ���淢���ʼ���

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1 -OutFile C:\Report.html -ServerList C:\ServerList.txt -SendMail:$True
��ȡ���������̿��ÿռ䱨�档�Զ��屨���ļ��Լ��������ļ�·���������ʼ���

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1 -OutFile C:\Report.html -ServerFromOU:$True -SendMail:$True
��ȡ���������̿��ÿռ䱨�档�Զ��屨���ļ�·���Լ����ô�OU�����������������ʼ���
#>


Param (
[String]$OutFile = "FreeSpaceReport.html", #���屨������ļ�
[String]$ServerList = "ServerList.txt", #����������б��ļ�
[Switch]$ServerFromOU = $false, #�����Ƿ��OU�����������б�Ĭ�ϲ���OU��ȡ�����Ǵ�ServerList�ı��ļ���ȡ
[String]$OU = "OU=��������,OU=�����,dc=contoso,dc=com", #������Ҫ����������б��OU
[Switch]$SendMail = $False #�����Ƿ���Ҫ�����ʼ���Ĭ�ϲ�����
)


$Title = "���������̿ռ�ʹ�ñ���"
$Font = "΢���ź�"

#���ÿռ�ٷֱȣ�
#���ڵ���$Warningʱ˵�����̿ռ����,���账������ɫ��ʾ��
#С�ڵ���$Criticalʱ˵�����ز���,���账���Ժ�ɫ��ʾ��
#����$CriticalС��$Warning˵�����̿ռ��пɣ���Ҫ��ע���Ի�ɫ��ʾ��
$Warning = 70
$Critical = 15

New-Item -ItemType file $OutFile -Force

#region ���庯������HTMLͷ��������������Ϣ�ı��д�뵽����ļ���
Function Write-HtmlHeader
{
Param($FileName)
$Date = ( Get-Date ).ToString('yyyy/MM/dd')
Add-Content $FileName "<html>"
Add-Content $FileName "<head>"
Add-Content $FileName "<meta http-equiv='Content-Type' content='text/html; charset=GB2312'>"
Add-Content $FileName "<title>$Title</title>"
Add-Content $FileName '<STYLE TYPE="text/css">'
Add-Content $FileName  "<!--"
Add-Content $FileName  "td {"
Add-Content $FileName  "font-family: $Font;"
Add-Content $FileName  "font-size: 11px;"
Add-Content $FileName  "border-top: 1px solid #999999;"
Add-Content $FileName  "border-right: 1px solid #999999;"
Add-Content $FileName  "border-bottom: 1px solid #999999;"
Add-Content $FileName  "border-left: 1px solid #999999;"
Add-Content $FileName  "padding-top: 0px;"
Add-Content $FileName  "padding-right: 0px;"
Add-Content $FileName  "padding-bottom: 0px;"
Add-Content $FileName  "padding-left: 0px;"
Add-Content $FileName  "}"
Add-Content $FileName  "body {"
Add-Content $FileName  "margin-left: 5px;"
Add-Content $FileName  "margin-top: 5px;"
Add-Content $FileName  "margin-right: 5px;"
Add-Content $FileName  "margin-bottom: 10px;"
Add-Content $FileName  ""
Add-Content $FileName  "table {"
Add-Content $FileName  "border: thin solid #000000;"
Add-Content $FileName  "}"
Add-Content $FileName  "-->"
Add-Content $FileName  "</style>"
Add-Content $FileName "</head>"
Add-Content $FileName "<body>"

Add-Content $FileName  "<table width='100%'>"
Add-Content $FileName  "<tr bgcolor='LightSlateGray'>"
Add-Content $FileName  "<td colspan='7' height='25' align='center'>"
Add-Content $FileName  "<font face='$Font' color='#003399' size='4'><strong>$Title - $date</strong></font>"
Add-Content $FileName  "</td>"
Add-Content $FileName  "</tr>"
Add-Content $FileName  "</table>"
}
#endregion

#region ���庯������HTMLͷ���������������Ϣ�ı��д�뵽����ļ���
Function Write-TableHeader
{
Param($FileName)

Add-Content $FileName "<tr bgcolor=#CCCCCC>"
Add-Content $FileName "<td width='10%' align='center'>�������̷�</td>"
Add-Content $FileName "<td width='20%' align='center'>���������</td>"
Add-Content $FileName "<td width='20%' align='center'>�ܴ�С(GB)</td>"
Add-Content $FileName "<td width='20%' align='center'>���ÿռ�(GB)</td>"
Add-Content $FileName "<td width='20%' align='center'>���ÿռ�(GB)</td>"
Add-Content $FileName "<td width='10%' align='center'>���ÿռ� %</td>"
Add-Content $FileName "</tr>"
}
#endregion

#region ���庯������HTMLβд�뵽����ļ�������������HTML�ļ���
Function Write-HtmlFooter
{
Param($FileName)
Add-Content $FileName "</body>"
Add-Content $FileName "</html>"
}
#endregion

#region ���庯������������Ϣд�뵽����ļ���
Function Write-DiskInfo
{
Param($FileName,$devId,$volName,$frSpace,$totSpace)
$totSpace=[math]::Round(($totSpace/1073741824),2)
$frSpace=[Math]::Round(($frSpace/1073741824),2)
$usedSpace = $totSpace - $frspace
$usedSpace=[Math]::Round($usedSpace,2)
$freePercent = ($frspace/$totSpace)*100
$freePercent = [Math]::Round($freePercent,0)
 if ($freePercent -ge $warning)
 {
 Add-Content $FileName "<tr>"
 Add-Content $FileName "<td align='center'>$devid</td>"
 Add-Content $FileName "<td align='center'>$volName</td>"

 Add-Content $FileName "<td align='center'>$totSpace</td>"
 Add-Content $FileName "<td align='center'>$usedSpace</td>"
 Add-Content $FileName "<td align='center'>$frSpace</td>"
 Add-Content $FileName "<td bgcolor='green' align='center'>$freePercent</td>"
 Add-Content $FileName "</tr>"
 }
 elseif ($freePercent -le $critical)
 {
 Add-Content $FileName "<tr>"
 Add-Content $FileName "<td align='center'>$devid</td>"
 Add-Content $FileName "<td align='center'>$volName</td>"
 Add-Content $FileName "<td align='center'>$totSpace</td>"
 Add-Content $FileName "<td align='center'>$usedSpace</td>"
 Add-Content $FileName "<td align='center'>$frSpace</td>"
 Add-Content $FileName "<td bgcolor='red' align='center'>$freePercent</td>"
 Add-Content $FileName "</tr>"
 }
 else
 {
 Add-Content $FileName "<tr>"
 Add-Content $FileName "<td align='center'>$devid</td>"
 Add-Content $FileName "<td align='center'>$volName</td>"
 Add-Content $FileName "<td align='center'>$totSpace</td>"
 Add-Content $FileName "<td align='center'>$usedSpace</td>"
 Add-Content $FileName "<td align='center'>$frSpace</td>"
 Add-Content $FileName "<td bgcolor='yellow' align='center'>$freePercent</td>"
 Add-Content $FileName "</tr>"
 }
}
#endregion


Write-HtmlHeader $OutFile
if ($ServerFromOU)
{
Import-Module ActiveDirectory
(Get-ADComputer -SearchBase $OU -filter {enabled -eq $True}).Name >> $Env:temp\ServerList.txt
$ServerList = "$Env:temp\ServerList.txt"
}

foreach ($Server in Get-Content $Serverlist)
{
try {
 	$dp = Get-WmiObject win32_logicaldisk -ComputerName $server |  Where-Object {$_.drivetype -eq 3}
 		if ($?)
 		{
 		Add-Content $OutFile "<table width='100%'><tbody>"
 		Add-Content $OutFile "<tr bgcolor='LightSteelBlue'>"
 		Add-Content $OutFile "<td width='100%' align='center' colSpan=6><font face='$font' color='#003399' size='2'><strong> $server </strong></font></td>"
 		Add-Content $OutFile "</tr>"
		}
 		else
 		{
 		Add-Content $OutFile "<table width='100%'><tbody>"
 		Add-Content $OutFile "<tr bgcolor='LightSteelBlue'>"
 		Add-Content $OutFile "<td width='100%' align='center' colSpan=6><font face='$font' color='Red' size='2'><strong> <s>$server</s> ���������ߣ�������������ǽ</strong></font></td>"
 		Add-Content $OutFile "</tr>"
 		}
}
catch {}

 Write-TableHeader $OutFile

 foreach ($item in $dp)
 {
 	if ($item.VolumeName) 
 	{
 		Write-Host  $item.DeviceID  $item.VolumeName $item.FreeSpace $item.Size
 		Write-DiskInfo $OutFile $item.DeviceID $item.VolumeName $item.FreeSpace $item.Size
	}
	else 
	{
	Write-Host  $item.DeviceID  ���ش��� $item.FreeSpace $item.Size
 	Write-DiskInfo $OutFile $item.DeviceID ���ش��� $item.FreeSpace $item.Size
	}
 }
}
Write-HtmlFooter $OutFile

if ($SendMail)
{
$SmtpServer = "smtp.contoso.com" #�����ʼ����ͷ�����
$SmtpUser = "8000@contoso.com" #���巢�����˺�
$SmtpPwdPlain = "password" #���巢��������
$SmtpRecipients = "gongyuanping@contoso.com","sunhailiang@contoso.com" #�����ռ���
$SmtpCCRecipients =  "tangtianhao@contoso.com"  #����ͬʱ���͵��ռ��ˡ��������ҪCC��������$Null
$SmtpPwdSec = convertto-securestring "$SmtpPwdPlain" -asplaintext -force
$SmtpCred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$SmtpUser",$SmtpPwdSec
$Body = "<font face='$Font' color='Blue' size='2'><strong>��鿴�����ķ��������̿ռ�ʹ�ñ���һ���к�ɫ���棬����ص�¼���������д���</strong></font></p>
</br><font face='$Font' color='Gray' size='2'<I>ע�⣺�����ÿռ�İٷֱȣ�</br>
# ���ڵ���$Warning`ʱ˵�����̿ռ����,���账������ɫ��ʾ��</br>
# С�ڵ���$Critical`ʱ˵�����ز���,���账���Ժ�ɫ��ʾ��</br>
# ����$Critical`С��$Warning`˵�����̿ռ��пɣ���Ҫ��ע���Ի�ɫ��ʾ��</I></br></font>" #�����ʼ�����
Send-MailMessage  -from $SmtpUser -to  $SmtpRecipients -cc $SmtpCCRecipients -Subject "$Title" -body $Body -bodyashtml -SmtpServer $SmtpServer -Priority high -Encoding ([system.text.encoding]::utf8) -Credential $SmtpCred -Attachments $OutFile
}
