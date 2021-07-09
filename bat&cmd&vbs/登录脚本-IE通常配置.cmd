@echo off

rem IE配置包含"关闭弹出窗口阻止程序" "取消IE安全设置-站点-对该区域中的所有站点要求服务器验证https" 信任站点activex 配置 "添加域名式" "从位于一下位置的其他程序打开链接 1表示当前窗口中的新选项卡" "遇到弹出窗口时，始终在新选项卡中打开弹出窗口 2表示始终在新选项卡中打开弹出窗口" "当创建新选项卡时，始终切换到新选项卡" "打开代理" "排除网站+本地" "通用这个代理"



rem 关闭弹出窗口阻止程序

reg add "HKCU\Software\Microsoft\Internet Explorer\New Windows" /v PopupMgr /t REG_dword /d 0 /f 



rem 取消IE安全设置-站点-对该区域中的所有站点要求服务器验证https

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v Flags /t Reg_DWORD /d 67 /f



rem 信任站点activex 配置

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v CurrentLevel /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 1001 /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 1004 /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 1201 /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 1209 /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 120A /t REG_DWORD /d 0 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 120B /t REG_DWORD /d 3 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\zones\2" /v 2201 /t REG_DWORD /d 0 /f



echo 添加域名式 http://www.qq.com

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\qq.com\www" /v http /t Reg_DWORD /d 2 /f



rem 从位于一下位置的其他程序打开链接 1表示当前窗口中的新选项卡

reg add "HKCU\Software\Microsoft\Internet Explorer\TabbedBrowsing" /v ShortcutBehavior /t REG_Dword /d 1 /f 



rem 遇到弹出窗口时，始终在新选项卡中打开弹出窗口 2表示始终在新选项卡中打开弹出窗口

reg add "HKCU\Software\Microsoft\Internet Explorer\TabbedBrowsing" /v PopupsUseNewWindow /t REG_Dword /d 2 /f



rem 当创建新选项卡时，始终切换到新选项卡

reg add "HKCU\Software\Microsoft\Internet Explorer\TabbedBrowsing" /v Openinforeground /t REG_Dword /d 1 /f