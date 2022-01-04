$days = 14
$dirs=@(
"C:\inetpub\logs\LogFiles\",
"C:\Program Files\Microsoft\Exchange Server\V15\Logging\",
"C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\ETLTraces\",
"C:\Program Files\Microsoft\Exchange Server\V15\Bin\Search\Ceres\Diagnostics\Logs\",
"C:\Program Files\Microsoft\Exchange Server\V15\TransportRoles\Logs\"
)
Get-ChildItem $dirs -Recurse -File | Where-Object { $_.Name -like "*.log" -or $_.Name -like "*.blg" -or $_.Name -like "*.etl" } | Where-Object LastWriteTime -lt (Get-Date).AddDays(-$days) | Remove-Item -ErrorAction "SilentlyContinue"



set-location c:\inetpub\logs\LogFiles\W3SVC1\
foreach ($File in get-childitem) {
if ($File.LastWriteTime -lt (Get-Date).AddDays(-28)) {
del $File
}
}


#----- 每日性能日志-----#
#----- 定义参数-----#
#----- 获取当前日期----#
$Now = 获取日期
#----- 定义天数----#
$Days = "3"
#----- 定义文件所在的文件夹----#
$TargetFolder = "C:\Program Files\Microsoft\Exchange Server\V15\Logging\Diagnostics\DailyPerformanceLogs"
#----- 定义扩展----#
$Extension = "*.blg"
#----- 根据 $Days 定义 LastWriteTime 参数 ---#
$ LastWrite = $ Now.AddDays (- $ Days)
$Files = Get-Childitem $TargetFolder -Include $Extension -Recurse | 其中 {$_.LastWriteTime -le "$LastWrite"}
删除项目 $Files

#----- W3SVC1 文件夹-----#
#----- 定义文件所在的文件夹----#
$TargetFolder1 = "C:\inetpub\logs\LogFiles\W3SVC1"
#----- 定义扩展----#
$Extension1 = "*.log"
#----- 根据 $Days 定义 LastWriteTime 参数 ---#
$ LastWrite = $ Now.AddDays (- $ Days)
$Files1 = Get-Childitem $TargetFolder1 -Include $Extension1 -Recurse | 其中 {$_.LastWriteTime -le "$LastWrite"}
删除项目 $Files1

#----- W3SVC2 文件夹-----#
#----- 定义文件所在的文件夹----#
$TargetFolder2 = "C:\inetpub\logs\LogFiles\W3SVC2"
#----- 定义扩展----#
$Extension2 = "*.log"
#----- 根据 $Days 定义 LastWriteTime 参数 ---#
$ LastWrite = $ Now.AddDays (- $ Days)
$Files2 = Get-Childitem $TargetFolder2 -Include $Extension2 -Recurse | 其中 {$_.LastWriteTime -le "$LastWrite"}
删除项目 $Files2