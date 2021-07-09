@echo off
color 2f
title 请用系统管理员权限运行此脚本 
rem 允许ps运行自定义脚本
echo.
echo.
echo.
echo.
:start
cls
echo.
echo.
echo.
echo.                 此脚本适用于Windows20012R2 部分兼容Windows2008R2
echo.                 输入以下数字选择操作
echo.                 1.创建第一台Win2012R2 AD域控制器
echo.                   1.1  安装额外域控
echo.                   1.2  从可写域控制器制作额外域控/RODC安装介质
echo.                       1.2.1  通过安装介质安装额外域控
echo.                       1.2.2  安装RODC只读域控
echo.                              1.2.2.1 查看RODC本地管理员组/增加账号至RODC本地管理员组
echo.                       1.2.3 安装额外域树
echo.                       1.2.4 安装子域
echo.                   1.3  卸载额外域控
echo.                       1.3.1  清理不使用的服务器的对象
echo.                       1.3.2  卸载林内额外域树最后一个域控
echo.                       1.3.3  卸载子域最后一个域控
echo.                       1.3.4  卸载RODC只读域控
echo.                   1.4  检查DNS SRV记录
echo.                   1.5  检查NTDS.dit是否创建以及SYSVOL文件夹是否成功创建及共享
echo.                   1.6  查询域5大角色及GC/全球编录服务器的位置
echo.                   1.7  查看林功能级别和域功能级别
echo.                          1.7.1  提升林功能级别和域功能级别
echo.                   1.8  注册控制台中的ACtiveDirectory 架构
echo.                   1.9  PDC模拟器时间同步设定与查询
echo.                   1.10 执行AD数据库的移动（谨慎操作）
echo.                   1.11 执行AD数据库脱机重组（谨慎操作）  
echo.                   1.12 执行AD数据库语义分析
echo.                 2.修改目录还原模式密码
echo.                 3.重启直接进入目录还原模式/重启进入正常模式
echo.                       3.1 进入目录还原模式修改域管理员密码
echo.                 4.配置自动获取或手动固定IP
echo.                 5.创建备份计划
echo.                 6.查看并修改Win7以上系统的SID
echo.                 7.Win2012桌面图标设置
echo.                 8.开启Win2008R2/2012R2 AD回收站功能
echo.                 9.脱机加入域
echo.                 10.强制更新组策略
echo.                    10.1 创建开机启动和登陆脚本
echo.                 11.添加开启启动程序
echo.                 12.强制更新组策略
echo.                    12.1 恢复默认域策略和默认域控制器策略至初始状态
echo.                    12.2 每日组策略备份计划
echo.                 13.每日存档DCDIAG检测报告
echo.                 14.更换域控IP地址 （谨慎操作）
echo.                   14.1 更换域控计算机名（谨慎操作）
echo.                 15.正常情况下转移操作主机角色 
echo.                   15.1 强制抢夺操作主机角色 （谨慎操作）
echo.                 16.服务器端强制修改域客户端电脑名
echo.                 99.退出



set  /p a=            输入数字:

if %a%==1 goto :创建第一台Win2012R2 AD域控制器
if %a%==1.1  goto :直接安装第一台额外域控
if %a%==1.2  goto :从可写域控制器制作额外域控/RODC安装介质
if %a%==1.2.1  goto :通过安装介质安装额外域控
if %a%==1.2.2  goto :安装RODC只读域控
if %a%==1.2.3  goto :安装额外域树
if %a%==1.2.4  goto :安装子域
if %a%==1.2.2.1 goto :查看RODC本地管理员组/增加账号至RODC本地管理员组
if %a%==1.3  goto :卸载额外域控
if %a%==1.3.1  goto :清理不使用的服务器的对象
if %a%==1.3.2  goto :卸载林内额外域树最后一个域控
if %a%==1.3.3  goto :卸载子域最后一个域控
if %a%==1.3.4  goto :卸载RODC只读域控
if %a%==1.4  goto :检查DNS SRV记录
if %a%==1.5  goto :检查NTDS.dit是否创建以及SYSVOL文件夹是否成功创建及共享
if %a%==1.6  goto :查询域5大角色及GC/全球编录服务器的位置
if %a%==1.7  goto :查看林功能级别和域功能级别
if %a%==1.7.1  goto :提升林功能级别和域功能级别
if %a%==1.8  goto 注册ACtiveDirectory架构控制台
if %a%==1.9  goto PDC模拟器时间同步设定与查询
if %a%==1.10 goto :执行AD数据库的移动（谨慎操作）
if %a%==1.11 goto 执行AD数据库脱机重组（谨慎操作）
if %a%==1.12 goto 执行AD数据库语义分析
if %a%==2 goto :修改目录还原模式密码
if %a%==3 goto :重启直接进入目录还原模式/重启进入正常模式
if %a%==3.1 goto :进入目录还原模式修改域管理员密码
if %a%==4 goto :脚本配置IP
if %a%==5 goto :创建备份计划
if %a%==6 goto :查看并修改Win7以上系统的SID
if %a%==7 goto :Win2012桌面图标设置
if %a%==8 goto :开启Win2008R2/2012R2AD回收站功能
if %a%==9 goto :脱机加入域
if %a%==10 goto :强制更新组策略
if %a%==10.1 goto :创建开机启动和登陆脚本
if %a%==11 goto :添加开机启动程序
if %a%==12 goto :强制更新组策略
if %a%==12.1 goto :恢复默认域策略和默认域控制器策略至初始状态
if %a%==12.2 goto :每日组策略备份计划
if %a%==13 goto :每日存档DCDIAG检测报告
if %a%==14 goto :更换域控IP地址
if %a%==14.1 goto :更改域控计算机名称
if %a%==15  goto 正常情况下转移操作主机角色
if %a%==15.1  goto 强制抢夺操作主机角色
if %a%==16 goto 服务器端强制修改域客户端电脑名
if %a%==99 goto exit


cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:执行AD数据库的移动（谨慎操作）
cls
echo 转移AD数据库ntds.dit至其他文件夹，多用于磁盘空间不够时。
echo 执行该操作会关闭ADDS服务，请确保还有其他DC在线，以免用户或本机锁定时无法登录。执行完毕后会再启动。
echo.               请再确认是否进行AD数据库的移动
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto ver1.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:ver1.1
set /p directory=输入要转移的目标目录 格式如 "C:\abc"：
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds

ntdsutil "activate instance ntds " "files" "info" "move db to %directory%" "move logs to %directory%" "integrity" "quit" "quit"

echo.
echo.
echo.                 输入以下数字选择操作
echo.                 1.提示"Integrity Check Successful"数据库完整性检查成功，直接退出；
echo.                 2.数据性完整性检查不成功，进行语义分析并尝试修复
echo.
echo.
echo.

set /p b= 输入数字:
if %b%==1 goto b1
if %b%==2 goto b2

:执行AD数据库脱机重组（谨慎操作）
cls
echo 脱机重整ADDS数据库，使数据排列更整齐，读取更快。同时会清空已删除对象占用的空间。
echo 执行该操作会关闭ADDS服务，请确保还有其他DC在线，以免用户或本机锁定时无法登录。执行完毕后会再启动。
echo.               请再确认是否进行AD数据库的重组
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto ver2.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:ver2.1
echo 
set /p directory0=输入要转移的目标目录 格式如 "C:\abc"：
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds
ntdsutil "activate instance ntds " "files" "info" "compact to %directory0%" "quit" "quit"
set /p directory2=输入原NTDS所在目录 默认是在"C:\windows\ntds":
set /p directory3=创建一个存放备份NTDS的文件夹 如"C:\ntdsbackup":
md %directory3%
rem 备份原ntds
copy %directory2%\ntds.dit %directory3% /y
rem 复制整理后的数据库覆盖原数据库
copy %directory0%\ntds.dit %directory2% /y
rd %directory0% /s /q
rem 删除原数据库文件夹中日志文件
del %directory2%\*.log  /q 
echo  下面将进行数据库语义分析
ping 127.0.0.1 -n 5 >nul
goto b2.1

:b1
net start ntds
goto exit

:执行AD数据库语义分析
cls
echo 该操作分析数据库是否有错误
echo 执行该操作会关闭ADDS服务，请确保还有其他DC在线，以免用户或本机锁定时无法登录。执行完毕后会再启动。
echo.
echo.               请再确认是否进行AD数据库的语义分析
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto b2.1
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:b2.1 
net stop "DNS Server"
net stop "Kerberos Key Distribution Center"
net stop "Intersite Messaging"
net stop "DFS Replication"
net stop ntds
ntdsutil "activate instance ntds " "semantic database analysis" "verbose on" "go fixup" "quit" "quit"  
echo.                 输入以下数字选择操作
echo.                 1.数据性语义分析成功,直接退出；
echo.                 2.数据性语义分析不成功，尝试修复
echo.
echo.
echo.
set /p c= 输入数字:
if %c%==1 goto c1
if %c%==2 goto c2

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:c1
net start ntds
goto exit

:c2
ntdsutil "activate instance ntds " "files" "info" "recover" "quit" "quit"
net start ntds
goto exit

:修改目录还原模式密码
cls
echo.               请再确认是否进行修改目录还原模式密码
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 修改目录还原模式密码2
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:修改目录还原模式密码2
cls
echo 需要满足密码复杂性要求
ntdsutil "set DSRM password" "reset password on server null" "quit" "quit"
echo 目录还原模式密码修改成功
echo 即将退出
pause >nul
goto exit

:重启直接进入目录还原模式/重启进入正常模式
cls
echo.
echo.               执行如下选择
echo.               1.重启直接进入目录还原模式（正常模式下适用）
echo                2.重启进入正常模式（目录还原模式适用）
echo.               3.返回首页
echo.               4.退出
set  /p a=            输入数字:
if %a%==1 goto 重启直接进入还原模式
if %a%==2 goto 重启进入正常模式
if %a%==3 goto start
if %a%==4 go to exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:重启直接进入还原模式
bcdedit /set safeboot dsrepair
goto reboot20160616
exit

:重启进入正常模式
bcdedit /deletevalue safeboot
goto reboot20160616
exit

:reboot20160616
cls
echo 1.立刻重启
echo 2.返回首页
echo 3.退出
set /p a=输入
if %a%==1 shutdown /r /t 00 /f
if %a%==2 goto start
if %a%==3 goto exit

:进入目录还原模式修改域管理员密码
cls
echo  进入目录还原模式修改域管理员密码
echo  输入域管理员密码的新密码，需满足密码复杂性要求.
set /p a=输入:
echo  net user administrator %a% >password.bat
echo  del %%0 >>password.bat
copy  password.bat %systemroot%\System32\GroupPolicy\Machine\Scripts\Startup /y 
del  password.bat /q
cls  
echo.
echo 显示批处理内容
echo.
type %systemroot%\System32\GroupPolicy\Machine\Scripts\Startup\password.bat
echo 请执行如下步骤:
echo 运行-gpedit.msc-计算机配置-windows配置-启动/关机脚本-启动-添加-浏览-password.bat
echo 输入任何键下一步
pause >nul
goto exit

:创建第一台Win2012R2 AD域控制器
cls
echo.    创建第一台Win2012R2 AD域控制器
echo.
echo.
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改电脑名
if %a%==2 goto 下一步
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改电脑名
cls
echo 输入新电脑名 电脑立刻重启
set /p mingzi=: 
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步
cls
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP 下一步

set /p ip= 输入选择
if %ip%==1 goto static
if %ip%==2 goto 创建第一台Win2012R2 AD域控制器2

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start



:创建第一台Win2012R2 AD域控制器2
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入域名后半部分，格式如"abc.com"，则输入"com"：
cls
echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.域名"%y%.%z%"
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步3
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步3
powershell.exe .\AD\installActivedirectory.ps1 -a %x% -b %y% -c %z%
echo 输入任何键退出
pause >nul
goto exit


cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:创建备份计划
cls
echo 需要启用WindowsServerBackup功能 
echo.
echo 1.执行启用
echo 2.直接下一步
echo 3.返回首页

set /p a=输入数字:
if "%a%" == "1"  powershell.exe Add-WindowsFeature Windows-Server-Backup &goto 1
if "%a%" == "2" goto 1
if "%a%" == "3" goto start

:1
cls
echo.               选择
echo.               0.执行一次系统状态备份
echo.               1.执行一次性文件夹备份
echo.               2.执行定期系统状态备份
echo.               3.执行定期文件夹备份
echo.               4.返回首页
echo.               5.退出
set  /p a=            输入数字:
if %a%==0 goto 一次性系统状态备份
if %a%==1 goto 一次性文件夹备份
if %a%==2 goto 定期系统状态备份
if %a%==3 goto 定期文件夹备份
if %a%==4 goto start
if %a%==5 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:一次性系统状态备份
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget=  如"F:" "\\192.168.1.1\abc":
wbadmin start backup -backuptarget:%backuptarget% -systemstate -quiet
pause 按任何键退出
goto :exit


:一次性文件夹备份
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
echo. 输入需要备份的源磁盘或文件夹 谨慎输入
set /p backuptarget2=  如"D:\abc"       :
wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet 
pause 按任何键退出
goto :exit


:定期系统状态备份
cls
echo.               选择复制频率
echo.               1.每日备份
echo.               2.每周备份
echo.               3.每月备份
echo.               4.返回首页
echo.               5.退出
set  /p a=            输入数字:
if %a%==1 goto 每日备份
if %a%==2 goto 每周备份
if %a%==3 goto 每月备份
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:每日备份
cls
set pinlv=daily
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
set /p time=输入备份时间 格式"22:00"     :
echo @echo off >%~dp0daily.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0daily.bat
set /p weizhi=任务计划用磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划系统状态备份用文件夹
copy %~dp0daily.bat %weizhi%\任务计划系统状态备份用文件夹
schtasks /create /sc %pinlv%  /tn DailySystemstate /tr "%weizhi%\任务计划系统状态备份用文件夹\daily.bat" /st %time% /rl highest 
del %~dp0daily.bat /q
pause 
goto :exit

:每周备份
set pinlv=weekly
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入 使用英文
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
set /p time=输入备份时间 格式"22:00"      :
set /p date=输入备份日期 格式"MON，TUE，WED，THU，FRI，SAT，SUN" "mon,tue": 
echo @echo off >%~dp0weekly.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0weekly.bat
set /p weizhi=任务计划用磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划系统状态备份用文件夹
copy %~dp0weekly.bat %weizhi%\任务计划系统状态备份用文件夹
schtasks /create /sc %pinlv%  /d %date%   /tn WeeklySystemstate /tr "%weizhi%\任务计划用文件夹\weekly.bat"  /st %time% /rl highest
del %~dp0weekly.bat /q
pause 
goto :exit

:每月备份
set pinlv=monthly
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入 使用英文
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
set /p time=输入备份时间 格式"22:00" :
set /p date=输入备份日期 每月第N天，格式为数字1-31任一:
echo @echo off >%~dp0monthly.bat
echo wbadmin start backup -backuptarget:%backuptarget1% -systemstate -quiet >>%~dp0monthly.bat
set /p weizhi=任务计划用磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划系统状态备份用文件夹
copy %~dp0monthly.bat %weizhi%\任务计划系统状态备份用文件夹
schtasks /create /sc %pinlv%  /d %date%   /tn MonthlySystemstate /tr "%weizhi%\任务计划用文件夹\monthly.bat"  /st %time% /rl highest
del %~dp0monthly.bat /q
pause 
goto :exit

:定期文件夹备份
cls
echo.               选择复制频率
echo.               1.每日备份
echo.               2.每周备份
echo.               3.每月备份
echo.               4.返回首页
echo.               5.退出
set  /p a=            输入数字:
if %a%==1 goto 每日备份
if %a%==2 goto 每周备份
if %a%==3 goto 每月备份
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:每日备份
cls
set pinlv=daily
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
echo. 输入需要备份的源磁盘或文件夹 谨慎输入
set /p backuptarget2=  如"D:\abc"       :
set /p time=输入备份时间 格式"22:00"     :
echo @echo off >%~dp0daily.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet >>%~dp0daily.bat
set /p weizhi=存放任务计划用脚本磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划文件夹备份用文件夹
copy %~dp0daily.bat %weizhi%\任务计划文件夹备份用文件夹
schtasks /create /sc %pinlv%  /tn DailyFile /tr "%weizhi%\任务计划文件夹备份用文件夹\daily.bat" /st %time% /rl highest 
del %~dp0daily.bat /q
pause 按任何键退出
goto :exit

:每周备份
cls
set pinlv=weekly
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
echo. 输入需要备份的源磁盘或文件夹 谨慎输入
set /p backuptarget2=  如"D:\abc"       :
set /p time=输入备份时间 格式"22:00"     :
set /p date=输入备份日期 格式"MON，TUE，WED，THU，FRI，SAT，SUN" "mon,tue": 
echo @echo off >%~dp0weekly.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet >>%~dp0weekly.bat
set /p weizhi=存放任务计划用脚本磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划文件夹备份用文件夹
copy %~dp0weekly.bat %weizhi%\任务计划文件夹备份用文件夹
schtasks /create /sc %pinlv% /D %date% /tn WeeklyFile /tr "%weizhi%\任务计划文件夹备份用文件夹\weekly.bat" /st %time% /rl highest 
del %~dp0weekly.bat /q
pause 按任何键退出
goto :exit

:每月备份
set pinlv=monthly
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入 使用英文
set /p backuptarget1=  如"F:" "\\192.168.1.1\abc"     :
echo. 输入需要备份的源磁盘或文件夹 谨慎输入 
set /p backuptarget2=  如"D:\abc"       :
set /p time=输入备份时间 格式"22:00" :
set /p date=输入备份日期 每月第N天，格式为数字1-31任一:
echo @echo off >%~dp0monthly.bat
echo wbadmin start backup -backuptarget:%backuptarget1%  -include:%backuptarget2% -quiet>>%~dp0monthly.bat
set /p weizhi=存放任务计划用脚本磁盘 只需输入磁盘即可 格式如如 "E:"       :
md %weizhi%\任务计划文件夹备份用文件夹
copy %~dp0monthly.bat %weizhi%\任务计划文件夹备份用文件夹
schtasks /create /sc %pinlv%  /d %date%   /tn MonthlyFile /tr "%weizhi%\任务计划文件夹备份用文件夹\monthly.bat"  /st %time% /rl highest
del %~dp0monthly.bat /q
pause 按任何键退出
goto :exit

:查看并修改Win7以上系统的SID
cls
echo      将一个虚拟机直接复制，用虚拟机软件打开的话，两个用户的SID是完全一致的
echo      通过修改系统SID来改变用户SID
echo.     执行第二部操作会还原所有配置删除当前用户下所有数据，请一定注意！
echo.
echo      查看并修改Win7以上系统的SID
echo.     1.只查看当前用户的SID
echo.     2.保存当前用户的SID到当前目录下并执行修改SID，5S后重启
echo.     3.已经通过Sysoprep命令修改了SID，查看当前的SID，对比未修改前的SID
echo.     4.返回首页
echo.     5.退出
set  /p a=            输入数字:
if %a%==1 goto 只查看当前用户的SID
if %a%==2 goto 保存且修改 
if %a%==3 goto 对比SID
if %a%==4 goto start
if %a%==5 goto exit 

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:只查看当前用户的SID
cls
echo 只查看当前用户的SID
whoami /user 
pause 按任意按键退出
goto :exit

:保存且修改
cls
echo 保存当前用户的SID到当前目录下并执行修改SID，5S后重启 
whoami /user 
set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
echo %y% >%~dp0whoamisid.txt
echo 为更改前的SID >>%~dp0whoamisid.txt
whoami /user >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
echo. >>%~dp0whoamisid.txt
%systemroot%\system32\sysprep\sysprep.exe /quiet /generalize /oobe /reboot
goto exit

:对比SID
cls
echo 已经通过Sysoprep命令修改了SID，查看当前的SID，对比未修改前的SID
set y=%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
echo %y% >>%~dp0whoamisid.txt
echo 更改后的的SID >>%~dp0whoamisid.txt
whoami /user >>%~dp0whoamisid.txt
type %~dp0whoamisid.txt
pause 按任何键删除该txt并退出
del %~dp0whoamisid.txt /q
goto exit 

:Win2012桌面图标设置
rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
goto exit


:脚本配置IP
cls
echo     此脚本可以帮助你设置本机IP  输入数字后回车即可 
echo.
echo.     
echo     1.自动获取IP
echo     2.固定IP
echo     3.退出   
set /p a=输入:
if "%a%"=="1" goto dhcp
if "%a%"=="2" goto static
if "%a%"=="3" goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start


:dhcp
cls
echo 配置自动获取IP
set /p  net1=        输入网络适配器名称(默认为本地连接):
netsh interface ip set address name="%net1%" source=dhcp 
netsh interface ip set dns name="%net1%" source=dhcp
pause 输入任何按键后退出
goto exit

:static
cls 
echo 配置固定IP
set /p ip1=          输入固定IP:
set /p mark1=        输入子网掩码:
set /p router1=      输入默认网关:
set /p dns1=         输入首选DNS:
set /p dns2=         输入次选DNS:
set /p  net1=        输入网络适配器名称(默认为本地连接):

cls
echo 您的输入结果如下：
echo %ip1%
echo %mark1%
echo %router1%
echo %dns1%
echo %dns2%
echo %net1%
echo.
echo.
echo 1.确认并执行
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 固定IP
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start


:固定IP
netsh interface ip set address name="%net1%" dhcp
netsh interface ip set dns name="%net1%" dhcp
netsh interface ip set address name="%net1%" static %ip1% %mark1% %router1% 1
netsh interface ip set dns name="%net1%" static %dns1% primary 
netsh interface ip add dns name="%net1%" %dns2% index=2 
pause 输入任何按键后退出
goto :exit

:开启Win2008R2/2012R2AD回收站功能
cls
echo 如果是Win2008R2，运行该脚本前请确认已经林功能和域功能级别升级到Win2008R2
echo 按任何键继续
pause >nul
set /p y=输入域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入域名后半部分，格式如"abc.com"，则输入"com"：
powershell.exe .\ad\recycle.ps1 -a %y% -b %z%
echo Win2008R2回收站功能过于繁琐，推荐使用第三方工具ADRestore.msi 它可以在不开启回收站的情况下恢复AD删除对象 并且资料不会丢失
echo 按任何按键退出
pause >nul
goto :exit

:查询域5大角色及GC/全球编录服务器的位置
cls
echo.
echo.
echo 查询域5大角色及GC/全球编录服务器的位置
echo.
echo.
echo 5大角色
netdom query fsmo
echo.
echo 域内GC/全球编录服务器
dsquery server -isgc
echo.
echo 林内GC/全球编录服务器
powershell.exe  "Get-ADForest | FL GlobalCatalogs"
echo 按任何按键退出
pause >nul
goto exit

:从可写域控制器制作额外域控/RODC安装介质
cls
echo. 
echo 利用安装介质来安装额外域控.多用于异地安装或网络传输速度较慢。
echo 制作安装介质

echo.
echo 1.制作可写域控制器安装介质，存储到当前英文目录文件夹下
echo 2.制作只读域控制器(RODC)安装介质，存储到英文目录文件夹下
echo.
set /p a=输入数字:
if "%a%" == "1" goto :制作可写域控制器安装介质
if "%a%" == "2" goto :制作只读域控制器(RODC)安装介质

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:制作可写域控制器安装介质
set /p a=输入目标文件夹路径（不可包含中文等字符），例如"D:\InstallationMediaFull":
ntdsutil "activate instance ntds" "ifm" "create sysvol full %a%" "quit" "quit"
echo  按任何键退出
pause >nul
goto exit

:制作只读域控制器(RODC)安装介质
cls
echo.
set /p a=输入目标文件夹路径（不可包含中文等字符），例如"D:\InstallationMediaRODC":
ntdsutil "activate instance ntds" "ifm" "create sysvol RODC %a%" "quit" "quit"
echo  按任何键退出
pause >nul
goto exit


:检查DNS SRV记录
cls
echo 如需完整SRV记录 请右击【正向查找区域】中的域名目录，选择区域传送，允许所有服务器。
echo “使用如下命令nslookup  set type=srv  ls -t srv %userdnsdomain%”
echo  按任何键继续
pause >nul
echo 检查DNS SRV 记录
echo set type=srv >nslookup.txt
echo. >>nslookup.txt
echo _gc._tcp.%userdnsdomain% >>nslookup.txt
echo.  >>nslookup.txt
echo _ldap._tcp.%userdnsdomain% >>nslookup.txt
echo.  >>nslookup.txt
echo _kerberos._tcp.%userdnsdomain% >>nslookup.txt
echo. >>nslookup.txt
cls
nslookup <nslookup.txt  >SRV.txt
del nslookup.txt /q /f 
type srv.txt
echo  按任何键退出
pause >nul
del srv.txt /q /f 
goto exit

:检查NTDS.dit是否创建以及SYSVOL文件夹是否成功创建及共享
cls
echo.
echo 检查NTDS.dit是否创建
echo.
dir %systemroot%\NTDS\ /b /w
echo.
echo --------------------------------------------------------
echo.
echo 检查SYSVOL文件夹是否成功创建及共享
dir %systemroot%\sysvol\sysvol /b /w
net share
pause >nul
goto exit


:直接安装第一台额外域控
cls
echo.    创建额外域控
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改额外域控电脑名
if %a%==2 goto 下一步0609
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改额外域控电脑名
cls
echo.
echo 输入新电脑名 电脑立刻重启
set /p mingzi= 请输入：
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步0609
cls
echo.
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP，再下一步
set /p ip= 输入选择:
if %ip%==1 goto static
if %ip%==2 goto 下一步06092

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步06092
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:
cls
echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步06093
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步06093
powershell.exe .\AD\installBackupActivedirectory.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo 输入任何键退出
pause >nul
goto exit

:通过安装介质安装额外域控
cls
echo.    通过安装介质安装额外域控
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改额外域控电脑名06092317
if %a%==2 goto 下一步06092317
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改额外域控电脑名06092317
cls
echo.
echo 输入新电脑名 电脑立刻重启
set /p mingzi= 请输入：
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步06092317
cls
echo.
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP，再下一步
set /p ip= 输入选择:
if %ip%==1 goto static
if %ip%==2 goto 下一步06092318

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步06092318
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:
set /p zz=输入安装介质所在目录，格式如"D:\installationmedia":
cls
echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.安装介质所在目录：%zz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步06092320
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步06092320
powershell.exe .\AD\installBackupActivedirectoryfrominstallationmedia.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %zz%
echo 输入任何键退出
pause >nul
goto exit



:卸载额外域控
cls
echo.
echo 卸载额外域控
echo.
echo.
echo.               请再确认卸载额外域控
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo 卸载林内额外域树最后一个域控
set /p x=输入卸载后本地管理员密码,需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入主域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入主域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:

cls
echo 您输入的是
echo 本地管理员密码 "%x%"
echo.主域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步07081458
powershell.exe .\AD\uninstallBackupActivedirectory.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo 输入任何键退出
pause >nul
goto exit



:下一步07081458
:卸载林内额外域树最后一个域控
cls
echo.
echo 卸载林内额外域树最后一个域控
echo.
echo.
echo.               请再确认是否卸载林内额外域树最后一个域控
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:20160708
cls
echo 卸载林内额外域树最后一个域控
set /p x=输入卸载后本地管理员密码,需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入林域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入林域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:

cls
echo 您输入的是
echo 本地管理员密码 "%x%"
echo.林域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步07081458
powershell.exe .\AD\uninstallSecondDomainTree.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo 输入任何键退出
pause >nul
goto exit

:卸载子域最后一个域控
cls
echo.
echo 卸载子域最后一个域控
echo.
echo.
echo.               请再确认是否卸载卸载子域最后一个域控
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo 卸载林内额外域树最后一个域控
set /p x=输入卸载后本地管理员密码,需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入父域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入父域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:

cls
echo 您输入的是
echo 本地管理员密码 "%x%"
echo.父域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步07081458
powershell.exe .\AD\uninstallChildDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo 输入任何键退出
pause >nul
goto exit

:卸载RODC只读域控
cls
echo.
echo 卸载RODC只读域控
echo.
echo.
echo.               请再确认是否卸载RODC只读域控
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 20160708
if %a%==2 goto start
if %a%==3 goto exit

:20160708
cls
echo 卸载RODC只读域控
set /p x=输入卸载后本地管理员密码,需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入主域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入主域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:

cls
echo 您输入的是
echo 本地管理员密码 "%x%"
echo.主域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07081458
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步07081458
powershell.exe .\AD\uninstallRODC.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% 
echo 输入任何键退出
pause >nul
goto exit


:安装RODC只读域控
cls
echo 安装RODC只读域控
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改额外域控电脑名0612
if %a%==2 goto 下一步0612
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改额外域控电脑名0612
cls
echo.
echo 输入新电脑名 电脑立刻重启
set /p mingzi= 请输入：
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步0612
cls
echo.
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP，再下一步
set /p ip= 输入选择:
if %ip%==1 goto static
if %ip%==2 goto 下一步0612

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步0612
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入父域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入父域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:
set /p leo=输入作为RODC本地管理员的帐号，格式如"test":

echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo.RODC管理员帐号：%leo%
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步06121606
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步06121606
powershell.exe ".\AD\installRodcDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo 输入任何键退出
pause >nul
goto exit

:查看林功能级别和域功能级别
cls
echo.
echo. 查看林功能级别和域功能级别
echo.
echo 林功能级别
powershell.exe "Get-ADForest | Select-Object Forestmode"

echo 域功能级别
powershell.exe "Get-ADDomain | Select-Object Domainmode"
echo.
echo.
echo.
echo.
echo.
echo 输入任何键继续
pause >nul
cls
echo.
echo.
:提升林功能级别和域功能级别
cls
echo 1.提升林功能级别
echo 2.提升域功能级别
echo 3.返回首页
echo 4.退出

set /p a=输入数字:
if %a%==1 goto 提升当前林功能级别
if %a%==2 goto 提升当前域功能级别
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start



:提升当前林功能级别
cls
echo.
echo  提升当前林功能级别
echo 1.Windows2008R2Forest
echo 2.Windows2012R2Forest
echo 3.返回首页
echo 4.退出

set /p a=输入数字:

if "%a%" == "1" (set forestmode=Windows2008R2Forest)&goto 提升当前林功能级别2
if "%a%" == "2" (set forestmode=Windows2012R2Forest)&goto 提升当前林功能级别2
if "%a%" == "3" goto start
if "%a%" == "4" goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start

:提升当前林功能级别2
cls
powershell "Set-ADForestMode -ForestMode %forestmode% -Identity $env:USERDNSDOMAIN -Confirm:$false"
echo 输入任何键继续
pause >nul
cls
echo 继续提升域功能级别
echo 1.继续
echo 2.退出
set /p a=输入数字:
if "%a%" == "1" goto 提升当前域功能级别
if "%a%" == "2" goto exit


:提升当前域功能级别
cls
echo.
echo  提升当前域功能级别
echo 1.Windows2008R2Domain
echo 2.Windows2012R2Domain
echo 3.返回首页
echo 4.退出
echo.
set /p a=输入数字:
if "%a%" == "1" (set domainmode=Windows2008R2Domain)&goto 提升当前域功能级别2
if "%a%" == "2" (set domainmode=Windows2012R2Domain)&goto 提升当前域功能级别2
if "%a%" == "3" goto start
if "%a%" == "4" goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start

:提升当前域功能级别2
cls
powershell "Set-ADDomainMode -DomainMode %domainmode% -Identity $env:USERDNSDOMAIN -Confirm:$false"
echo 命令执行完毕
echo 输入任何键退出
pause >nul
goto exit

:查看RODC本地管理员组/增加账号至RODC本地管理员组
cls
echo 查看RODC本地管理员组
dsmgmt "local roles" "show role administrators" "quit" "quit"
echo.
echo.
echo 是否执行编辑账号操作
echo 1.增加账号至RODC本地管理员组
echo 2.从RODC本地管理移除账号
echo 3.返回首页
echo 4.退出
echo.
echo.
set /p a= 输入：
if %a%==1 goto 增加账号至RODC本地管理员组
if %a%==2 goto 从RODC本地管理移除账号
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start

:增加账号至RODC本地管理员组
cls
echo.
echo 增加账号至RODC本地管理员组
echo.
set /p a=输入要添加的账号，格式如"abc\user":
echo.
dsmgmt "local roles" "add %a% administrators" "show role administrators" "quit" "quit"
echo 输入任何键退出
pause >nul
goto exit

:从RODC本地管理移除账号
cls
echo 从RODC本地管理移除账号
echo.
set /p a=输入要添加的账号，格式如"abc\user":
echo.
dsmgmt "local roles" "remove %a% administrators" "show role administrators" "quit" "quit"
echo.
echo.
echo 输入任何键退出
pause >nul
goto exit

:脱机加入域
cls
echo.
echo 脱机加入域
echo.

echo 1.域控上执行
echo 2.在目标机器上执行
echo 3.返回首页
echo 4.退出
echo.
echo.
set /p a= 输入：
if %a%==1 (set /p b=输入要加域的电脑名:)&(djoin /provision /domain %userdnsdomain% /machine %b% /savefile djoin.txt)&goto 20160614
if %a%==2 (djoin /requestODJ /loadfile djoin.txt /windowspath %systemroot% /localos)&goto 20160614
if %a%==3 goto start
if %a%==4 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start

:20160614
echo.
echo.
echo 输入任何键退出
pause >nul
goto exit

:强制更新组策略
cls
echo no | gpupdate /force

echo.
echo.
echo 输入任何键退出
pause >nul
goto exit


:创建开机启动和登陆脚本
cls
echo.
echo 创建开机启动和登陆脚本
echo @echo off >Startup.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%% >>Startup.bat
echo md "c:\%%y%%+%%computername%%"  >>Startup.bat
echo exit >>Startup.bat
echo.
echo @echo off >Logon.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%% >>Logon.bat
echo md "c:\%%y%%+%%username%%" >>Logon.bat
echo exit >>Logon.bat
echo 脚本制作完毕 在当前目录下
echo.
echo.
echo 输入任何键退出
pause >nul
goto exit


:添加开机启动程序
cls 
echo.
echo 1.添加开机启动项
echo 2.添加一次性开机启动项
set /p a=输入:
if %a%==1 goto run
if %a%==2 goto runonce

echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start

:run
cls
set /p name=输入注册表英文名:
set type=reg_sz
set /p router= 复制程序路径到此处,如:"c:\abc\qq.exe" : 

reg add HKLM\software\microsoft\windows\currentversion\run /v "%name%" /t "%type%" /d "%router%" /f
pause
goto exit

:runonce
cls 
set /p name=输入注册表英文名:
set type=reg_sz
set /p router= 复制程序路径到此处,如:"c:\abc\qq.exe" : 

reg add HKLM\software\microsoft\windows\currentversion\runonce /v "%name%" /t "%type%" /d "%router%" /f

pause
goto exit

:强制更新组策略
echo %time%
echo no | gpupdate /force
echo 继续刷新 退出请点右上角X
pause >nul
goto :强制更新组策略


:恢复默认域策略和默认域控制器策略至初始状态
cls
echo. 
echo.
echo 恢复默认域策略和默认域控制器策略至初始状态
echo 1.恢复默认域策略
echo 2.恢复默认域控制器策略
echo 3.两个都恢复
set /p a=输入：
if %a%==1 (dcgpofix /target:domain)&goto exit
if %a%==2 (dcgpofix /target:dc)&goto exit
if %a%==3 (dcgpofix /target:both)&goto exit

echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start


:安装额外域树
cls
echo.    创建额外域控
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改额外域控电脑名
if %a%==2 goto 下一步0704
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改额外域控电脑名
cls
echo.
echo 输入新电脑名 电脑立刻重启
set /p mingzi= 请输入：
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步0704
cls
echo.
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP，再下一步
set /p ip= 输入选择:
if %ip%==1 goto static
if %ip%==2 goto 下一步07042

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步07042
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入林域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入林域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:
set /p leo=输入新域树域前半部分，格式如"abc.com"，则输入"abc"：

cls
echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.林域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo 新域树域名 "%leo%.%z%"
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07043
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步07043
powershell.exe .\AD\installSecondDomainTree.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo 输入任何键退出
pause >nul
goto exit



:清理不使用的服务器的对象
cls
echo.
echo.
echo.
echo 即将执行从主域强制清理不使用的服务器的对象
echo.
echo 输入任何键继续 或按右上角X退出
pause >nul
set abc=%computername%
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "quit" "quit" "quit"
echo.
echo.
echo.
echo 请输入对应的站点序号 或点右上角X退出
set /p a=输入对应数字：
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "quit" "quit" "quit"
echo.
echo.
echo.
echo 请输入要删除的域序号 或点右上角X退出
set /p b=输入对应数字：
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "select domain %b%" "list servers for domain in site" "quit" "quit" "quit"
echo.
echo.
echo.
echo 请输入要删除的服务器序号 或点右上角X退出
set /p c=输入对应数字：
cls
"ntdsutil" "metadata cleanup" "connections" "connect to server %abc%" "quit" "select operation target" "list sites" "select site %a%" "list domains in site" "select domain %b%" "list servers for domain in site" "select server %c%" "quit" "remove selected server" "quit" "quit"
echo.
echo.
echo.
echo 服务器强制删除操作已经完成
echo 1.回首页
echo 2.退出

set /p a=输入数字:
if "%a%" == "1" goto start
if "%a%" == "2" goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:每日组策略备份计划
cls
set pinlv=daily
echo. 输入存放备份的目标磁盘或文件夹 谨慎输入
set /p backuptarget1=  如"F:\abc":
set /p time=输入备份时间 格式"22:00":
echo @echo off >%~dp0dailyGPO.bat
echo rd %backuptarget1% /s /q >>%~dp0dailyGPO.bat
echo md %backuptarget1%  >>%~dp0dailyGPO.bat
echo xcopy %%systemroot%%\sysvol\sysvol\%%userdnsdomain%%\policies %backuptarget1% /e >>%~dp0dailyGPO.bat
set /p weizhi=存放任务计划用脚本磁盘 只需输入磁盘即可 格式如如 "E:":
md %weizhi%\任务计划文件夹备份用文件夹
copy %~dp0dailyGPO.bat %weizhi%\任务计划文件夹备份用文件夹 /y
schtasks /create /sc %pinlv%  /tn DailyFile /tr "%weizhi%\任务计划文件夹备份用文件夹\dailyGPO.bat" /st %time% /rl highest 
del %~dp0dailyGPO.bat /q
pause 按任何键退出
goto :exit

:安装子域
cls
echo.    创建子域
echo 本机电脑名:   %computername%
echo                是否更改电脑名
echo.               1.更改
echo.               2.继续执行下一步
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更改额外域控电脑名
if %a%==2 goto 下一步0704
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更改额外域控电脑名
cls
echo.
echo 输入新电脑名 电脑立刻重启
set /p mingzi= 请输入：
powershell.exe set-executionpolicy remotesigned -force
powershell.exe Rename-Computer -newname "%mingzi%" -restart
echo 即将重启启动

:下一步0704
cls
echo.
echo 固定电脑IP及输入DNS(两个)
echo 1.前去固定IP
echo 2.已经固定好IP，再下一步
set /p ip= 输入选择:
if %ip%==1 goto static
if %ip%==2 goto 下一步07042

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:下一步07042
cls
set /p x=输入目录还原模式密码，需满足密码复杂性要求,格式如"Suzhou123":
set /p y=输入父域名前半部分，格式如"abc.com"，则输入"abc"：
set /p z=输入父域名后半部分，格式如"abc.com"，则输入"com"：
set /p xy=输入主域控的管理员名称，默认"administrator":
set /p xz=输入主域控的管理员密码:
set /p leo=输入子域前半部分，格式如"xx.abc.com"，则输入"xx"：

cls
echo 您输入的是
echo 目录还原模式密码 "%x%"
echo.父域名"%y%.%z%"
echo.主域控管理员账号密码：%xy%  %xz%
echo 子树域名 "%leo%.%y%.%z%"
echo.
echo.
echo 1.确认并执行下一步
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 下一步07043
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start


:下一步07043
powershell.exe .\AD\installChildDomain.ps1 -a %x% -b %y% -c %z% -d %y%\%xy% -e %xz% -f %leo%
echo 输入任何键退出
pause >nul
goto exit


:每日存档DCDIAG检测报告
cls
echo.
echo.
echo 每日存档DCDIAG检测报告
set pinlv=daily
set /p a=输入存放日志记录的磁盘，例如"D:" :
set /p time=输入备份时间 格式"22:00" :
set /p weizhi=任务计划用磁盘 只需输入磁盘即可 格式如如 "D:":
md %weizhi%\任务计划系统状态备份用文件夹
md %a%\DIDIAG每日存档
echo @echo off >dcdiag123.bat
echo set y=%%date:~0,4%%%%date:~5,2%%%%date:~8,2%%%%time:~0,2%%%%time:~3,2%%>>dcdiag123.bat
echo dcdiag /c ^>%a%\DIDIAG每日存档\%%y%%.txt >>dcdiag123.bat
echo exit >>dcdiag123.bat
copy %~dp0dcdiag123.bat %weizhi%\任务计划系统状态备份用文件夹
schtasks /create /sc %pinlv%  /tn DailyDcdiag /tr "%weizhi%\任务计划系统状态备份用文件夹\dcdiag123.bat" /st %time% /rl highest 
del %~dp0dcdiag123.bat /q
pause 按任何键退出
goto :exit

:更换域控IP地址
cls
echo.
echo.
echo 本操作会停止Netlogon服务 请确认后执行下一步
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 更换域控IP地址2
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:更换域控IP地址2
net stop netlogon 
goto static

:static
cls 
echo 配置固定IP

set /p ip1=          输入固定IP:
set /p mark1=        输入子网掩码:
set /p router1=      输入默认网关:
set /p dns1=         输入首选DNS:
set /p dns2=         输入次选DNS:
netsh interface ip show interfaces
set /p net1=         输入网络适配器名称(默认为本地连接):

cls
echo 您的输入结果如下：
echo %ip1%
echo %mark1%
echo %router1%
echo %dns1%
echo %dns2%
echo %net1%
echo.
echo.
echo 1.确认并执行
echo 2.返回首页

set /p a=输入数字:
if "%a%" == "1" goto 固定IP
if "%a%" == "2" goto start

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto :start


:固定IP
netsh interface ip set address name="%net1%" dhcp
netsh interface ip set dns name="%net1%" dhcp
netsh interface ip set address name="%net1%" static %ip1% %mark1% %router1% 1
netsh interface ip set dns name="%net1%" static %dns1% primary 
netsh interface ip add dns name="%net1%" %dns2% index=2 

ipconfig /flushdns

net start netlogon 

ipconfig /registerdns

cls
echo.
echo.
echo 请再执行如下操作
echo 0.在DNS管理器中删除原始IP的A记录和反向区域
echo 1.如果有DNS代理,需要手动更新代理区域的DNS服务器记录
echo 2.如果有其他dns服务器设置了forward到这些DC,需要修改对应的forward设置.
echo 3.如果还有其他DNS服务器和这台DNS服务器有区域复制,修改在那些DNS服务器上的记录
echo 4.如果域成员(服务器或者客户端)使用手动设置的IP地址,需要更新分别更新这些地址.如果使用DHCP,就需要修改对应的DHCP设置
goto exit


:更改域控计算机名称
cls
echo 更改域控计算机名称
echo 注：此操作会重启计算机
set /p a=输入修改后的计算机名:
netdom computername %computername%.%userdnsdomain% /add:%a%.%userdnsdomain%
netdom computername %computername%.%userdnsdomain% /makeprimary:%a%.%userdnsdomain%
echo.
echo.
echo 即将重启，请在重启后执行如下操作，进入DNS正向和反向区域中查看如有新旧计算机名对应的记录，则删除旧计算机名对应的记录。
echo 输入任何键重启
pause >nul
shutdown /r /t 00 /f 

:批量添加 
cls
echo.
echo 批量添加OU,Group,Users
echo.
echo.如果是第一次操作 请按照顺序执行
echo.               1.添加OUs
echo.               2.添加Groups
echo.               3.添加Users
echo.               4.退出
set  /p a=    输入数字:
if %a%==1 goto ous
if %a%==2 goto groups
if %a%==3 goto uers
if %a%==4 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start




:注册ACtiveDirectory架构控制台
cls
echo.
echo.
echo 本操作会注册AD架构控制台 方便MMC添加 请确认后执行下一步
echo.               1.确认
echo.               2.返回首页
echo.               3.退出
set  /p a=            输入数字:
if %a%==1 goto 20160827
if %a%==2 goto start
if %a%==3 goto exit

cls
echo.
echo.
echo 输入错误 按任何键回首页
pause >nul
goto start

:20160827
regsvr32 schmmgmt.dll
goto exit


:PDC模拟器时间同步设定与查询
cls
echo.
echo.               PDC模拟器时间同步设定与查询
echo.               1.查询当前同步时间源
echo.               2.查询时间源信息
echo.               3.手动与时间源同步
echo.               4.设定时间同步服务器
set  /p a=            输入数字:
if %a%==1 goto 1
if %a%==2 goto 2
if %a%==3 goto 3

:1
w32tm /query /source
echo.
echo 输入任何键返回主页
pause >nul
goto start

:2
w32tm /query /peers
echo 输入任何键返回主页
pause >nul
goto start

:3
w32tm /resync
echo 输入任何键返回主页
pause >nul
goto start

:4
cls 
echo  设定时间同步服务器
echo 输入任何键显示常用时间同步服务器 
echo 使用前请先ping测试网络联通性
pause >nul

echo NTP Server地址：
echo 常用：
echo 1.cn.pool.ntp.org
echo 2.cn.pool.ntp.org
echo 3.cn.pool.ntp.org
echo 0.cn.pool.ntp.org
echo cn.pool.ntp.org
echo tw.pool.ntp.org
echo 0.tw.pool.ntp.org
echo 1.tw.pool.ntp.org
echo 2.tw.pool.ntp.org
echo 3.tw.pool.ntp.org

echo 国内：
echo s2a.time.edu.cn 清华大学
echo s2b.time.edu.cn 清华大学
echo s2c.time.edu.cn 北京邮电大学
echo s2e.time.edu.cn 西北地区网络中心
echo s2f.time.edu.cn 东北地区网络中心
echo s2g.time.edu.cn 华东南地区网络中心
echo s2k.time.edu.cn CERNET桂林主节点
echo s2m.time.edu.cn 北京大学  ok


echo 输入任何键进入设定
pause >nul
set /p a=输入时间源地址1:
set /p b=输入时间源地址2:
w32tm /config /update /manualpeerlist:"%a% %b%" /syncfromflags:manual /reliable:Yes 

echo 输入任何键返回主页
pause >nul
goto start


:正常情况下转移操作主机角色
cls
echo.
echo 正常情况下转移操作主机角色
echo.
echo PDC模拟器操作主机=0
echo RID操作主机=1
echo 基础结构操作主机=2
echo 架构操作操作主机=3
echo 域命名操作主机=4
echo.
set /p a=输入转移至目标计算机的名称:
set /p b=需要转移的操作主机代码，多个主机用"，"隔开，如"1,2,3":
powershell Move-ADDirectoryServerOperationMasterRole -Identity "%a%" -OperationMasterRole %b% -Confirm:$false
echo.
echo.
echo.
echo 转移完后5大角色
netdom query fsmo
echo 输入任何键返回主页
pause >nul
goto start

:强制抢夺操作主机角色
cls
echo.
echo 强制抢夺操作主机角色
echo.
echo 注意：一旦架构操作主机、域命名操作主机或RID操作主机角色被夺取后，请永远不要将原来扮演这些操作主机角色的域控制器再连接到网络上。
echo.
echo PDC模拟器操作主机=0
echo RID操作主机=1
echo 基础结构操作主机=2
echo 架构操作操作主机=3
echo 域命名操作主机=4
echo.
set /p a=输入转移至目标计算机的名称:
set /p b=需要转移的操作主机代码，多个主机用"，"隔开，如"1,2,3":
powershell Move-ADDirectoryServerOperationMasterRole -Identity "%a%" -OperationMasterRole %b% -Confirm:$false -force
echo.
echo.
echo.
echo 转移完后5大角色
netdom query fsmo
echo 输入任何键返回主页
pause >nul
goto start

:服务器端强制修改域客户端电脑名
cls
echo.
echo NETDOM RENAMECOMPUTER 重命名计算机。如果计算机加入域，则还要重命名域中的
echo 计算机对象。某些服务(例如证书颁发机构)依赖固定的计算机名。
echo 如果任何这种类型的服务运行在目标计算机上，则计算机名更改会产生不利影响。
echo 此命令不应用于重命名域控制器。
echo.
echo.
set /p a=输入要修改的计算机名称:
set /p b=输入新计算机名: 
set /p c=输入林域名前半部分，格式如"abc.com"，则输入"abc"：
set /p d=输入主域控的管理员名称，默认"administrator":
set /p e=输入主域控的管理员密码:
echo 您输入的是
echo 要修改的计算机名:%a%
echo 新计算机名:%b%
echo.域名 %c%
echo.主域控管理员账号密码：%d% %e%
echo 输入任何键继续或按X退出
pause >nul
netdom renamecomputer "%a%" /newname:%b% /usero:%c%\%d% /passwordo:%e% /userd:%c%\%d% /passwordd:%e% /force
echo.
echo 目标客户端必须重启应用新计算机名
echo 输入任何键返回主页或按X退出
pause >nul
goto start


:exit
echo 输入任何键返回主页
pause >nul
goto start



