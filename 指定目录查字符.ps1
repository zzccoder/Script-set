#This Script is useful for list the Character that list in file content
#执行方式如下：
#.\filesearch.ps1 -searchstring "寻找字符" -SearchLocation "寻找路径"
param
(
[string] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#转到POWERSHELLL 执行路径
$Filename=Get-ChildItem *.* -include *.txt -Recurse |Select-String -Pattern $searchstring|select filename
#采用递归方式获取当前文件中有SearchString的文件
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#生成日志文件名字
$Filename |Export-Csv -Path $Logfile -Encoding default
#将结果导出为日志





#This Script is useful for list the Character that list in file content
#执行方式如下：
#.\filesearch.ps1 -searchstring "寻找字符" -SearchLocation "寻找路径"
param
(
[string] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#转到POWERSHELLL 执行路径
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#获取当前的生成日志文件名称
$filegroups=Get-ChildItem  -include *.txt -Recurse|Select-String -Pattern $searchstring|Group-Object -Property:path|select name,count
#分组获取当前有相关的patten的参数的文件及文件拥有的行数
$filepropertys=@()
#定义文件属性数组为空
foreach($filegroup in $filegroups)
#根据查询到的文件进行轮询
{
$Filename=$filegroup.name
#得出文件的路径
$filecount="含指定的字符串"+$searchstring+"    "+$filegroup.count+"行"
#告知字符串在指定文件中的哪一行
$fileproperty=New-Object psobject
#新建属性对象
$fileproperty|Add-member -MemberType NoteProperty -Name "Filename" -Value $Filename
#为对象新建列名
$fileproperty|Add-Member -MemberType NoteProperty  -Name "Count" -Value $filecount
#为对象新建列名
$filepropertys=$filepropertys+$fileproperty
#将字符串数组队列进行自动累计
}

$filepropertys |Export-Csv -Path $Logfile -Encoding default
#将文件对象导出问日志文件





#执行方式如下：.\filecountstring.ps1 -searchstring 寻找的字符串  -SearchLocation 寻找文件的目录
param
(
[regex] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#转到POWERSHELLL 执行路径
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#获取当前的生成日志文件名称
$filetotals=(Get-ChildItem -Include *.txt -Recurse).fullname
#获取文件及文件路径
$fileproperty=@()
#定义属性为空
foreach($filetotal in $filetotals)
#根据日志查询
{
$FileALLP=New-Object psobject
#新建PS对象
$filecontent=Get-Content -Path $filetotal
#获取的对象的目录文本
$filecount=(Select-String -Pattern $searchstring -InputObject $filecontent -AllMatches).matches.count
#根据寻找的字符串统计字符串个数
$filecontentstring="含指定的字符串"+$searchstring+"   "+$filecount+"个"
#求出日志格式
$FileALLP |Add-Member -MemberType NoteProperty -Name "文件路径" -Value $filetotal
#添加对象的文件路径属性
$FileALLP |Add-Member -MemberType NoteProperty -Name "拥有字符串数量" -Value $filecontentstring
#添加拥有字符串数量属性
$fileproperty=$fileproperty+$FileALLP
#将对象进行数组累加
}
$fileproperty | Export-Csv -encoding default -Path $Logfile
将日志导出为相关的文本文件





param
(
[regex] $searchstring,
[regex] $replcestring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#转到POWERSHELLL 执行路径
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#获取当前的生成日志文件名称
$filetotals=(Get-ChildItem -Include *.txt -Recurse).fullname
foreach($filetotal in $filetotals)
{
$filecontent=Get-Content -Path $filetotal
$filecontent -replace $searchstring,$replcestring |Set-Content $filetotal
}