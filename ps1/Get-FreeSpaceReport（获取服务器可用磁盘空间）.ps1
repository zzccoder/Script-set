<#
 * File: Get-FreeSpaceReport.ps1
 * Version: 1.0.20140428
 * Author: tangtianhao<tangtianhao@msn.com>
 * Requires: Powershell -Version 2
 * Brief: This Script Was Used to Get Server FreeSpace Report from txt File or OU
#>

<#
.SYNOPSIS
该脚本用来生成服务器磁盘可用空间报告。支持从文本文件和AD OU中进行检索服务器，并支持以邮件方式发送该报告。

.DESCRIPTION
该脚本用来生成服务器磁盘可用空间报告，支持从文本文件和AD OU中进行检索服务器，并支持以邮件方式发送该报告。

.NOTES
 * File: Get-FreeSpaceReport.ps1
 * Version: 1.0.20140428
 * Author: tangtianhao<tangtianhao@msn.com>
 * Requires: Powershell -Version 2
 * Brief: This Script Was Used to Get Server FreeSpace Report from txt File or OU
 
 .LINK
 http://www.microsoft.com

.PARAMETER OutFile
定义报表输出文件路径。默认会保存在脚本文件当前路径FreeSpaceReport.html。

.PARAMETER ServerList
指定包含服务器列表的文本文件路径。每个服务器一行。默认会从脚本文件当前路径ServerList.txt中进行查找。

.PARAMETER ServerFromOU
定义是否从OU检索服务器列表，默认不从OU获取，而是从ServerList文本文件获取。

.PARAMETER OU
定义需要检索计算机列表的OU。请确保OU名唯一，否则请输入OU的LDAP完整DN名。

.PARAMETER SendMail
定义是否需要发送邮件，默认不发送。

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1
获取服务器磁盘可用空间报告。不带任何参数则会从脚本文件当前路径ServerList.txt中进行服务器查找，并在脚本文件当前路径中创建报告文件FreeSpaceReport.html，且不会将报告发送邮件。

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1 -OutFile C:\Report.html -ServerList C:\ServerList.txt -SendMail:$True
获取服务器磁盘可用空间报告。自定义报告文件以及服务器文件路径并发送邮件。

.EXAMPLE
PS C:\> Get-FreeSpaceReport.ps1 -OutFile C:\Report.html -ServerFromOU:$True -SendMail:$True
获取服务器磁盘可用空间报告。自定义报告文件路径以及配置从OU检索服务器并发送邮件。
#>


Param (
[String]$OutFile = "FreeSpaceReport.html", #定义报表输出文件
[String]$ServerList = "ServerList.txt", #定义服务器列表文件
[Switch]$ServerFromOU = $false, #定义是否从OU检索服务器列表，默认不从OU获取，而是从ServerList文本文件获取
[String]$OU = "OU=服务器组,OU=计算机,dc=contoso,dc=com", #定义需要检索计算机列表的OU
[Switch]$SendMail = $False #定义是否需要发送邮件，默认不发送
)


$Title = "服务器磁盘空间使用报表"
$Font = "微软雅黑"

#可用空间百分比：
#大于等于$Warning时说明磁盘空间充足,无需处理，以绿色显示；
#小于等于$Critical时说明严重不足,急需处理，以红色显示；
#大于$Critical小于$Warning说明磁盘空间尚可，需要关注，以黄色显示。
$Warning = 70
$Critical = 15

New-Item -ItemType file $OutFile -Force

#region 定义函数，将HTML头（包含服务器信息的表格）写入到输出文件。
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

#region 定义函数，将HTML头（包含具体磁盘信息的表格）写入到输出文件。
Function Write-TableHeader
{
Param($FileName)

Add-Content $FileName "<tr bgcolor=#CCCCCC>"
Add-Content $FileName "<td width='10%' align='center'>驱动器盘符</td>"
Add-Content $FileName "<td width='20%' align='center'>驱动器卷标</td>"
Add-Content $FileName "<td width='20%' align='center'>总大小(GB)</td>"
Add-Content $FileName "<td width='20%' align='center'>已用空间(GB)</td>"
Add-Content $FileName "<td width='20%' align='center'>可用空间(GB)</td>"
Add-Content $FileName "<td width='10%' align='center'>可用空间 %</td>"
Add-Content $FileName "</tr>"
}
#endregion

#region 定义函数，将HTML尾写入到输出文件，构成完整的HTML文件。
Function Write-HtmlFooter
{
Param($FileName)
Add-Content $FileName "</body>"
Add-Content $FileName "</html>"
}
#endregion

#region 定义函数，将磁盘信息写入到输出文件。
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
 		Add-Content $OutFile "<td width='100%' align='center' colSpan=6><font face='$font' color='Red' size='2'><strong> <s>$server</s> 服务器离线，请检查网络或防火墙</strong></font></td>"
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
	Write-Host  $item.DeviceID  本地磁盘 $item.FreeSpace $item.Size
 	Write-DiskInfo $OutFile $item.DeviceID 本地磁盘 $item.FreeSpace $item.Size
	}
 }
}
Write-HtmlFooter $OutFile

if ($SendMail)
{
$SmtpServer = "smtp.contoso.com" #定义邮件发送服务器
$SmtpUser = "8000@contoso.com" #定义发件人账号
$SmtpPwdPlain = "password" #定义发件人密码
$SmtpRecipients = "gongyuanping@contoso.com","sunhailiang@contoso.com" #定义收件人
$SmtpCCRecipients =  "tangtianhao@contoso.com"  #定义同时抄送的收件人。如果不需要CC，请输入$Null
$SmtpPwdSec = convertto-securestring "$SmtpPwdPlain" -asplaintext -force
$SmtpCred = new-object -typename System.Management.Automation.PSCredential -argumentlist "$SmtpUser",$SmtpPwdSec
$Body = "<font face='$Font' color='Blue' size='2'><strong>请查看附件的服务器磁盘空间使用报表，一旦有红色警告，请务必登录服务器进行处理。</strong></font></p>
</br><font face='$Font' color='Gray' size='2'<I>注意：当可用空间的百分比：</br>
# 大于等于$Warning`时说明磁盘空间充足,无需处理，以绿色显示；</br>
# 小于等于$Critical`时说明严重不足,急需处理，以红色显示；</br>
# 大于$Critical`小于$Warning`说明磁盘空间尚可，需要关注，以黄色显示。</I></br></font>" #定义邮件正文
Send-MailMessage  -from $SmtpUser -to  $SmtpRecipients -cc $SmtpCCRecipients -Subject "$Title" -body $Body -bodyashtml -SmtpServer $SmtpServer -Priority high -Encoding ([system.text.encoding]::utf8) -Credential $SmtpCred -Attachments $OutFile
}
