#This Script is useful for list the Character that list in file content
#ִ�з�ʽ���£�
#.\filesearch.ps1 -searchstring "Ѱ���ַ�" -SearchLocation "Ѱ��·��"
param
(
[string] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#ת��POWERSHELLL ִ��·��
$Filename=Get-ChildItem *.* -include *.txt -Recurse |Select-String -Pattern $searchstring|select filename
#���õݹ鷽ʽ��ȡ��ǰ�ļ�����SearchString���ļ�
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#������־�ļ�����
$Filename |Export-Csv -Path $Logfile -Encoding default
#���������Ϊ��־





#This Script is useful for list the Character that list in file content
#ִ�з�ʽ���£�
#.\filesearch.ps1 -searchstring "Ѱ���ַ�" -SearchLocation "Ѱ��·��"
param
(
[string] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#ת��POWERSHELLL ִ��·��
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#��ȡ��ǰ��������־�ļ�����
$filegroups=Get-ChildItem  -include *.txt -Recurse|Select-String -Pattern $searchstring|Group-Object -Property:path|select name,count
#�����ȡ��ǰ����ص�patten�Ĳ������ļ����ļ�ӵ�е�����
$filepropertys=@()
#�����ļ���������Ϊ��
foreach($filegroup in $filegroups)
#���ݲ�ѯ�����ļ�������ѯ
{
$Filename=$filegroup.name
#�ó��ļ���·��
$filecount="��ָ�����ַ���"+$searchstring+"    "+$filegroup.count+"��"
#��֪�ַ�����ָ���ļ��е���һ��
$fileproperty=New-Object psobject
#�½����Զ���
$fileproperty|Add-member -MemberType NoteProperty -Name "Filename" -Value $Filename
#Ϊ�����½�����
$fileproperty|Add-Member -MemberType NoteProperty  -Name "Count" -Value $filecount
#Ϊ�����½�����
$filepropertys=$filepropertys+$fileproperty
#���ַ���������н����Զ��ۼ�
}

$filepropertys |Export-Csv -Path $Logfile -Encoding default
#���ļ����󵼳�����־�ļ�





#ִ�з�ʽ���£�.\filecountstring.ps1 -searchstring Ѱ�ҵ��ַ���  -SearchLocation Ѱ���ļ���Ŀ¼
param
(
[regex] $searchstring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#ת��POWERSHELLL ִ��·��
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#��ȡ��ǰ��������־�ļ�����
$filetotals=(Get-ChildItem -Include *.txt -Recurse).fullname
#��ȡ�ļ����ļ�·��
$fileproperty=@()
#��������Ϊ��
foreach($filetotal in $filetotals)
#������־��ѯ
{
$FileALLP=New-Object psobject
#�½�PS����
$filecontent=Get-Content -Path $filetotal
#��ȡ�Ķ����Ŀ¼�ı�
$filecount=(Select-String -Pattern $searchstring -InputObject $filecontent -AllMatches).matches.count
#����Ѱ�ҵ��ַ���ͳ���ַ�������
$filecontentstring="��ָ�����ַ���"+$searchstring+"   "+$filecount+"��"
#�����־��ʽ
$FileALLP |Add-Member -MemberType NoteProperty -Name "�ļ�·��" -Value $filetotal
#��Ӷ�����ļ�·������
$FileALLP |Add-Member -MemberType NoteProperty -Name "ӵ���ַ�������" -Value $filecontentstring
#���ӵ���ַ�����������
$fileproperty=$fileproperty+$FileALLP
#��������������ۼ�
}
$fileproperty | Export-Csv -encoding default -Path $Logfile
����־����Ϊ��ص��ı��ļ�





param
(
[regex] $searchstring,
[regex] $replcestring,
[string] $SearchLocation
)
Set-Location $SearchLocation
#ת��POWERSHELLL ִ��·��
$Logfile="Result_"+(get-date).tostring("yyyyMMddhhmmss")+".csv"
#��ȡ��ǰ��������־�ļ�����
$filetotals=(Get-ChildItem -Include *.txt -Recurse).fullname
foreach($filetotal in $filetotals)
{
$filecontent=Get-Content -Path $filetotal
$filecontent -replace $searchstring,$replcestring |Set-Content $filetotal
}